package Error::Hierarchy::Internal;

# This class is important so applications can define their own internal
# exceptions (opposed to business exceptions) and just catch objects of this
# class where appropriate.
use warnings;
use strict;
our $VERSION = '0.09';
use base 'Error::Hierarchy';
use constant PROPERTIES => (qw/package filename line/);
sub is_optional { 0 }

sub stringify {
    my $self = shift;
    my $message =
      "Exception: package [%s], filename [%s], line [%s]: " . $self->message;
    sprintf $message => map { defined($self->$_) ? $self->$_ : 'unknown' }
      $self->get_properties;
}
1;
__END__

=head1 NAME

Error::Hierarchy::Internal - base class for internal exceptions

=head1 SYNOPSIS

# None.

=head1 DESCRIPTION

This class implements the base class for internal exceptions. All internal
exceptions should subclass it. However, you probably shouldn't throw an
exception of this class; rather use
L<Error::Hierarchy::Internal::CustomMessage>.

=head1 PROPERTIES

This exception class inherits all properties of L<Error::Hierarchy>.

It has no additional properties.

=head1 METHODS

=over 4

=item C<is_optional()>

Returns 0, so this exception is not optional.

=item C<stringify()>

Defines how an exception should look like if it is used in a string: The same
as L<Error::Hierarchy>, but it prepends the package, filename and line the
exception occurred in to the given message.

=back

Error::Hierarchy::Internal inherits from L<Error::Hierarchy>.

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
