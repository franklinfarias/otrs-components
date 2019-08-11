<?php

namespace App\Model;

class Model
{
    public $container;
    protected $ws_location;
    protected $csrf_name;
    protected $csrf_value;
    // default ticket variables
    protected $user;
    protected $type;
    protected $queue;
    protected $state;
    protected $priority;
    protected $service_id;
    protected $service;
    protected $subject;
    protected $description;
    protected $attachment;

    /**
     *
     */
    public function __construct(){

    }

    /**
     * Get the all property
     * @param $property
     * @return mixed
     */
    public function __get($property){
        if ($this->{$property}){
            return $this->{$property};
        }
    }

    /**
     * Set the all property
     * @param $property
     * @return mixed
     */
    public function __set($property, $value){
        if ($this->{$property}){
            $this->{$property} = $value;
        }
    }

    /**
     * Set all request parameters to property
     */
    public function setAllParams($request){
        foreach ($request->getParams() as $key => $value) {
            $this->$key = $value;
        }
    }

}