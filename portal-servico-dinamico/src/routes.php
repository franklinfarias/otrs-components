<?php
use Slim\Http\Request;
use Slim\Http\Response;

/*
https://www.youtube.com/playlist?list=PLfdtiltiRHWGc_yY90XRdq6mRww042aEC
*/

/*
Permite que as rotas terminem com ou sem a /
*/
$app->add(function (Request $request, Response $response, callable $next) {
    $uri = $request->getUri();
    $path = $uri->getPath();

    if ($path != '/' && substr($path, -1) == '/') {
        // permanently redirect paths with a trailing slash
        // to their non-trailing counterpart
        $uri = $uri->withPath(substr($path, 0, -1));
        
        if($request->getMethod() == 'GET') {
            return $response->withRedirect((string)$uri, 301);
        }
        else {
            return $next($request->withUri($uri), $response);
        }
    }

    return $next($request, $response);
});

// Rotas
$app->get('/',
    function (Request $request, Response $response, array $args) {
        $this->logger->info("Application '/' route");
        return $this->view->render($response, 'index.html', []);
    }
)->setName('home');

$app->get('/login', \App\Controllers\LoginController::class . ':login')->setName('login');
$app->post('/login', \App\Controllers\LoginController::class . ':login')->setName('loginPost');
$app->get('/logout', \App\Controllers\LoginController::class . ':logout')->setName('logout');

// Rotas com autenticação
$app->group('', function () use ($app) {
    $app->get('/type', \App\Controllers\ITSMController::class . ':type')->setName('type');
    $app->get('/type/{id}/group', \App\Controllers\ITSMController::class . ':group')->setName('group');
    $app->get('/type/group/{id}/category', \App\Controllers\ITSMController::class . ':category')->setName('category');
    $app->get('/type/group/category/{id}/service', \App\Controllers\ITSMController::class . ':service')->setName('service');
    $app->get('/type/group/category/service/{id}', \App\Controllers\ITSMController::class . ':requestService')->setName('requestService');
    $app->get('/catalog', \App\Controllers\ITSMController::class . ':catalog')->setName('catalog');
    //$app->get('/catalog/{id}/category', \App\Controllers\ITSMController::class . ':category')->setName('category');
    //$app->get('/catalog/category/{id}/service', \App\Controllers\ITSMController::class . ':service')->setName('service');
    //$app->get('/catalog/category/service/{id}', \App\Controllers\ITSMController::class . ':requestService')->setName('requestService');
    $app->post('/store', \App\Controllers\ITSMController::class . ':store')->setName('store');
})->add(function ($request, $response, $next){
    $uri = $request->getUri();
    $route = $request->getAttribute('route');
    // add route name to view
    $this->view->getEnvironment()->addGlobal('route', $route->getName());

    $_SESSION['redirect_to'] = $uri->getPath();

    $this->logger->info("Auth validate ...");
    if (!$this->auth->check()){
        $this->logger->info("Auth nok ...");
        $response = $response->withRedirect($this->router->pathFor('login'));
    } else {
        $this->logger->info("Auth ok ...");
        $response = $next($request,$response);
    }
    return $response;
});

?>