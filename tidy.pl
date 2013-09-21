#!/usr/bin/perl

use strict;
use warnings;

use IPC::Run3;

print "Content-type: text/plain\n\n";

my $query = $ENV{QUERY_STRING};

my $pt_version;
if ($query) {
    $pt_version = ( split( /=/, $query ) )[1];
    my $pt_script = "/tidy/${pt_version}.sh";
    if ( !-e $pt_script ) {
        print "No version $pt_version\n";
        exit;
    }

    my $data;
    sysread( STDIN, $data, $ENV{CONTENT_LENGTH} );

    run3 [$pt_script], \$data;
}
else {
    print "Send the version to use with v=\n";
    exit;
}

exit;
