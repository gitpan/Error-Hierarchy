package Error::Hierarchy::Container;

# $Id: Container.pm 11486 2006-05-22 21:01:59Z gr $

# implements a container object.

use strict;
use warnings;
use Data::Miscellany 'set_push';


our $VERSION = '0.03';


# the exception container can be thrown as an exception as well, so inherit
# from Error::Hierarchy::Base first (so we get its new(), not the one from
# Data::Container)

use base qw/
    Data::Container
    Error::Hierarchy::Base
/;


sub record {
    my ($self, $exception_class, %args) = @_;

    # make record() invisible to caller when reporting exception location
    local $Error::Depth = $Error::Depth + 1;

    $self->items_set_push($exception_class->record(%args));
}


# Given a list of uuid's, deletes all exceptions from the container whose uuid
# is one of those given.

sub delete_by_uuid {
    my ($self, @uuid) = @_;
    my %uuid;
    @uuid{@uuid} = ();
    $self->items(grep { !exists $uuid{$_} } $self->items);
}


1;


__END__

=head1 NAME

Error::Hierarchy::Container - container for hierarchical exceptions

=head1 SYNOPSIS

  my $container = Error::Hierarchy::Container->new;
  $container->items_set_push($my_exception);
  $container->record('Some::Exception', %exception_args);
  $container->delete_by_uuid($uuid1, $uuid2);

=head1 DESCRIPTION

This class implements a container for hierarchical exception objects. It is
effectively a L<Data::Container> but also has the following methods.

=head1 METHODS

=over 4

=item record

Takes an exception class name (a string) and a hash of arguments. First the
exception is constructed with the given arguments, then it is added - using
C<items_set_push()> - to the container. It's really a shortcut that saves you
from having to record the exception and then adding it to the container
yourself.

=item delete_by_uuid

Takes a list of uuid values and deletes all those exceptions from the
container whose uuid appears in the given list.

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

