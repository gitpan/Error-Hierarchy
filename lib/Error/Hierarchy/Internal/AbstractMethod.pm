package Error::Hierarchy::Internal::AbstractMethod;

# $Id: AbstractMethod.pm 10101 2005-08-09 16:13:58Z gr $

use warnings;
use strict;


our $VERSION = '0.04';


use base qw(Error::Hierarchy::Internal Class::Accessor);
__PACKAGE__->mk_accessors(qw(method));


use constant default_message => 'called abstract method [%s]';


use constant PROPERTIES => ( 'method' );


sub init {
    my $self = shift;

    # because we call SUPER::init(), which uses caller() to set
    # package, filename and line of the exception, *plus* we don't want
    # to report the abstract method that threw this exception itself,
    # rather we want to report its caller, i.e. the one that called the
    # abstract method. So we use +2.

    local $Error::Depth = $Error::Depth + 2;
    $self->method((caller($Error::Depth))[3]) unless defined $self->method;
    $self->SUPER::init(@_);
}


1;


__END__

=head1 NAME

Error::Hierarchy::Internal::AbstractMethod - for unimplemented methods

=head1 SYNOPSIS

  # the following all do the same:

  sub not_there_yet {
      Error::Hierarchy::Internal::AbstractMethod->throw;
  }

  # or:

  sub not_there_yet {
      Error::Hierarchy::Internal::AbstractMethod->
          throw(method => 'not_there_yet');
  }

  # or:

  use base 'Class::Accessor::Complex';
  __PACKAGE__->mk_abstract_accessors(qw(not_there_yet));

=head1 DESCRIPTION

This class implements an exception that is meant to be thrown when an
unimplemented method is called.

=head1 PROPERTIES

This exception class inherits all properties of L<Error::Hierarchy::Internal>.

It has the following additional property.

=over 4

=item method

Name of the unimplemented method. If it is not given, then the name of the
method that has thrown this exception is taken from the call stack.

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

