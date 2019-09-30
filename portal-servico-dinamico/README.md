#Portal de Serviços
Portal de Serviços dinâmico para todas as áreas da empresa.

Este componente utiliza o framework Slim para aplicações em PHP 7.

##Instalação
- Instalar o pacote FKSBusinessCatalogPortal;

- Configurar os serviços com a seguinte estrutura:

    Incidente::Redes::Firewall::Sem acesso ao site
    
    Onde:
        - Incidente = Tipo do Ticket
        - Redes     = Fila
        - Firewall  = Categoria
        - Serviço   = Sem acesso ao site
        
- Configurar o portal:
```bash
    cd /opt
    git clone ...
    mv portal-servico-dinamico/ portal
    cd portal
    composer update
    cd ..
    mkdir portal/logs && mkdir portal/cache
    chmod -R 766 portal/logs
    chmod -R 766 portal/cache
    cat > /etc/httpd/conf.d/portal_servicos.conf <<EOF
    # Configuracao Portal Servicos
    Alias /portal "/opt/portal/public"
    <Directory "/opt/portal/public">
        RewriteEngine On
        RewriteCond %{REQUEST_URI}::$1 ^(/.+)/(.*)::\2$
        RewriteRule ^(.*) - [E=BASE:%1]
        RewriteBase /portal
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteRule ^ index.php [QSA,L]
        AllowOverride None
        Require all granted
    </Directory>
    EOF
    apachectl -k graceful
```
