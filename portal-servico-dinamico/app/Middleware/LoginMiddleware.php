<?php


namespace App\Middleware;

class LoginMiddleware extends Middleware
{
    public function __invoke($request, $response, $next){
        $route = $request->getAttribute('route');
        $groups = $route->getGroups();

        if (!isset($_SESSION['SessionID']) && !in_array('auth', $groups)){
            $response = $response->withRedirect('/login');
        } else {
            $response = $next($request,$response);
        }
        
        return $response;
    }
}