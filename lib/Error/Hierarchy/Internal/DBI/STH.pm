package Error::Hierarchy::Internal::DBI::STH;
use warnings;
use strict;
use Error::Hierarchy::Util 'load_class';
use base 'Error::Hierarchy::Internal::DBI::H';
our $VERSION = '0.07';

# DBI exceptions store extra values, but don't use them in the message string.
# They are marked as properties, however, so generic exception handling code
# can introspect them.
__PACKAGE__->mk_accessors(
    qw(
      num_of_fields num_of_params field_names type precision scale
      nullable cursor_name param_values statement rows_in_cache
      )
);
use constant PROPERTIES => (
    qw(num_of_fields num_of_params field_names type precision scale nullable
      cursor_name param_values statement rows_in_cache)
);
sub TRANSMUTED_EXCEPTION { () }

sub transmute_exception {
    my $self = shift;

    my $transmute = $self->every_hash('TRANSMUTED_EXCEPTION');
    my $found_class;
    if (exists $transmute->{ $self->err }) {
        my $spec = $transmute->{ $self->err };
        if (ref $spec eq 'HASH') {
            while (my ($errstr_regex, $exception_class) = each %$spec) {
                next unless $self->errstr =~ qr/$errstr_regex/;
                load_class $exception_class, 1;
                $found_class = $exception_class;

                # Don't just
                #
                #   return bless $self, $exception_class;
                #
                # because there seems to be some perl bug; when another object
                # of this package is created and this method is called again,
                # the subhash - the one we're iterating over with each() right
                # now - is empty. But when we dump the $transmute hash with
                # Data::Dumper, it's back. Maybe there's some problem with
                # reblessing things we're iterating over.
                #
                # Well, the manpage for each() does say: There is a single
                # iterator for each hash, shared by all "each", "keys", and
                # "values" function calls in the program; it can be reset by
                # reading all the elements from the hash, or by evaluating
                # "keys HASH" or "values HASH".
            }
        } else {

            # if it's just a scalar, then it doesn't depend on the errstr,
            # just the err number.
            load_class $spec, 1;
            $found_class = $spec;

            # Can't just
            #
            #   return bless $self, $spec;
            #
            # because of the reasons mentioned above
        }
    }

    # no match found_class; don't transmute
    return $self unless $found_class;
    bless $self, $found_class;
}
1;
__END__

=head1 NAME

Error::Hierarchy::Internal::DBI::STH - DBI-related exception

=head1 SYNOPSIS

# None.

=head1 DESCRIPTION

This class is part of the DBI-related exceptions. It is internal and you're
not supposed to use it.

=head1 PROPERTIES

This exception class inherits all properties of
L<Error::Hierarchy::Internal::DBI::H>.

It has the following additional properties.

=over 4

=item C<num_of_fields>

=item C<num_of_params>

=item C<field_names>

=item C<type>

=item C<precision>

=item C<scale>

=item C<nullable>

=item C<cursor_name>

=item C<param_values>

=item C<statement>

=item C<rows_in_cache>

=back

=head1 METHODS

=over 4

=item C<transmute_exception()>

Transmute the exception according to a two-level hash where the keys are DBI
exception's C<err> and C<errstr> and the value is an exception class name.

If no match is found, the exception is not changed. If a match is found, the
exception is blessed to the new package and returned.

=item C<TRANSMUTED_EXCEPTION()>

An inherited hash - see C<every_hash()> in L<Data::Inherited> - that defines
the mappings for C<transmute_exception()>.

=back

Error::Hierarchy::Internal::DBI::STH inherits from
L<Error::Hierarchy::Internal::DBI::H>.

The superclass L<Error::Hierarchy::Internal::DBI> defines these methods and
functions:

    emit_warning(), handler(), init()

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
