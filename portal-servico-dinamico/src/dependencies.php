<?php
// Fetch DI Container
$container = $app->getContainer();

// Register Eloquent Database
$capsule = new \Illuminate\Database\Capsule\Manager;
$capsule->addConnection($container['settings']['db']);
$capsule->setAsGlobal();
$capsule->bootEloquent();

$container['db'] = function ($c) use ($capsule) {
    return $capsule;
};

// Register Twig View helper
$container['view'] = function ($c) {
    $view = new \Slim\Views\Twig('../templates', [
        'cache' => '../cache',
        'auto_reload' => true
    ]);
    
    // Instantiate and add Slim specific extension
    $router = $c->get('router');
    $uri = \Slim\Http\Uri::createFromEnvironment(new \Slim\Http\Environment($_SERVER));
    $view->addExtension(new \Slim\Views\TwigExtension($router, $uri));

    // available 'auth' in the views
    $view->getEnvironment()->addGlobal('auth', [
        'check' => $c->auth->check(),
        'user' => $c->auth->user(),
    ]);
    // available 'flash' in the views
    $view->getEnvironment()->addGlobal('flash', $c->flash);

    return $view;
};

// monolog
$container['logger'] = function ($c) {
    $settings = $c->get('settings')['logger'];
    $logger = new Monolog\Logger($settings['name']);
    $logger->pushProcessor(new Monolog\Processor\UidProcessor());
    $logger->pushHandler(new Monolog\Handler\StreamHandler($settings['path'], $settings['level']));
    return $logger;
};

// Authentication
$container['auth'] = function ($c) {
    return new \App\Auth\Auth($c);
};

// CSRF guard forms
$container['csrf'] = function ($c) {
    return new \Slim\Csrf\Guard;
};

$app->add($container->get('csrf'));
$app->add(new App\Middleware\CsrfViewMiddleware($container));

// validation
$container['validator'] = function ($c) {
    return new App\Validation\Validator;
};

$app->add(new App\Middleware\ValidationErrorsMiddleware($container));
$app->add(new App\Middleware\OldInputMiddleware($container));

// Flash Messages
$container['flash'] = function ($c) {
    return new \Slim\Flash\Messages;
};


?>