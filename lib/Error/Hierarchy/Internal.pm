package Error::Hierarchy::Internal;

# $Id: Internal.pm 9003 2005-05-12 13:33:49Z gr $

# This class is important so applications can define their own internal
# exceptions (opposed to business exceptions) and just catch objects of this
# class where appropriate.

use warnings;
use strict;


our $VERSION = '0.02';


use base 'Error::Hierarchy';

use constant PROPERTIES => ( qw/package filename line/ );

sub is_optional { 0 }

sub stringify {
    my $self = shift;
    my $message = "Exception: package [%s], filename [%s], line [%s]: "
        . $self->message;
    sprintf $message =>
        map { defined($self->$_) ? $self->$_ : 'unknown' }
            $self->get_properties;
}


1;


__END__

=head1 NAME

Error::Hierarchy::Internal - base class for internal exceptions

=head1 SYNOPSIS

None.

=head1 DESCRIPTION

This class implements the base class for internal exceptions. All internal
exceptions should subclass it. However, you probably shouldn't throw an
exception of this class; rather use
L<Error::Hierarchy::Internal::CustomMessage>.

=head1 PROPERTIES

This exception class inherits all properties of L<Error::Hierarchy>.

It has no additional properties.

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

