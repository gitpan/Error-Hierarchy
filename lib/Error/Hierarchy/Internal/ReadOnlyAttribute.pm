use 5.008;
use strict;
use warnings;

package Error::Hierarchy::Internal::ReadOnlyAttribute;
BEGIN {
  $Error::Hierarchy::Internal::ReadOnlyAttribute::VERSION = '1.102500';
}
# ABSTRACT: When someone tried to set a read-only attribute
use parent 'Error::Hierarchy::Internal';
__PACKAGE__->mk_accessors(qw(attribute));
use constant default_message => '[%s] is a read only attribute';
use constant PROPERTIES      => ('attribute');
1;


__END__
=pod

=head1 NAME

Error::Hierarchy::Internal::ReadOnlyAttribute - When someone tried to set a read-only attribute

=head1 VERSION

version 1.102500

=head1 SYNOPSIS

  Error::Hierarchy::Internal::ReadOnlyAttribute->throw(attribute => 'foo');

=head1 DESCRIPTION

This class implements an exception that is meant to be thrown when someone
tried to change a value you consider to be read-only.

=head1 PROPERTIES

This exception class inherits all properties of L<Error::Hierarchy::Internal>.

Additionally it defines the C<attribute> property.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org>.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit L<http://www.perl.com/CPAN/> to find a CPAN
site near you, or see L<http://search.cpan.org/dist/Error-Hierarchy/>.

The development version lives at L<http://github.com/hanekomu/Error-Hierarchy>
and may be cloned from L<git://github.com/hanekomu/Error-Hierarchy>.
Instead of sending patches, please fork this project using the standard
git and github infrastructure.

=head1 AUTHOR

Marcel Gruenauer <marcel@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2004 by Marcel Gruenauer.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

