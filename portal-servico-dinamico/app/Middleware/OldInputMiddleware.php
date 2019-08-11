<?php


namespace App\Middleware;

class OldInputMiddleware extends Middleware
{

    /**
     *
     * To use in template:
     *   ... name="username" value="{{ old.username }}">
     *
     * @param $request
     * @param $response
     * @param $next
     * @return mixed
     */
    public function __invoke($request, $response, $next)
    {
        if (isset($_SESSION['old'])){
            $this->container->view->getEnvironment()->addGlobal('old', $_SESSION['old']);
            $_SESSION['old'] = $request->getParams();
        }

        $response = $next($request,$response);
        return $response;
    }
}