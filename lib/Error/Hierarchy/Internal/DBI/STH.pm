package Error::Hierarchy::Internal::DBI::STH;

# $Id: STH.pm 13298 2007-07-02 12:45:23Z gr $

use warnings;
use strict;
use Error::Hierarchy::Util 'load_class';

use base 'Error::Hierarchy::Internal::DBI::H';


our $VERSION = '0.03';


# DBI exceptions store extra values, but don't use them in the message string.
# They are marked as properties, however, so generic exception handling code
# can introspect them.

__PACKAGE__->mk_accessors(qw(
    num_of_fields num_of_params field_names type precision scale
    nullable cursor_name param_values statement rows_in_cache
));

use constant PROPERTIES => (
    qw(num_of_fields num_of_params field_names type precision scale nullable
       cursor_name param_values statement rows_in_cache)
);


sub TRANSMUTED_EXCEPTION { () }


sub transmute_exception {
    my $self = shift;

    # transmute according to a two-level hash where the keys are err and
    # errstr and the value is an exception class name

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

None.

=head1 DESCRIPTION

This class is part of the DBI-related exceptions. It is internal and you're
not supposed to use it.

=head1 PROPERTIES

This exception class inherits all properties of
L<Error::Hierarchy::Internal::DBI::H>.

It has the following additional properties.

=over 4

=item num_of_fields

=item num_of_params

=item field_names

=item type

=item precision

=item scale

=item nullable

=item cursor_name

=item param_values

=item statement

=item rows_in_cache

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

