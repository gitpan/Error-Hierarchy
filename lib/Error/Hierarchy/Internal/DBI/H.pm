package Error::Hierarchy::Internal::DBI::H;

# $Id: H.pm 10101 2005-08-09 16:13:58Z gr $

use warnings;
use strict;
use base 'Error::Hierarchy::Internal::DBI';


our $VERSION = '0.04';


# DBI exceptions store extra values, but don't use them in the message string.
# They are marked as properties, however, so generic exception handling code
# can introspect them.

__PACKAGE__->mk_accessors(qw(
    warn active kids active_kids compat_mode inactive_destroy
    trace_level fetch_hash_key_name chop_blanks long_read_len
    long_trunc_ok taint
));

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

None.

=head1 DESCRIPTION

This class is part of the DBI-related exceptions. It is internal and you're
not supposed to use it.

=head1 PROPERTIES

This exception class inherits all properties of
L<Error::Hierarchy::Internal::DBI>.

It has the following additional properties.

=over 4

=item warn

=item active

=item kids

=item active_kids

=item compat_mode

=item inactive_destroy

=item trace_level

=item fetch_hash_key_name

=item chop_blanks

=item long_read_len

=item long_trunc_ok taint

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

