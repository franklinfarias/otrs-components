<?php

namespace App\Model;

class ITSM extends Model
{
    // others variables
    protected $act;
    protected $assunto;
    protected $descricao;
    protected $contrato;
    protected $quandoErro;
    protected $ondeErro;
    protected $dataProposicao1;
    protected $dataProposicao2;
    protected $dataExpectativa;
    protected $perfil;
    protected $publico;
    protected $prioridade;


    /**
     * @param $serviceName
     * @return mixed
     */
    private function getService($serviceName){
        $services = $this->container->db->table('service')
            ->where('name', $serviceName)
            ->get();
        return $services;
    }

    /**
     * @param $serviceName
     * @return mixed
     */
    private function getServicePreferences($serviceId){
        $services = $this->container->db->table('service_preferences')
            ->where('preferences_key','like','Service%Business')
            ->where('service_id',$serviceId)
            ->get();
        return $services;
    }

    /**
     * Override method
     */
    public function setAllParams($request)
    {
        parent::setAllParams($request);
        // set User
        $this->user = (isset($_SESSION['username']) ? $_SESSION['username'] : '');

        // get services
        $services = $this->container->db->table('service')
            ->where('id', $this->service_id)
            ->get();
        $service = explode('::', $services[0]->name);
        // set Type
        $this->type = 'Requisição de Serviço';
        // set Queue
        $this->queue = $service[0];
        // set State
        $this->state = 'Novo';
        // set Service
        $this->service = $services[0]->name;
        // set Priority
        $this->priority = '1 Baixa';
        // set Body
        $this->description = "Descrição do Chamado: " . $this->description . "\n";
        // Attachment
        $this->attachment = $_FILES;
    }

    /**
     *
     */
    public function getServiceType(){
        // Get All Services
        $services = $this->container->db->table('service')
            ->join('service_customer_user','service.id','=','service_customer_user.service_id')
            ->select('service.*')
            ->where('service.valid_id', 1)
            ->where('service.type_id', 4)
            ->orderBy('service.name')
            ->get();

        $catalog = array();
        $oldCatalog = '';
        foreach ($services as $service) {
            $tmp = explode('::', $service->name);
            $id = $this->getService($tmp[0]);
            $idCatalog = $id[0]->id;

            if ($oldCatalog != $tmp[0]){
                $catalog[] = array(
                    'Id' => $idCatalog,
                    'Name' => $tmp[0],
                    'Type' => $tmp[0],
                    //'Queue' => $tmp[1],
                    'Queue' => '',
                    //'Origin' => $tmp[0].'::'.$tmp[1],
                    'Origin' => $tmp[0],
                    'Img' => '',
                    'Description' => '',
                );
            }
            $oldCatalog = $tmp[0];
        }

        // Get Services attributes
        $tmp = $catalog;
        foreach ($catalog as $key => $item){
            // get attributes
            // random images:: https://picsum.photos/
            $servicePref = $this->getServicePreferences($item['Id']);
            foreach($servicePref as $pref){
                if ($pref->preferences_key == 'ServiceCommentBusiness'){
                    $tmp[$key]['Description'] = $pref->preferences_value;
                }
                if ($pref->preferences_key == 'ServiceImgBusiness'){
                    $tmp[$key]['Img'] = $pref->preferences_value;
                }
            }

        }
        $catalog = $tmp;

        return $catalog;
    }

    /**
     *
     */
    public function getServiceGroup($id){
        // Get All Services
        $services = $this->container->db->table('service')
            ->join('service_customer_user','service.id','=','service_customer_user.service_id')
            ->select('service.*')
            ->where('service.valid_id', 1)
            ->where('service.type_id', 4)
            ->where('service.name','like',"$id%")
            ->orderBy('service.name')
            ->get();

        $catalog = array();
        $oldCatalog = '';
        foreach ($services as $service) {
            $tmp = explode('::', $service->name);
            $id = $this->getService($tmp[0].'::'.$tmp[1]);
            $idCatalog = $id[0]->id;

            if ($oldCatalog != $tmp[1]){
                $catalog[] = array(
                    'Id' => $idCatalog,
                    'Name' => $tmp[1],
                    'Type' => $tmp[0],
                    'Queue' => $tmp[1],
                    //'Queue' => '',
                    'Origin' => $tmp[0].'::'.$tmp[1],
                    //'Origin' => $tmp[1],
                    'Img' => '',
                    'Description' => '',
                );
            }
            $oldCatalog = $tmp[1];
        }

        // Get Services attributes
        $tmp = $catalog;
        foreach ($catalog as $key => $item){
            // get attributes
            // random images:: https://picsum.photos/
            $servicePref = $this->getServicePreferences($item['Id']);
            foreach($servicePref as $pref){
                if ($pref->preferences_key == 'ServiceCommentBusiness'){
                    $tmp[$key]['Description'] = $pref->preferences_value;
                }
                if ($pref->preferences_key == 'ServiceImgBusiness'){
                    $tmp[$key]['Img'] = $pref->preferences_value;
                }
            }

        }
        $catalog = $tmp;

        return $catalog;
    }

    /**
     *
     */
    public function getServiceCategory($id){
        // Get All Services
        $services = $this->container->db->table('service')
            ->join('service_customer_user','service.id','=','service_customer_user.service_id')
            ->select('service.*')
            ->where('service.valid_id', 1)
            ->where('service.type_id', 4)
            ->where('service.name','like',"$id%")
            ->orderBy('service.name')
            ->get();

        $category = array();
        $oldCategory = '';
        foreach ($services as $service) {
            $tmp = explode('::', $service->name);
            $id = $this->getService($tmp[0].'::'.$tmp[1].'::'.$tmp[2]);
            $idCategory = $id[0]->id;

            if ($oldCategory != $tmp[2]){
                $category[] = array(
                    'Id' => $idCategory,
                    'Name' => $tmp[2],
                    'Type' => $tmp[0],
                    'Queue' => $tmp[1],
                    'Origin' => $tmp[0].'::'.$tmp[1].'::'.$tmp[2],
                    'Img' => '',
                    'Description' => '',
                );
            }
            $oldCategory = $tmp[2];
        }

        // Get Services attributes
        $tmp = $category;
        foreach ($category as $key => $item){
            $servicePref = $this->getServicePreferences($item['Id']);
            foreach($servicePref as $pref){
                if ($pref->preferences_key == 'ServiceCommentBusiness'){
                    $tmp[$key]['Description'] = $pref->preferences_value;
                }
                if ($pref->preferences_key == 'ServiceImgBusiness'){
                    $tmp[$key]['Img'] = $pref->preferences_value;
                }
            }

        }
        $category = $tmp;

        return $category;
    }

    /**
     *
     */
    public function getServiceCatalog(){
        // Get All Services
        $services = $this->container->db->table('service')
            ->join('service_customer_user','service.id','=','service_customer_user.service_id')
            ->select('service.*')
            ->where('service.valid_id', 1)
            ->where('service.type_id', 4)
            ->orderBy('service.name')
            ->get();

        $catalog = array();
        $oldCatalog = '';
        foreach ($services as $service) {
            $tmp = explode('::', $service->name);
            $id = $this->getService($tmp[0].'::'.$tmp[1]);
            $idCatalog = $id[0]->id;

            if ($oldCatalog != $tmp[0]){
                $catalog[] = array(
                    'Id' => $idCatalog,
                    'Name' => $tmp[0],
                    'Type' => $tmp[0],
                    //'Queue' => $tmp[1],
                    'Queue' => '',
                    //'Origin' => $tmp[0].'::'.$tmp[1],
                    'Origin' => $tmp[0],
                    'Img' => '',
                    'Description' => '',
                );
            }
            $oldCatalog = $tmp[0];
        }

        // Get Services attributes
        $tmp = $catalog;
        foreach ($catalog as $key => $item){
            // get attributes
            // random images:: https://picsum.photos/
            $servicePref = $this->getServicePreferences($item['Id']);
            foreach($servicePref as $pref){
                if ($pref->preferences_key == 'ServiceCommentBusiness'){
                    $tmp[$key]['Description'] = $pref->preferences_value;
                }
                if ($pref->preferences_key == 'ServiceImgBusiness'){
                    $tmp[$key]['Img'] = $pref->preferences_value;
                }
            }

        }
        $catalog = $tmp;

        return $catalog;
    }

    

    /**
     *
     */
    public function getServiceService($id){
        // Get All Services
        $services = $this->container->db->table('service')
            ->join('service_customer_user','service.id','=','service_customer_user.service_id')
            ->select('service.*')
            ->where('service.valid_id', 1)
            ->where('service.type_id', 4)
            ->where('service.name','like',"$id%")
            ->orderBy('service.name')
            ->get();

        $obj = array();
        $oldService = '';
        foreach ($services as $service) {
            $tmp = explode('::', $service->name);
            //$id = $this->getService($tmp[0].'::'.$tmp[1].'::'.$tmp[2].'::'.$tmp[3]);
            //$idService = $id[0]->id;
            $idService = $service->id;

            if ($oldService != $tmp[2]){
                $obj[] = array(
                    'Id' => $idService,
                    'Name' => $tmp[2],
                    'Type' => $tmp[0],
                    'Queue' => $tmp[1],
                    'Origin' => $tmp[0].'::'.$tmp[1].'::'.$tmp[2],
                    'Img' => '',
                    'Description' => '',
                );
            }
            $oldService = $tmp[2];
        }

        // Get Services attributes
        $tmp = $obj;
        foreach ($obj as $key => $item){
            $servicePref = $this->getServicePreferences($item['Id']);
            foreach($servicePref as $pref){
                if ($pref->preferences_key == 'ServiceCommentBusiness'){
                    $tmp[$key]['Description'] = $pref->preferences_value;
                }
                if ($pref->preferences_key == 'ServiceImgBusiness'){
                    $tmp[$key]['Img'] = $pref->preferences_value;
                }
            }

        }
        $obj = $tmp;

        return $obj;
    }

    /**
     * Create a ticket with parameters by Webservice
     * 
     */
    public function createTicket()
    {
        $soap = new \SoapClient(null, array(
            'uri'        => "http://www.otrs.org/TicketConnector/",
            'location'   => $this->container->settings['ws_location'],
        ));

        $Ticket = array(
            'Type' => $this->type,
            'Queue' => $this->queue,
            'Service' => $this->service,
            'State' => $this->state,
            'Priority' => $this->priority,
            'Title' => $this->subject,
            'CustomerUser' => $this->user
        );

        $Article = array(
            'Subject' => $this->subject,
            'Body' => $this->description,
            'ContentType' => 'text/plain; charset=utf-8',
        );

        /*$DynamicField = array(
            array(
                'Name' => 'severidade',
                'Value' => 'NA'
            ),
            array(
                'Name' => 'localidade',
                'Value' => 'SEDE'
            ),
            array(
                'Name' => 'PRIContrato',
                'Value' => strtoupper($this->contrato)
            ),
            array(
                'Name' => 'tempoRegistro',
                'Value' => '00:00:01'
            )
        );*/

        $httpResponse = "";

        if (!empty($this->attachment['anexo']['name'])) {
            $Attachment = array(
                array(
                    'Filename' => $this->attachment['anexo']['name'],
                    'Content' => base64_encode(file_get_contents($this->attachment['anexo']['tmp_name'])),
                    'ContentType' => $this->attachment['anexo']['type']
                )
            );
            $httpResponse = $soap->TicketCreate(
                new \SoapParam('atendeti', 'UserLogin'),
                new \SoapParam('G87p2VyN', 'Password'),
                new \SoapParam($Ticket, 'Ticket'),
                new \SoapParam($Article, 'Article'),
                //new \SoapParam($DynamicField, 'DynamicField'),
                new \SoapParam($Attachment, 'Attachment')
            );
        } else {
            $httpResponse = $soap->TicketCreate(
                new \SoapParam('atendeti', 'UserLogin'),
                new \SoapParam('G87p2VyN', 'Password'),
                new \SoapParam($Ticket, 'Ticket'),
                new \SoapParam($Article, 'Article')
                //new \SoapParam($DynamicField, 'DynamicField')
            );
        }
        if ($httpResponse->ErrorCode) {
            //$_SESSION['error'] = $httpResponse->ErrorMessage;
            $this->container->flash->addMessage('error', $httpResponse->ErrorMessage);
            return false;
        } else {
            //$_SESSION['TN'] = $httpResponse['TicketNumber'];
            $this->container->flash->addMessage('info', "Ticket número " . $httpResponse['TicketNumber'] . " criado com sucesso!");
            return true;
        }
    }
}
