package Error::Hierarchy::Internal::Class;
use warnings;
use strict;
our $VERSION = '0.09';
use base 'Error::Hierarchy::Internal';
__PACKAGE__->mk_accessors(qw(class_expected class_got));
use constant default_message => 'expected a [%s] object, got [%s]';
use constant PROPERTIES      => (qw/class_expected class_got/);
1;
__END__

=head1 NAME

Error::Hierarchy::Internal::Class - when you got an object of a wrong class

=head1 SYNOPSIS

  my $got_object = get_some_object();
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

=item C<class_expected>

The class name that you expected.

=item C<class_got>

The class name of the object you actually got.

=back

=head1 METHODS

=over 4



=back

Error::Hierarchy::Internal::Class inherits from
L<Error::Hierarchy::Internal>.

The superclass L<Error::Hierarchy::Internal> defines these methods and
functions:

    is_optional(), stringify()

The superclass L<Error::Hierarchy> defines these methods and functions:

    acknowledged(), acknowledged_clear(), acknowledged_set(),
    clear_acknowledged(), clear_is_optional(), comparable(), error_depth(),
    get_properties(), init(), is_optional_clear(), is_optional_set(),
    properties_as_hash(), set_acknowledged(), set_is_optional(),
    transmute()

The superclass L<Error::Hierarchy::Base> defines these methods and
functions:

    new(), dump_as_yaml(), dump_raw()

The superclass L<Error> defines these methods and functions:

    _throw_Error_Simple(), associate(), catch(), file(), flush(), import(),
    object(), prior(), record(), text(), throw(), value(), with()

The superclass L<Data::Inherited> defines these methods and functions:

    every_hash(), every_list(), flush_every_cache_by_key()

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
