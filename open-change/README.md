## Components Ticket Create Change by RESTFul

This is a component that you create tickets by parameters.
Create a default change (Mudança Padrão) in the model configuring on OTRS.

## Installing on Server

Copy the file TicketCreateChangeDefault.pm to {OTRS_HOME}/Kernel/System/Web.

Copy the file changeChange.pl to {OTRS_HOME}/bin/cgi-bin.

Restart your Apache or apply the configurations (sudo apachectl -k graceful).

## Installing on Local

Install the Perl library: IO::Prompt and IO::Prompter

Copy the files otrs.TicketDaily.pl and otrs.TicketDaily.txt to your machine.

## Using the module

Adjust and include parameters on the file otrs.TicketDaily.txt.

Execute the file otrs.TicketDaily.pl (perl otrs.TicketDaily.pl).

<img src="https://github.com/franklinfarias/otrs-components/images/otrsTicketChangeDefault.png" width="200" height="200" />
