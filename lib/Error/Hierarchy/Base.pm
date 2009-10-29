package Error::Hierarchy::Base;
use warnings;
use strict;
our $VERSION = '0.08';
use base qw(
  Error
  Data::Inherited
  Class::Accessor::Complex
);
__PACKAGE__->mk_new;    # so we don't get Error::new()
use overload
  '""'     => 'stringify',
  'cmp'    => sub { "$_[0]" cmp "$_[1]" },
  fallback => 1;
sub stringify { }

sub dump_raw {
    my $self = shift;
    require Data::Dumper;
    local $Data::Dumper::Indent = 1;
    Data::Dumper::Dumper($self);
}

sub dump_as_yaml {
    my $self = shift;
    require YAML;
    YAML::Dump($self);
}
1;
__END__

=head1 NAME

Error::Hierarchy::Base - base class for hierarchical exception classes

=head1 SYNOPSIS

# None.

=head1 DESCRIPTION

This class is internal, so you're not supposed to use it.

=head1 METHODS

=over 4

=item C<new()>

    my $obj = Error::Hierarchy::Base->new;
    my $obj = Error::Hierarchy::Base->new(%args);

Creates and returns a new object. The constructor will accept as arguments a
list of pairs, from component name to initial value. For each pair, the named
component is initialized by calling the method of the same name with the given
value. If called with a single hash reference, it is dereferenced and its
key/value pairs are set as described before.

=item C<stringify()>

This class overloads C<""> to call this method. It defines how an exception
should look like if it is used in a string. In this class this method returns
an undefined value, so subclasses should override it. For example,
L<Error::Hierarchy> does so.

=item C<dump_raw()>

Dumps the exception using C<Data::Dumper>.

=item C<dump_as_yaml()>

Dumps the exception using C<YAML>.

=back

Error::Hierarchy::Base inherits from L<Error>, L<Data::Inherited>, and
L<Class::Accessor::Complex>.

The superclass L<Error> defines these methods and functions:

    _throw_Error_Simple(), associate(), catch(), file(), flush(), import(),
    line(), object(), prior(), record(), stacktrace(), text(), throw(),
    value(), with()

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
