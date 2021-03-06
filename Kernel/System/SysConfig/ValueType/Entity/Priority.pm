# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SysConfig::ValueType::Entity::Priority;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::SysConfig::ValueType::Entity);

our @ObjectDependencies = (
    'Kernel::System::Priority',
    'Kernel::System::Web::Request',
);

=head1 NAME

Kernel::System::SysConfig::ValueType::Entity::Priority - System configuration priority entity type backend.

=head1 PUBLIC INTERFACE

=head2 new()

Create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $EntityTypeObject = $Kernel::OM->Get('Kernel::System::SysConfig::ValueType::Entity::Priority');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub EntityValueList {
    my ( $Self, %Param ) = @_;

    my %Priorities = $Kernel::OM->Get('Kernel::System::Priority')->PriorityList(
        Valid => 1,
    );

    my @Result;

    for my $ID ( sort keys %Priorities ) {
        push @Result, $Priorities{$ID};
    }

    return @Result;
}

sub EntityLookupFromWebRequest {
    my ( $Self, %Param ) = @_;

    my $PriorityID = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'PriorityID' ) // '';

    return if !$PriorityID;

    return $Kernel::OM->Get('Kernel::System::Priority')->PriorityLookup( PriorityID => $PriorityID );
}

1;
