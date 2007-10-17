package Error::Hierarchy::Base;

use warnings;
use strict;


our $VERSION = '0.01';


use base qw(
    Error
    Data::Inherited
    Class::Accessor::Complex
);


Error::Hierarchy::Base->mk_new;  # so we don't get Error::new()


use overload
    '""'     => 'stringify',
    'cmp'    => sub { "$_[0]" cmp "$_[1]" },
    fallback => 1;


sub stringify {}


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

None.

=head1 DESCRIPTION

This class is internal, so you're not supposed to use it.

=head1 TAGS

If you talk about this module in blogs, on del.icio.us or anywhere else,
please use the C<errorhierarchy> tag.

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

