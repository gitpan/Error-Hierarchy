package Error::Hierarchy::Mixin;
use strict;
use warnings;
use Error;    # to get $Error::Depth
our $VERSION = '0.08';

BEGIN {
    *CORE::GLOBAL::die = sub (@) {

        # Error.pm die()s as well, but we don't want an endless recursion.
        CORE::die(@_) if (caller)[0] eq 'Error' || ref $_[0];
        local $Error::Depth = $Error::Depth + 1;    # skip this level
        throw Error::Hierarchy::Internal::CustomMessage(
            custom_message => join(' ', @_),);
    };
}

# Any class that wants to throw an exception can simply use or inherit from
# this module and call 'throw Error::Whatever' without having to 'require' it
# first. By putting the throw() method in UNIVERSAL:: we catch method calls on
# exception classes that haven't been loaded yet. We load the class, then
# throw the exception.
sub UNIVERSAL::throw {

    # use Data::Dumper; print Dumper \@_; exit if ++(our $cnt) > 5;
    my ($exception_class, %args) = @_;

    # need to modify $Error::Depth (see Error.pm) to make certain parts
    # of the call stack invisible to caller()
    # +1 to make UNIVERSAL::throw() invisible
    # in case it wasn't loaded; to make sure $Error::Depth isn't undef
    require Error;
    local $Error::Depth = $Error::Depth + 1;
    eval "require $exception_class";
    CORE::die($@) if $@;
    $exception_class->throw(%args);
}

# Similar reasoning for record().
sub UNIVERSAL::record {
    my ($exception_class, %args) = @_;

    # need to modify $Error::Depth (see Error.pm) to make certain parts
    # of the call stack invisible to caller()
    # +1 to make UNIVERSAL::record() invisible
    # in case it wasn't loaded; to make sure $Error::Depth isn't undef
    require Error;
    local $Error::Depth = $Error::Depth + 1;
    eval "require $exception_class";
    CORE::die $@ if $@;
    $exception_class->record(%args);
}
1;
__END__

=head1 NAME

Error::Hierarchy::Mixin - provides often-used exception-related methods

=head1 SYNOPSIS

  package MyClass;
  use Error::Hierarchy::Mixin;

  Some::Exception->throw(foo => 'bar');

=head1 DESCRIPTION

This mixin provides several methods that you will often use when dealing with
exceptions.

It also overrides C<CORE::GLOBAL::die()> so C<die()> will produce an
L<Error::Hierarchy::Internal::CustomMessage>. If you have to use the original
C<die()>, use C<CORE::die()> instead.

=head1 METHODS

=over 4

=item C<throw>

Takes an exception class name (a string) and a hash of arguments. Loads the
exception class, constructs an exception object, passes it the arguments and
throws it by calling the exception object's C<throw()> method. It populates
the UNIVERSAL namespace, so all packages get this ability.

=item C<record>

Like C<throw()>, but records the exception using the exception object's
C<record()> method.

=back

Error::Hierarchy::Mixin inherits from .

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
