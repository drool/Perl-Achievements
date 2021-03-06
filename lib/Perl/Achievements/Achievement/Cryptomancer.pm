package Perl::Achievements::Achievement::Cryptomancer;
# ABSTRACT: uses Perl magic variables

use strict;
use warnings;

use Moose;
use MooseX::SemiAffordanceAccessor;

no warnings qw/ uninitialized /;

use List::MoreUtils qw/ uniq any/;

with 'Perl::Achievements::Achievement';

has variables => (
    traits => [ qw/ Perl::Achievements::Role::ConfigItem / ],
    is => 'rw',
    default => sub { [] },
);

sub scan {
    my $self = shift;

    my $magic = $self->ppi->find( 'PPI::Token::Magic' ) or return;

    my @vars = @{ $self->variables };

    my @new_vars = uniq @vars, map { $_->content } @$magic;

    return if $self->level == @new_vars;

    $self->set_level( scalar @new_vars );

    $self->set_variables( \@new_vars );

    my %vars = map { $_ => 1 } @vars;
    @new_vars = sort grep { !$vars{$_} } @new_vars;

    $self->unlock( "new magic variables used: ". join ', ', @new_vars );
}

1;



