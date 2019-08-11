<?php


namespace App\Middleware;

class ValidationErrorsMiddleware extends Middleware
{

    /**
     *
     * To use in template:
     *    <div class="form-group{{ errors.username ? ' has-error' : '' }}">
     *    {% if errors.username %}
     *        <span class="help-block">{{ errors.username | first }}</span>
     *    {% endif %}
     *
     * @param $request
     * @param $response
     * @param $next
     * @return mixed
     */
    public function __invoke($request, $response, $next)
    {
        if (isset($_SESSION['errors'])) {
            $this->container->view->getEnvironment()->addGlobal('errors', $_SESSION['errors']);
            unset($_SESSION['errors']);
        }

        $response = $next($request,$response);
        return $response;
    }
}