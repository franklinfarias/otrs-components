<?php


namespace App\Middleware;

class Middleware
{
    protected $container;

    public function __construct($container)
    {
        $this->container = $container;
    }

    //public function __invoke($request, $response, $next){
    //    $response = $next($request,$response);
    //    return $response;
    //}
}