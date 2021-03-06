# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdate::InitializeDefaultCronjobs;    ## no critic

use strict;
use warnings;

use File::Copy ();

use parent qw(scripts::DBUpdate::Base);

our @ObjectDependencies = (
    'Kernel::Config',
);

=head1 NAME

scripts::DBUpdate::InitializeDefaultCronjobs - Creates default cron jobs if they don't exist yet.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    for my $DistFile ( glob "$Home/var/cron/*.dist" ) {
        my $TargetFile = $DistFile =~ s{.dist$}{}r;
        if ( !-e $TargetFile ) {
            print "    Copying $DistFile to $TargetFile...\n";
            my $Success = File::Copy::copy( $DistFile, $TargetFile );
            if ( !$Success ) {
                print "\n    Error: Could not copy $DistFile to $TargetFile: $!\n";
                return;
            }
            print "    done.\n";
        }
    }

    return 1;
}

1;
