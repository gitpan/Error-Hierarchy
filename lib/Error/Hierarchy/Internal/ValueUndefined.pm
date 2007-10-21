package Error::Hierarchy::Internal::ValueUndefined;

# $Id: ValueUndefined.pm 8408 2005-02-16 15:46:52Z gr $

use warnings;
use strict;


our $VERSION = '0.04';


use base 'Error::Hierarchy::Internal::CustomMessage';

1;


__END__

=head1 NAME

Error::Hierarchy::Internal::ValueUndefined - when you expected a defined value

=head1 SYNOPSIS

  Error::Hierarchy::Internal::ValueUndefined->throw;

=head1 DESCRIPTION

This class implements an exception that is meant to be thrown when you
expected a defined value but got an undefined value.

=head1 PROPERTIES

This exception class inherits all properties of
L<Error::Hierarchy::Internal::CustomMessage>.

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

