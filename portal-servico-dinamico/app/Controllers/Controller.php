<?php

namespace App\Controllers;

class Controller
{
    protected $container;

    /**
     * Controller constructor.
     * @param ContainerInterface $container
     */
    public function __construct($container) {
        $this->container = $container;
    }

    /**
     * Get the all property from Slim\Container
     * @param $property
     * @return mixed
     */
    public function __get($property){
        if ($this->container->{$property}){
            return $this->container->{$property};
        }
    }

}