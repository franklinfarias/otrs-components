<?php


namespace App\Middleware;

class CsrfViewMiddleware extends Middleware
{

    /**
     *
     * To use in template:
     *      {{ csrf.field | raw }}
     *
     * @param $request
     * @param $response
     * @param $next
     * @return mixed
     */
    public function __invoke($request, $response, $next)
    {
        $nameKey = $this->container->csrf->getTokenNameKey();
        $valueKey = $this->container->csrf->getTokenValueKey();
        $name = $request->getAttribute($nameKey);
        $value = $request->getAttribute($valueKey);

        $this->container->view->getEnvironment()->addGlobal('csrf', [
            'field' => '
                <input type="hidden" name="'.$nameKey.'" value="'.$name.'">
                <input type="hidden" name="'.$valueKey.'" value="'.$value.'">
            ',
        ]);


        $response = $next($request,$response);
        return $response;
    }
}