package Error::Hierarchy::Internal::Class;

# $Id: Class.pm 10101 2005-08-09 16:13:58Z gr $

use warnings;
use strict;


our $VERSION = '0.04';


use base 'Error::Hierarchy::Internal';

__PACKAGE__->mk_accessors(qw(class_expected class_got));

use constant default_message => 'expected a [%s] object, got [%s]';

use constant PROPERTIES => ( qw/class_expected class_got/ );

1;


__END__

=head1 NAME

Error::Hierarchy::Internal::Class - when you got an object of a wrong class

=head1 SYNOPSIS

  Error::Hierarchy::Internal::Class->throw(
    class_expected => 'Some::Class',
    class_got      => ref($got_object),
  );

=head1 DESCRIPTION

This class implements an exception that is meant to be thrown when you
expected an object of a certain class somewhere but got an object of a
different class instead.

=head1 PROPERTIES

This exception class inherits all properties of L<Error::Hierarchy::Internal>.

It has the following additional properties.

=over 4

=item class_expected

The class name that you expected.

=item class_got

The class name of the object you actually got.

=back

=head1 TAGS

If you talk about this module in blogs, on del.icio.us or anywhere else,
please use the C<errorhierarchy> tag.

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

