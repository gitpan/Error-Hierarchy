package Error::Hierarchy::Internal::DBI::H;
use warnings;
use strict;
use base 'Error::Hierarchy::Internal::DBI';
our $VERSION = '0.09';

# DBI exceptions store extra values, but don't use them in the message string.
# They are marked as properties, however, so generic exception handling code
# can introspect them.
__PACKAGE__->mk_accessors(
    qw(
      warn active kids active_kids compat_mode inactive_destroy
      trace_level fetch_hash_key_name chop_blanks long_read_len
      long_trunc_ok taint
      )
);
use constant PROPERTIES => (
    qw(warn active kids active_kids compat_mode inactive_destroy trace_level
      fetch_hash_key_name chop_blanks long_read_len long_trunc_ok
      taint)
);
1;
__END__

=head1 NAME

Error::Hierarchy::Internal::DBI::H - DBI-related exception

=head1 SYNOPSIS

# None.

=head1 DESCRIPTION

This class is part of the DBI-related exceptions. It is internal and you're
not supposed to use it.

=head1 PROPERTIES

This exception class inherits all properties of
L<Error::Hierarchy::Internal::DBI>.

It has the following additional properties.

=over 4

=item C<warn>

=item C<active>

=item C<kids>

=item C<active_kids>

=item C<compat_mode>

=item C<inactive_destroy>

=item C<trace_level>

=item C<fetch_hash_key_name>

=item C<chop_blanks>

=item C<long_read_len>

=item C<long_trunc_ok taint>

=back

Error::Hierarchy::Internal::DBI::H inherits from
L<Error::Hierarchy::Internal::DBI>.

The superclass L<Error::Hierarchy::Internal::DBI> defines these methods and
functions:

    emit_warning(), handler(), init(), transmute_exception()

The superclass L<Error::Hierarchy::Internal> defines these methods and
functions:

    is_optional(), stringify()

The superclass L<Error::Hierarchy> defines these methods and functions:

    acknowledged(), acknowledged_clear(), acknowledged_set(),
    clear_acknowledged(), clear_is_optional(), comparable(), error_depth(),
    get_properties(), is_optional_clear(), is_optional_set(),
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
