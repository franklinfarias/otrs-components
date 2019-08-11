<?php

namespace App\Auth;

class Auth
{
    protected $container;

    public function __construct($container){
        $this->container = $container;
    }

    public function check(){
        return isset($_SESSION['SessionID']);
    }

    public function user(){
        return (isset($_SESSION['username'])?$_SESSION['username']:null);
    }

    public function attempt($username, $password)
    {
        if (empty($username) || empty($password)){
            return false;
        }
        $ws = $this->container->settings['ws_location'];
        $soap = new \SoapClient(null, array(
            'uri' => "http://www.otrs.org/TicketConnector/",
            'location' => "$ws",
        ));

        $session = $soap->SessionCreate(
            new \SoapParam($username, 'CustomerUserLogin'),
            new \SoapParam($password, 'Password')
        );

        if ($session->ErrorCode) {
            $_SESSION['error'] = $session->ErrorCode;
            return false;
        } else {
            $_SESSION['SessionID'] = $session;
            $_SESSION['username'] = $username;
            return true;
        }
    }
}