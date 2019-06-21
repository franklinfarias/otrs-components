#!/usr/bin/perl -w

use strict;
use warnings;
use CGI;
use Encode;

# use ../../ as lib location
use FindBin qw($Bin);
use lib "$Bin/../..";
use lib "$Bin/../../Kernel/cpan-lib";
use lib "$Bin/../../Custom";

# load agent web interface
use Kernel::System::Web::TicketCreateChangeDefault();
use Kernel::System::ObjectManager;

local $Kernel::OM = Kernel::System::ObjectManager->new();

my $Ticket = Kernel::System::Web::TicketCreateChangeDefault->new();

# create new object CGI
my $q = new CGI;

if ($q->param()){
    my $UserLogin                   = decode("utf8", $q->param('UserLogin')) | '';
    my $Password                    = decode("utf8", $q->param('Password')) | '';
    my $Type                        = decode("utf8", $q->param('Type')) | '';
    my $Queue                       = decode("utf8", $q->param('Queue')) | '';
    my $Subject                     = decode("utf8", $q->param('Subject')) | '';
    my $Body                        = decode("utf8", $q->param('Body')) | '';
    my $Service                     = decode("utf8", $q->param('Service')) | '';
    my $SLA                         = decode("utf8", $q->param('SLA')) | '';
    my $Customer                    = decode("utf8", $q->param('Customer')) | '';
    my $Owner                       = decode("utf8", $q->param('Owner')) | '';
    # format YYYY-MM-DD HH:MM:SS
    my $DateSchedulerInitial        = decode("utf8", $q->param('DateSchedulerInitial')) | '';
    # format YYYY-MM-DD HH:MM:SS
    my $DateSchedulerFinal          = decode("utf8", $q->param('DateSchedulerFinal')) | '';
    my $Unavailable                 = decode("utf8", $q->param('Unavailable')) | '';
    my $Rollback                    = decode("utf8", $q->param('Rollback')) | '';

    # execute object
    $Ticket->Run(UserLogin => $Userlogin, Password => $Password, Type => $Type, 
    Queue => $Queue, Subject => $Subject, Body => $Body, SLA => $SLA, Service => $Service, 
    Customer => $Customer, Owner => $Owner, DateSchedulerInitial => $DateSchedulerInitial,
    DateSchedulerFinal => $DateSchedulerFinal, Unavailable => $Unavailable, Rollback => $Rollback );
} else {
    print "Content-type: text/html; charset: utf-8\n\n";
	print "<html><head><title>API::NewTicket</title>";
	print "<h1>Error</h1>";
	print "<p>Parameters not passed!</p>";
}
