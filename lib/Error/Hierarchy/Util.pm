package Error::Hierarchy::Util;

# $Id: Util.pm 13296 2007-07-02 11:39:11Z gr $

use strict;
use warnings;
use Data::Miscellany 'is_defined';
use Error::Hierarchy::Mixin;  # to get UNIVERSAL::throw()


our $VERSION = '0.02';


use base 'Exporter';


our %EXPORT_TAGS = (
    ref  => [ qw{
        assert_arrayref assert_nonempty_arrayref
        assert_hashref  assert_nonempty_hashref
        } ],
    misc => [ qw{
        assert_class assert_defined assert_read_only assert_is_integer
        assert_getopt load_class
        } ],
);

our @EXPORT_OK = @{ $EXPORT_TAGS{all} = [ map { @$_ } values %EXPORT_TAGS ] };


sub assert_class ($$) {
    my ($obj, $class) = @_;
    return if ref $obj && $obj->isa($class);
    local $Error::Depth = $Error::Depth + 2;
    throw Error::Hierarchy::Internal::Class(
        class_expected => $class,
        class_got      => ref($obj),
    );
}


sub assert_read_only {
    return unless @_;
    local $Error::Depth = $Error::Depth + 2;
    my $sub = (caller(1))[3];
    throw Error::Hierarchy::Internal::ReadOnlyAttribute(
        attribute => $sub,
    );
}


# In assert_condition we use
#
#   local $Error::Depth = $Error::Depth + 3;
#
# because:
#
# +1 to make assert_condition invisible to caller
#
# +1 to make assert_defined and friends invisible to caller
#
# +1 to make the one who called assert_* invisible to caller, since we
# want to report the location where the method that checks its args using
# assert_* was called from.
#
# The exception class indicated by $exception_class is supposed to be a marker
# subclass of Error::Hierarchy::Internal::CustomMessage

sub assert_condition ($$$) {
    my ($condition, $exception_class, $custom_message) = @_;
    return if $condition;

    # get the name of the first sub an assert_* sub was called with the unmet
    # assertion

    my ($level, $sub);
    do {
        $sub = (caller(++$level))[3];
    } until $sub !~ /^.*::assert_/;

    # XXX: shouldn't we use $level here instead of 3?
    local $Error::Depth = $Error::Depth + 3;
    $exception_class->throw(custom_message => "[$sub] $custom_message");
}


sub assert_defined ($$) {
    my ($val, $custom_message) = @_;

    # If it's a value object, it might have been autogenerated (see
    # value_object accessor generator, in which case it might not have a value
    # yet, but $val would be defined (it's the empty value object).

    assert_condition(
        is_defined($val),
        'Error::Hierarchy::Internal::ValueUndefined',
        $custom_message
    );
}


sub assert_arrayref ($$) {
    my ($val, $custom_message) = @_;
    assert_condition((defined($val) && ref($val) eq 'ARRAY'),
        'Error::Hierarchy::Internal::NoArrayRef', $custom_message);
}


sub assert_nonempty_arrayref ($$) {
    my ($val, $custom_message) = @_;
    assert_condition((defined($val) && ref($val) eq 'ARRAY' && scalar @$val),
        'Error::Hierarchy::Internal::EmptyArrayRef', $custom_message);
}


sub assert_hashref ($$) {
    my ($val, $custom_message) = @_;
    assert_condition((defined($val) && ref($val) eq 'HASH'),
        'Error::Hierarchy::Internal::NoHashRef', $custom_message);
}


sub assert_nonempty_hashref ($$) {
    my ($val, $custom_message) = @_;
    assert_condition(
        (defined($val) && ref($val) eq 'HASH' && scalar keys %$val),
        'Error::Hierarchy::Internal::EmptyHashRef', $custom_message);
}


sub assert_is_integer ($) {
    my $val = shift;
    assert_condition(
        ($val =~ /^[1-9]$/),
        'Error::Hierarchy::Internal::CustomMessage',
        'expected an integer value from 1 to 9');
}


# Called by service methods to verify options passed to it. If the value given
# is true, we just return. If it is false, we throw a special "help
# exception". When the shell service interface calls a service method, it
# catches this help exception and prints manpage-like help information for
# that method.

sub assert_getopt ($$) {
    my ($val, $custom_message) = @_;
    return if $val;
    Data::Conveyor::Exception::ServiceMethodHelp->throw(
        custom_message => $custom_message
    );
}


# support for "virtual" classes that do not exist as files.
# this is of no use for payload reinstantiation in a new
# process, as Storable calls require() before touching any
# accessor. it does allow a few things, though:
# load_class XYZ, 1 for example, or calling static methods
# directly, such as XYZ->DEFAULTS.

sub loader_callback {
    shift if $_[0] eq __PACKAGE__;
    our $loader_callback;
    if (my $callback = shift) {
        throw Error::Hierarchy::Internal::CustomMessage(
            custom_message => "argument must be a coderef")
            unless ref $callback eq 'CODE';
        $loader_callback = $callback;
    }
    $loader_callback;
}


sub load_class ($$) {
    my ($class, $verbose) = @_;
    assert_defined $class, 'called without class argument.';

    # An attempt at optimization: This sub is called very often. By relying on
    # every class defining a $VERSION, we can shortcut costly processing.

    {
        no strict 'refs';
        return if ${"$class\::VERSION"};
    }

    # report errors from perspective of caller
    local $Error::Depth = $Error::Depth + 1;

    eval "require $class";

    if (defined($@) && $@ ne '') {
        # allow for dynamic class generation
        if (my $code = __PACKAGE__->loader_callback) {
            return $class if $code->($class);
        }
        # this error is so severe we want to print it during test mode
        print $@ if $verbose;
        throw Error::Hierarchy::Internal::CustomMessage(
            custom_message => sprintf("Couldn't load package [%s]: %s",
                $class, $@),
        );
    }
    $class;
}


1;


__END__

=head1 NAME

Error::Hierarchy::Util - assertions and other tools

=head1 SYNOPSIS

  use Error::Hierarchy::Util qw/assert_defined assert_is_integer/;

  sub foo {
    my ($self, $bar, $baz) = @_;
    assert_defined $bar, 'called without defined bar';
    assert_is_integer $baz;
    ...
  }

=head1 DESCRIPTION

This module provides some functions that can make assertions about a given
value and, if necessary, throw an appropriate exception. It also provides
other tools.

None of the functions are exported by default, but they can be imported using
the standard L<Exporter> semantics.

=head1 FUNCTIONS

=over 4

=item assert_arrayref

    assert_arrayref $r, '$r is not an array reference';

Takes as arguments a value and a custom message. If the value is not an array
reference, it throws a L<Error::Hierarchy::Internal::NoArrayRef> exception
with the given custom message.

=item assert_nonempty_arrayref

    assert_nonempty_arrayref $r, '$r does not have any elements';

Takes as arguments a value and a custom message. If the value is not a
reference to an array with at least one element, it throws a
L<Error::Hierarchy::Internal::EmptyArrayRef> exception with the given custom
message.

=item assert_hashref

    assert_hashref $r, '$r is not a hash reference';

Takes as arguments a value and a custom message. If the value is not a hash
reference, it throws a L<Error::Hierarchy::Internal::NoHashRef> exception with
the given custom message.

=item assert_nonempty_hashref

    assert_nonempty_hashref $r, '$r does not have any key/value pairs';

Takes as arguments a value and a custom message. If the value is not a
reference to a hash with at least one key/value pair, it throws a
L<Error::Hierarchy::Internal::EmptyHashRef> exception with the given custom
message.

=item assert_class

    assert_class $obj, 'Some::Class';

Takes as arguments an object and a class name. If the object is not of the
given class type, it throws a L<Error::Hierarchy::Internal::Class> exception.

=item assert_defined

    sub foo {
        my ($self, $bar) = @_;
        assert_defined $bar, 'called without bar';
        ...
    }

Takes as arguments a value and a custom message. If the value is not defined,
it throws a L<Error::Hierarchy::Internal::ValueUndefined> exception with
the given custom message.

=item assert_read_only

    sub get_foo {
        my $self = shift;
        assert_read_only(@_);
        $self->{foo};
    }

Checks whether the calling subroutine was called with any arguments. If so, it
throws a L<Error::Hierarchy::Internal::ReadOnlyAttribute> exception.

=item assert_is_integer

    sub set_log_level {
        my ($self, $log_level) = @_;
        assert_is_integer($log_level);
        ...
    }

Takes a value and unless it is an integer between 1 and 9, it throws a
L<Error::Hierarchy::Internal::CustomMessage> exception with a predefined
message.

FIXME: The limitation of the value makes this probably a function that's not
very useful. I should make this more generic.

=item load_class

    load_class 'Some::Class', 1;

Takes as arguments a package name and a boolean verbosity flag. Tries to load
the package and if it can't be laoded, it throws a
L<Error::Hierarchy::Internal::CustomMessage> exception with the error message
obtained when trying to load the package.

To save time, this function checks whether the package defines a C<$VERSION>
and if so, it assumes that the package has already been loaded and returns
right away.

If the verbose flag is set, the error code - C<$@> - is printed immediately if
a problem occurs. You might want to set this flag in when testing your code to
get a quick feedback on loading problems, but you should have a graceful
method to deal with the problem anyway.

This function is called C<load_class()> and not C<load_package()> for
historical reasons.

=back

=head1 TAGS

If you talk about this module in blogs, on del.icio.us or anywhere else, please
use the C<errorhierarchy> tag.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-error-hierarchy@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN site
near you. Or see <http://www.perl.com/CPAN/authors/id/M/MA/MARCEL/>.

=head1 AUTHOR

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Marcel GrE<uuml>nauer

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

