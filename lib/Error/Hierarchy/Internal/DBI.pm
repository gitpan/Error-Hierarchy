package Error::Hierarchy::Internal::DBI;
use warnings;
use strict;
use base 'Error::Hierarchy::Internal::CustomMessage';
our $VERSION = '0.09';

# DBI exceptions store extra values, but don't use them in the message string.
# They are marked as properties, however, so generic exception handling code
# can introspect them.
__PACKAGE__->mk_accessors(
    qw(
      error err errstr state retval
      )
);
use constant PROPERTIES => (qw(error err errstr state retval));

sub init {
    my ($self, %args) = @_;

    # because we call SUPER::init(), which uses caller() to set
    # package, filename and line of the exception:
    local $Error::Depth = $Error::Depth + 1;
    $self->SUPER::init(%args);
    $self->custom_message($args{error} || $args{errstr});
    $self = $self->transmute_exception;

    # be sure to call this after transmuting as the new class might not want
    # to emit a warning by overriding that method.
    $self->emit_warning;
}

sub transmute_exception { $_[0] }

# Warn the exception so we see it while testing (otherwise it might be
# swallowed by some catch block). In a separate method so subclasses can
# override it.
our $SkipWarning = 0;

sub emit_warning {
    return if $SkipWarning;
    my $self = shift;
    warn "$self";
}

sub handler {
    my $class = shift;
    my %args  = @_;
    %args = (
        sth_exception_class => 'Error::Hierarchy::Internal::DBI::STH',
        %args,
    );
    my $sth_exception_class = $args{sth_exception_class};
    sub {
        my ($err, $dbh, $retval) = @_;
        if (ref $dbh) {
            my @context = caller;

            # Assemble arguments for a handle exception.
            my @params = (
                error               => $err,
                errstr              => $dbh->errstr,
                err                 => $dbh->err,
                state               => $dbh->state,
                retval              => $retval,
                warn                => $dbh->{Warn},
                active              => $dbh->{Active},
                kids                => $dbh->{Kids},
                active_kids         => $dbh->{ActiveKids},
                compat_mode         => $dbh->{CompatMode},
                inactive_destroy    => $dbh->{InactiveDestroy},
                trace_level         => $dbh->{TraceLevel},
                fetch_hash_key_name => $dbh->{FetchHashKeyName},
                chop_blanks         => $dbh->{ChopBlanks},
                long_read_len       => $dbh->{LongReadLen},
                long_trunc_ok       => $dbh->{LongTruncOk},
                taint               => $dbh->{Taint},
                package             => $context[0],
                filename            => $context[1],
                line                => $context[2],
            );
            if (UNIVERSAL::isa($dbh, 'DBI::dr')) {

                # Just throw a driver exception. It has no extra attributes.
                throw Error::Hierarchy::Internal::DBI::DRH(@params);
            } elsif (UNIVERSAL::isa($dbh, 'DBI::db')) {

                # Throw a database handle exception.
                throw Error::Hierarchy::Internal::DBI::DBH(
                    @params,
                    auto_commit    => $dbh->{AutoCommit},
                    db_name        => $dbh->{Name},
                    statement      => $dbh->{Statement},
                    row_cache_size => $dbh->{RowCacheSize}
                );
            } elsif (UNIVERSAL::isa($dbh, 'DBI::st')) {

                # Throw a statement handle exception.
                throw $sth_exception_class(
                    @params,
                    num_of_fields => $dbh->{NUM_OF_FIELDS},
                    num_of_params => $dbh->{NUM_OF_PARAMS},
                    field_names   => $dbh->{NAME},
                    type          => $dbh->{TYPE},
                    precision     => $dbh->{PRECISION},
                    scale         => $dbh->{SCALE},
                    nullable      => $dbh->{NULLABLE},
                    cursor_name   => $dbh->{CursorName},
                    param_values  => $dbh->{ParamValues},
                    statement     => $dbh->{Statement},
                    rows_in_cache => $dbh->{RowsInCache}
                );
            } else {

                # Unknown exception. This shouldn't happen.
                throw Error::Hierarchy::Internal::DBI::Unknown(@params);
            }
        } else {

            # Set up for a base class exception.
            my $exc = 'Error::Hierarchy::Internal::DBI';

            # Make it an unknown exception if $dbh isn't a DBI class
            # name. Probably shouldn't happen.
            #
            unless ($dbh and UNIVERSAL::isa($dbh, 'DBI')) {
                $exc .= '::Unknown';
                eval "require $exc";
            }
            no warnings 'once';
            if ($DBI::lasth) {

                # There was a handle. Get the errors. This may be superfluous,
                # since the handle ought to be in $dbh.
                throw $exc(
                    error  => $err,
                    errstr => $DBI::errstr,
                    err    => $DBI::err,
                    state  => $DBI::state,
                    retval => $retval
                );
            } else {

                # No handle, no errors.
                throw $exc(
                    error  => $err,
                    retval => $retval
                );
            }
        }
    };
}
1;
__END__



=head1 NAME

Error::Hierarchy::Internal::DBI - DBI-related exception

=head1 SYNOPSIS

    my $connect_string = '...';
    my $dbuser         = '...';
    my $dbpass         = '...';

    my $dbh = DBI->connect($connect_string, $dbuser, $dbpass,
        { HandleError => Error::Hierarchy::Internal::DBI->handler });

=head1 DESCRIPTION

This class is the main part of the DBI-related exceptions. If you set it as
the error handler in a C<DBI->connect()> call, it will turn the simple string
errors thrown by DBI (and the database) into more meaningful exceptions.

=head1 PROPERTIES

This exception class inherits all properties of
L<Error::Hierarchy::Internal::CustomMessage>.

It has the following additional properties.

=over 4

=item C<error>

=item C<err>

=item C<errstr>

=item C<state>

=item C<retval>

=back

=head1 METHODS

=over 4

=item C<init()>

Initializes a newly constructed exception object. It transmutes the exception,
then calls C<emit_warning()> on the object.

=item C<transmute_exception()>

Give subclasses a chance to turn generic DBI exceptions into something more
specific for their database schema. This method is supposed to bless the
exception into the desired package or create a new one and must return it; it
is called in C<init()>.

=item C<emit_warning()>

Warns via C<warn()> unless the package global C<SkipWarning> is set.

=item C<handler()>

Turns the DBI error into the appropriate C<Error::Hierarchy::Internal::DBI::*>
exception object.

=back

Error::Hierarchy::Internal::DBI inherits from
L<Error::Hierarchy::Internal::CustomMessage>.

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

