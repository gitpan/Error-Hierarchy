package Error::Hierarchy;

use warnings;
use strict;
use Carp;
use Data::UUID;
use Sys::Hostname;

use base 'Error::Hierarchy::Base';


our $VERSION = '0.04';


__PACKAGE__
    ->mk_boolean_accessors(qw(is_optional acknowledged))
    ->mk_accessors(qw(
        message exception_hostname package filename line depth stacktrace uuid
    ));


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

    $self->depth(0) unless defined $self->depth;
    $self->is_optional(0) unless defined $self->is_optional;

    # init() code is based on Error::new(); we use a slightly different
    # scheme to set caller information. Error::throw() (our superclass) sets
    # $Error::Depth. We use $Error::Depth + 1 because we init() got called by
    # new(), so the call stack is one deeper than $Error::Depth indicates.

    my ($package, $filename, $line) =
        caller($Error::Depth + $self->error_depth + $self->depth);
    $self->exception_hostname(hostname());
    $self->package($package) unless defined $self->package;
    $self->filename($filename) unless defined $self->filename;
    $self->line($line) unless defined $self->line;
    $self->stacktrace(Carp::longmess);
    $self->uuid(Data::UUID->new->create_str);
}


sub get_properties { $_[0]->every_list('PROPERTIES') }


sub properties_as_hash {
    my $self = shift;
    my %p = map { $_ => (defined $self->$_ ? $self->$_ : 'unknown') }
        # hm... ask gr...
        grep { $_ ne 'package' &&
               $_ ne 'filename' &&
               $_ ne 'line'
        } $self->get_properties;
    wantarray ? %p : \%p;
}


sub stringify {
    my $self = shift;
    sprintf $self->message =>
        map { $self->$_ || 'unknown' } $self->get_properties;
}


# Transmute an existing exception; leave stacktrace, filename, line etc. as it
# is and just rebless it, adding the given additional arguments. Used when
# catching a generic exception and turning it into a more specific one.

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

Error::Hierarchy - support for hierarchical exception classes

=head1 SYNOPSIS

    package Error::Hierarchy::ReadOnlyAttribute;

    use warnings;
    use strict;

    use base 'Error::Hierarchy';

    __PACKAGE__->mk_accessors(qw(attribute));

    use constant default_message => '[%s] is a read only attribute';

    use constant PROPERTIES => ( 'attribute' );

Meanwhile...

    package main;

    use Error::Hierarchy::Mixin;

    if (...) {
        Error::Hierarchy::ReadOnlyAttribute->
            throw(attribute => 'foo');
    }

=head1 DESCRIPTION

This class provides support for hierarchical exception classes. It builds upon
L<Error> and is thus compatible with its C<try>/C<catch> mechanism. However,
it records a lot more information such as the package, filename and line where
the exception occurred, a complete stack trace, the hostname and a uuid.

It provides a stringification that is extensible with any properties your own
exceptions might define.

FIXME: This documentation is still only a stub - I still need to describe all
the goodies this class provides. For now, see the synopsis and the other
classes in this distribution.

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

