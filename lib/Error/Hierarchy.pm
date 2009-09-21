package Error::Hierarchy;
use 5.006;
use warnings;
use strict;
use Carp;
use Data::UUID;
use Sys::Hostname;
use base 'Error::Hierarchy::Base';
our $VERSION = '0.07';
#<<<
__PACKAGE__
    ->mk_boolean_accessors(qw(is_optional acknowledged))
    ->mk_accessors(qw(
        message exception_hostname package filename line depth stacktrace uuid
    ));
#>>>

# properties() is used for introspection by code that's catching exceptions.
# This code can be left generic as each exception class will know its own
# properties. This is useful for something like gettext-based error messages.
# Of course, each exception class also supports its own message construction
# via message() and stringify(). Exception handling code can decide which
# message construction system it wants.
use constant default_message => 'Died';

# sub properties { () }     # empty list, base class defines no properties
sub error_depth { 1 }

sub init {
    my $self = shift;
    $self->message($self->default_message) unless $self->message;
    $self->depth(0)                        unless defined $self->depth;
    $self->is_optional(0)                  unless defined $self->is_optional;

    # init() code is based on Error::new(); we use a slightly different
    # scheme to set caller information. Error::throw() (our superclass) sets
    # $Error::Depth. We use $Error::Depth + 1 because we init() got called by
    # new(), so the call stack is one deeper than $Error::Depth indicates.
    my ($package, $filename, $line) =
      caller($Error::Depth + $self->error_depth + $self->depth);
    $self->exception_hostname(hostname());
    $self->package($package)   unless defined $self->package;
    $self->filename($filename) unless defined $self->filename;
    $self->line($line)         unless defined $self->line;
    $self->stacktrace(Carp::longmess);
    $self->uuid(Data::UUID->new->create_str);
}
sub get_properties { $_[0]->every_list('PROPERTIES') }

sub properties_as_hash {
    my $self = shift;
    my %p = map { $_ => (defined $self->$_ ? $self->$_ : 'unknown') }

      # hm... ask gr...
      grep { $_ ne 'package' && $_ ne 'filename' && $_ ne 'line' }
      $self->get_properties;
    wantarray ? %p : \%p;
}

sub stringify {
    my $self = shift;
    sprintf $self->message => map { $self->$_ || 'unknown' }
      $self->get_properties;
}

sub transmute {
    my ($class, $E, %args) = @_;
    bless $E, $class;

    # can't just %$E = (%$E, %args) because the accessors might do more than
    # set a hash value
    while (my ($key, $value) = each %args) {
        $E->$key($value);
    }
}

sub comparable {
    my $self = shift;
    $self->stringify;
}
1;
__END__



=head1 NAME

Error::Hierarchy - Support for hierarchical exception classes

=head1 SYNOPSIS

    package Error::Hierarchy::ReadOnlyAttribute;

    use warnings;
    use strict;

    use base 'Error::Hierarchy';

    __PACKAGE__->mk_accessors(qw(attribute));

    use constant default_message => '[%s] is a read only attribute';

    use constant PROPERTIES => ( 'attribute' );

# Meanwhile...

    package main;

    use Error::Hierarchy::Mixin;

    sub foo {
        if (@_) {
            Error::Hierarchy::ReadOnlyAttribute->
                throw(attribute => 'foo');
        }
    }

=head1 DESCRIPTION

This class provides support for hierarchical exception classes. It builds upon
L<Error> and is thus compatible with its C<try>/C<catch> mechanism. However,
it records a lot more information such as the package, filename and line where
the exception occurred, a complete stack trace, the hostname and a UUID.

It provides a stringification that is extensible with any properties your own
exceptions might define.

=head1 METHODS

=over 4

=item C<depth()>

Get or set the caller depth, that is the number of call stack frames that are
skipped when reporting the package, filename and line the error was thrown
from. When an exception object is constructed, it defaults to 0. This is
useful if you want to throw an exception from the perspective of your own
caller. For example:

    sub assert_foo {
        unless ($teh_foo) {
            throw SomeException(depth => 1);
        }
    }

Without the C<depth> argument, the exception would show that it was thrown
within C<assert_foo()>. Maybe that's what you want, but with C<depth()> you
can make it appear as if the exception was thrown from the place where
C<assert_foo()> was called from.

The actual exception depth is influenced by C<error_depth()> as well.

=item C<error_depth()>

Like C<depth()>, but here the value should be defined within the exception
class code itself. Therefore, you can't set the value, but subclasses can
override it. Some exceptions should always be thrown from the caller's
perspective (or even higher up); use C<error_depth()> for this case. C<depth()>
by contrast is intended for the user to be set; the two are added together to
get the actual depth. In this class the C<error_depth()> defaults to 1 so the
exception is at least reported from the place where it was actually thrown - a
value of 0 would mean that the exception is reported as having occurred
L<Error::Hierarchy> itself, which is probably not what you want.

If you override this value in a subclass, it's probably a good idea to add the
subclass' desired depth to the superclass's depth to accumulate it. For
example:

    package MyException;
    use base 'Error::Hierarchy';
    sub error_depth {
        my $self = shift;
        1 + $self->SUPER::error_depth();
    }

=item C<comparable()>

Support for L<Data::Comparable>.

=item C<init()>

Initializes a newly constructed exception object.

=item C<get_properties()>

Actual exception classes will subclass this class and define properties.
Exception classes themselves can be subclassed. So this method returns the
inherited list of all the exception class' properties.

=item C<properties_as_hash()>

Constructs a hash whose keys are the exception's properties - see
C<get_properties()> - and whose values are the values of each property in the
exception object. The properties C<package>, C<filename> and C<line> are
omitted.

In list context, the hash is returned as is. In scalar context, a reference to
the hash is returned.

=item C<stringify()>

Defines how the exception should look if the object is stringified. This class
inherits from L<Error::Hierarchy::Base>, which overloads C<""> to call
C<stringify()>.

This class stringifies an itself by taking the C<message()> attribute and
passing it to C<sprintf()>, along with the exception's properties.

=item C<transmute($exception, %args)>

Transmutes an existing exception. It leaves the stack trace, filename, line
etc. as it is and just blesses it into the class on which C<transmute()> was
called, adding the given additional arguments. This is used when catching a
generic exception and turning it into a more specific one.

=item C<acknowledged>

    $obj->acknowledged($value);
    my $value = $obj->acknowledged;

If called without an argument, returns the boolean value (0 or 1). If called
with an argument, it normalizes it to the boolean value. That is, the values
0, undef and the empty string become 0; everything else becomes 1.

=item C<acknowledged_clear>

    $obj->acknowledged_clear;

Clears the boolean value by setting it to 0.

=item C<acknowledged_set>

    $obj->acknowledged_set;

Sets the boolean value to 1.

=item C<clear_acknowledged>

    $obj->clear_acknowledged;

Clears the boolean value by setting it to 0.

=item C<clear_is_optional>

    $obj->clear_is_optional;

Clears the boolean value by setting it to 0.

=item C<is_optional>

    $obj->is_optional($value);
    my $value = $obj->is_optional;

Defines whether the exception is optional or mandatory. This isn't really part
of the exception itself, it has to do more with how you process the exception.
You might want to treat some exceptions as more important than others. But
it's nice to be able to set it within the exception object.

If called without an argument, returns the boolean value (0 or 1). If called
with an argument, it normalizes it to the boolean value. That is, the values
0, undef and the empty string become 0; everything else becomes 1.

=item C<is_optional_clear>

    $obj->is_optional_clear;

Clears the boolean value by setting it to 0.

=item C<is_optional_set>

    $obj->is_optional_set;

Sets the boolean value to 1.

=item C<set_acknowledged>

    $obj->set_acknowledged;

Sets the boolean value to 1.

=item C<set_is_optional>

    $obj->set_is_optional;

Sets the boolean value to 1.

=back

Error::Hierarchy inherits from L<Error::Hierarchy::Base>.

The superclass L<Error::Hierarchy::Base> defines these methods and
functions:

    new(), dump_as_yaml(), dump_raw()

The superclass L<Error> defines these methods and functions:

    _throw_Error_Simple(), associate(), catch(), file(), flush(), import(),
    object(), prior(), record(), text(), throw(), value(), with()

The superclass L<Data::Inherited> defines these methods and functions:

    every_hash(), every_list(), flush_every_cache_by_key()

The superclass L<Class::Accessor::Complex> defines these methods and
functions:

    mk_abstract_accessors(), mk_array_accessors(), mk_boolean_accessors(),
    mk_class_array_accessors(), mk_class_hash_accessors(),
    mk_class_scalar_accessors(), mk_concat_accessors(),
    mk_forward_accessors(), mk_hash_accessors(), mk_integer_accessors(),
    mk_new(), mk_object_accessors(), mk_scalar_accessors(),
    mk_set_accessors(), mk_singleton()

The superclass L<Class::Accessor> defines these methods and functions:

    _carp(), _croak(), _mk_accessors(), accessor_name_for(),
    best_practice_accessor_name_for(), best_practice_mutator_name_for(),
    follow_best_practice(), get(), make_accessor(), make_ro_accessor(),
    make_wo_accessor(), mk_accessors(), mk_ro_accessors(),
    mk_wo_accessors(), mutator_name_for(), set()

The superclass L<Class::Accessor::Installer> defines these methods and
functions:

    install_accessor()

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see L<http://search.cpan.org/dist/Error-Hierarchy/>.

=head1 AUTHORS

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2004-2009 by the authors.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut

