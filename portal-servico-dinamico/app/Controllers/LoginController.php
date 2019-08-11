<?php

namespace App\Controllers;


class LoginController extends Controller
{

    public function login($request, $response, $args){
        if ($request->isPost()){
            $this->logger->info("Request loginPost");
            $auth = $this->auth->attempt(
                $request->getParam('username'),
                $request->getParam('password')
            );

            if (!$auth){
                $this->flash->addMessage('error', 'Usuário ou senha inválidos!');
                return $response->withRedirect($this->router->pathFor('login'));
            } else {
                if (isset($_SESSION['redirect_to'])){
                    return $response->withRedirect($_SESSION['redirect_to']);
                } else {
                    return $response->withRedirect($this->router->pathFor('home'));
                }
            }
        }
        return $this->view->render($response, 'login.html', [
            'csrf_name' => $this->csrf->getTokenName(),
            'csrf_value' => $this->csrf->getTokenValue(),
        ]);
    }

    public function logout($request, $response, $args){
        $_SESSION['SessionID'] = null;
        $_SESSION['username'] = null;
        return $response->withRedirect($this->router->pathFor('home'));
    }

}