use 5.008;
use strict;
use warnings;

package Error::Hierarchy::Internal::EmptyHashRef;
BEGIN {
  $Error::Hierarchy::Internal::EmptyHashRef::VERSION = '1.101690';
}
# ABSTRACT: When you expected a non-empty hash reference
use parent 'Error::Hierarchy::Internal::CustomMessage';
1;


__END__
=pod

=head1 NAME

Error::Hierarchy::Internal::EmptyHashRef - When you expected a non-empty hash reference

=head1 VERSION

version 1.101690

=head1 DESCRIPTION

This class implements an exception that is meant to be thrown when you
expected a non-empty hash reference but got an empty one.

=head1 PROPERTIES

This exception class inherits all properties of
L<Error::Hierarchy::Internal::CustomMessage>.

It has no additional properties.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org>.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit L<http://www.perl.com/CPAN/> to find a CPAN
site near you, or see
L<http://search.cpan.org/dist/Error-Hierarchy/>.

The development version lives at
L<http://github.com/hanekomu/Error-Hierarchy/>.
Instead of sending patches, please fork this project using the standard git
and github infrastructure.

=head1 AUTHOR

  Marcel Gruenauer <marcel@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2004 by Marcel Gruenauer.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

