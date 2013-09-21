#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw($Bin);
use YAML qw(LoadFile);
use File::Slurp qw(write_file);
use File::Path qw(make_path);

my $TIDY_BASE = '/tidy';

system("/usr/bin/curl -L http://cpanmin.us | perl - App::cpanminus");

my $tidy_data = LoadFile("$Bin/tidy.yaml");

my $global_profiles = $tidy_data->{profiles} || {};

foreach my $perltidy_version (keys %{$tidy_data->{versions}}) {
    print "Setting up $perltidy_version\n";

    make_path("$TIDY_BASE/$perltidy_version");
    system("cpanm -L $TIDY_BASE/$perltidy_version Perl::Tidy\@$perltidy_version");

    my %profiles = (%{$global_profiles}, %{$tidy_data->{versions}{$perltidy_version}});
    foreach my $profile (keys %profiles) {
        write_file("$TIDY_BASE/${perltidy_version}_${profile}.sh", <<NEW);
#!/bin/sh

PERL5LIB=${TIDY_BASE}/${perltidy_version}/lib/perl5 ${TIDY_BASE}/${perltidy_version}/bin/perltidy $profiles{$profile}
NEW

        chmod 0755, "$TIDY_BASE/${perltidy_version}_${profile}.sh";
    }
}
