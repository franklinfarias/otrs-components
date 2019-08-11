<?php

namespace App\Controllers;

use App\Model\ITSM;
use Respect\Validation\Validator as Validator;

class ITSMController extends Controller
{
    public function index($request, $response, $args)
    {
        $this->logger->info("Application ITSMController '/itsm' route");
        $act = $request->getQueryParam('act', $default = 'all');
        // get Contratos
        $contratos = ITSM::getContratos();
        $prioridades = ITSM::getPrioridades();

        if ((substr($act,0,2) == '1.') || (substr($act,0,2) == '2.')) {
            return $this->view->render($response, "itsm/itsm_$act.html", [
                'csrf_name' => $this->csrf->getTokenName(),
                'csrf_value' => $this->csrf->getTokenValue(),
                'contratos' => $contratos,
            ]);
        } else if (substr($act,0,2) == '3.') {
            return $this->view->render($response, "itsm/itsm_$act.html", [
                'csrf_name' => $this->csrf->getTokenName(),
                'csrf_value' => $this->csrf->getTokenValue(),
                'contratos' => $contratos,
                'prioridades' => $prioridades,
            ]);
        } else {
            return $this->view->render($response, 'itsm.html', []);
        }
    }

    public function catalog($request, $response, $args)
    {
        $this->logger->info("Application ITSMController '/catalog' route");

        $model = new ITSM();
        $model->container = $this->container;
        $catalogs = $model->getServiceCatalog();

        return $this->view->render($response, 'catalog.html', [
            'catalogs' => $catalogs,
        ]);
    }

    public function category($request, $response, $args)
    {
        $this->logger->info("Application ITSMController '/catalog/category' route");

        $idCatalog = $args['id'];
        $model = new ITSM();
        $model->container = $this->container;
        $categorys = $model->getServiceCategory($idCatalog);


        return $this->view->render($response, 'category.html', [
            'categorys' => $categorys,
        ]);
    }

    public function service($request, $response, $args)
    {
        $this->logger->info("Application ITSMController '/catalog/category/service' route");

        $idCategory = $args['id'];
        $model = new ITSM();
        $model->container = $this->container;
        $services = $model->getServiceService($idCategory);

        return $this->view->render($response, 'service.html', [
            'services' => $services,
        ]);
    }

    public function requestService($request, $response, $args)
    {
        $this->logger->info("Application ITSMController '/catalog/category/service/{id}' route");

        $idService = $args['id'];

        return $this->view->render($response, 'form.html', [
            'csrf_name' => $this->csrf->getTokenName(),
            'csrf_value' => $this->csrf->getTokenValue(),
            'service_id' => $idService,
        ]);
    }

    public function store($request, $response, $args)
    {
        // Validation is in the page by javascript
        // Example: validate attributes
        //$validation = $this->validator->validate($request, [
        //    'contrato' => Validator::notEmpty(),
        //    'assunto' => Validator::notEmpty(),
        //    'descricao' => Validator::notEmpty(),
        //    'quandoErro' => Validator::notEmpty(),
        //    'ondeErro' => Validator::notEmpty(),
        //]);
        //if ($validation->failed()){
        //    return $response->withRedirect('/itsm?act='.$this->act);
        //}

        $model = new ITSM();
        $model->container = $this->container;
        $model->setAllParams($request);

        if ($model->createTicket()){
            $response = $response->withRedirect($this->router->pathFor('catalog'));
        } else {
            $response = $response->withRedirect($this->router->pathFor('requestService').'/'.$args['Id']);
        }

        return $response;
    }
}
