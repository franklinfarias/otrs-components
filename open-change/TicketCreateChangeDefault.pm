#!/usr/bin/perl -w
# --
# This is a module for a create Ticket Default Change by parameters
# --

package Kernel::System::Web::TicketCreateChangeDefault;

use strict;
use warnings;


# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);

use SOAP::Lite;
use Data::Dumper;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::ObjectManager;

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::ObjectManager',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}
 
sub Run {

    my ( $Self, %Param ) = @_;

    # ---
    # Variables to be defined.
    my $UserLogin    = 'atendeti';
    my $Password     = 'G87p2VyN';
    my $Type1        = $Param{Type};
    my $Queue        = $Param{Queue};
    my $Subject      = $Param{Subject};
    my $Body         = $Param{Body};
    my $State        = 'Registrada';
    my $Service      = $Param{Service};
    my $SLA          = $Param{SLA};
    my $Customer     = $Param{Customer};
    my $Owner        = $Param{Owner};
    my $SchInitial   = $Param{DateSchedulerInitial};
    my $SchFinal     = $Param{DateSchedulerFinal};
    my $Unavailable  = $Param{Unavailable};
    my $Rollback     = $Param{Rollback};

    # this is the URL for the web service
    my $URL = 'http://localhost/otrs/nph-genericinterface.pl/Webservice/wbx';

    # this name space should match the specified name space in the SOAP transport for the web service.
    my $NameSpace = 'http://www.otrs.org/TicketConnector/';

    # this is operation to execute, it could be TicketCreate, TicketUpdate, TicketGet, TicketSearch
    # or SessionCreate. and they must to be defined in the web service.
    my $OperationCreate = 'TicketCreate';

    # this variable is used to store all the parameters to be included on a request in XML format. Each
    # operation has a determined set of mandatory and non mandatory parameters to work correctly. Please
    # check the OTRS Admin Manual in order to get a complete list of parameters.
    my $XMLDataCreate = "
        <UserLogin>$UserLogin</UserLogin>
        <Password>$Password</Password>
        <Ticket>
            <Title>$Subject</Title>
            <CustomerUser>$Customer</CustomerUser>
            <Type>$Type1</Type>
            <Queue>$Queue</Queue>
            <State>$State</State>
            <Service>$Service</Service>
            <SLA>$SLA</SLA>
            <Priority>3 normal</Priority>
        </Ticket>
        <Article>
            <Subject>$Subject</Subject>
            <Body>$Body</Body>
            <ContentType>text/plain; charset=utf8</ContentType>
        </Article>
        <DynamicField>
            <Name>ProcessManagementProcessID</Name>
            <Value>Process-e8b31d03d690e13ed3f734660016588a</Value>
        </DynamicField>
        <DynamicField>
            <Name>ProcessManagementActivityID</Name>
            <Value>Activity-b5e2d06bdecfbb210ada01a68c955265</Value>
        </DynamicField>
        <DynamicField>
            <Name>PMHaveraindisponibilidade</Name>
            <Value>$Unavailable</Value>
        </DynamicField>
        <DynamicField>
            <Name>PMRegistroManutencaoMonitoramento</Name>
            <Value>$Unavailable</Value>
        </DynamicField>
        <DynamicField>
            <Name>PMDataAgendamentoInicial</Name>
            <Value>$SchInitial</Value>
        </DynamicField>
        <DynamicField>
            <Name>PMDataAgendamentoFinal</Name>
            <Value>$SchFinal</Value>
        </DynamicField>
        <DynamicField>
            <Name>PMProcedimentoRemediacao</Name>
            <Value>$Rollback</Value>
        </DynamicField>
        ";

    # Ticket Create
    my $Ticket = $Self->ExecSOAP(XMLData => $XMLDataCreate, NameSpace=> $NameSpace, URL => $URL, Operation => $OperationCreate);
    
    # response in HTML
    #print "Content-type: text/html\n\n";
    #print "<html><head><title>Ticket Criado</title>";
    #print "</head>\n<body>";
    #print $Ticket->{TicketCreateResponse}{TicketNumber};
    #print "</body></html>";
    # ---

    # response in JSON
    $Self->ResponseJSON($Ticket);
}

sub ResponseJSON {
    my ( $Self, $Param ) = @_;

    print "Content-type: text/json\n\n";

    if ($Param){
        my $json->{"ticket"} = $Param->{TicketCreateResponse}{TicketNumber};
        my $json_text = to_json($json);
        print $json_text;
    } else {
        my @err = ('error to create ticket. check params.');
        my $json_text = to_json(@err);
        print $json_text;
    }
}

sub ExecSOAP {
    my ( $Self, %t ) = @_;

    my $XMLData = $t{XMLData};
    my $NameSpace = $t{NameSpace};
    my $URL = $t{URL};
    my $Operation = $t{Operation};
    # create a SOAP::Lite data structure from the provided XML data structure.
    my $SOAPData = SOAP::Data
        ->type( 'xml' => $XMLData );

    my $SOAPObject = SOAP::Lite
        ->uri($NameSpace)
        ->proxy($URL)
        ->$Operation($SOAPData);

    # check for a fault in the soap code.
    if ( $SOAPObject->fault ) {
        print $SOAPObject->faultcode, " ", $SOAPObject->faultstring, "\n";
    }

    # otherwise print the results.
    else {

        # get the XML response part from the SOAP message.
        my $XMLResponse = $SOAPObject->context()->transport()->proxy()->http_response()->content();

        # deserialize response (convert it into a perl structure).
        my $Deserialized = eval {
            SOAP::Deserializer->deserialize($XMLResponse);
        };

        # remove all the headers and other not needed parts of the SOAP message.
        my $Body = $Deserialized->body();

        # just output relevant data and no the operation name key (like TicketCreateResponse).

        #for my $ResponseKey ( keys %{$Body} ) {
        #    print Dumper( $Body->{$ResponseKey} );
        #}
        return $Body;
    }
}
1;
