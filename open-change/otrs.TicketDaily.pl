#!/usr/bin/perl -w

use strict;
use warnings;
use utf8;

use IO::Prompter;
use LWP::Simple;
use JSON;
use Data::Dumper;
use Date::Parse;
use File::Basename;

# you need change the url to set OTRS instance
#my $url = "http://suporte.agu.gov.br/otrs/changeDefault.pl";
my $url = "http://itsm-agu.hepta.com.br/otrs/changeDefault.pl";

my $TicketID = 0;
my $ArticleID = 0;

my $Usr = prompt 'Enter OTRS user: ', -echo=>'*';
my $Pwd = prompt 'Enter OTRS user password: ', -echo=>'*';
my $FileName = prompt 'Enter the filename path: ';

if ($Usr eq '' || $Pwd eq '' || $FileName eq ''){
    print "  Please enter with user, password and filename path.\n";
    exit 0;
}

if (open(my $fh, '<:encoding(UTF-8)', $FileName)) {

  while (my $row = <$fh>) {
    chomp $row;
    next if $row =~ /^\s*$/; # check if line is blank
    if (!($row =~ /#/i)){
        my @Params = split /;/, $row;

        if (@Params){ 

            # Check Type exists       $Params[0]
            # Check Queue exists      $Params[1]
            # Check Customer exists   $Params[2]
            # Check Owner exists      $Params[3]
            # Check Subject exists    $Params[4]
            # Cehck Body exists       $Params[5]
            # Check Service exists    $Params[6]
            # Check SLA exists        $Params[7]
            # Check DateSchedulerInitial exists        $Params[8]
            # Check DateSchedulerFinal exists          $Params[9]
            # Check Unavailable exists                 $Params[10]
            # Check Rollback exists                    $Params[11]

            my $request = "?UserLogin=$Usr&Password=$Pwd&Type=$Params[0]&Queue=$Params[1]&Customer=$Params[2]&Owner=$Params[3]&Subject=$Params[4]&Body=$Params[5]&Service=$Params[6]&SLA=$Params[7]&DateSchedulerInitial=$Params[8]&DateSchedulerFinal=$Params[9]&Unavailable=$Params[10]&Rollback=$Params[11]";
            
            my $response = get( $url.$request );
            #my $json = decode_json($response);
            #print Dumper $json;
            print Dumper $response;
            
        }
    }
  }
} else {
  warn "Could not open file '$FileName' $!\n";
}

sub PrintUsage {
    my $UsageText = "Usage:\n";
    $UsageText .= " otrs.TicketDaily.pl\n\n";
    $UsageText .= " perl /my/folder/otrs.TicketDaily.pl\n\n";
    $UsageText .= " Format of file: \n";
    $UsageText .= "      type;queue;customer;owner;subject;description;service;sla;DateSchedulerInitial;DateSchedulerFinal;Unavailable;Rollback\n";
    print STDOUT "$UsageText\n";

    return 1;
}

