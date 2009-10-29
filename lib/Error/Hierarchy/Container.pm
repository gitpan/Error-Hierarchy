package Error::Hierarchy::Container;

# implements a container object.
use strict;
use warnings;
use Data::Miscellany 'set_push';
our $VERSION = '0.08';

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

    my $my_exception = create_some_exception();
    my %exception_args = (foo => 'bar');
    my $uuid1 = gen_some_uuid();
    my $uuid2 = gen_some_uuid();

    my $container = Error::Hierarchy::Container->new;
    $container->items_set_push($my_exception);
    $container->record('Some::Exception', %exception_args);
    $container->delete_by_uuid($uuid1, $uuid2);

=head1 DESCRIPTION

This class implements a container for hierarchical exception objects. It is
effectively a L<Data::Container> but also has the following methods.

=head1 METHODS

=over 4

=item C<record>

Takes an exception class name (a string) and a hash of arguments. First the
exception is constructed with the given arguments, then it is added - using
C<items_set_push()> - to the container. It's really a shortcut that saves you
from having to record the exception and then adding it to the container
yourself.

=item C<delete_by_uuid>

Takes a list of uuid values and deletes all those exceptions from the
container whose uuid appears in the given list.

=back

Error::Hierarchy::Container inherits from L<Data::Container> and
L<Error::Hierarchy::Base>.

The superclass L<Data::Container> defines these methods and functions:

    new(), clear_items(), count_items(), index_items(), item_grep(),
    items(), items_clear(), items_count(), items_index(), items_pop(),
    items_push(), items_set(), items_set_push(), items_shift(),
    items_splice(), items_unshift(), pop_items(), prepare_comparable(),
    push_items(), set_items(), shift_items(), splice_items(), stringify(),
    unshift_items()

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

The superclass L<Error::Hierarchy::Base> defines these methods and
functions:

    dump_as_yaml(), dump_raw()

The superclass L<Error> defines these methods and functions:

    _throw_Error_Simple(), associate(), catch(), file(), flush(), import(),
    line(), object(), prior(), stacktrace(), text(), throw(), value(),
    with()

The superclass L<Data::Inherited> defines these methods and functions:

    every_hash(), every_list(), flush_every_cache_by_key()

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
