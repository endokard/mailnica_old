#/etc/httpd/conf.d/admin.mailnica.com.conf
<VirtualHost *:80>
    ServerName admin.mailnica.com
    DocumentRoot /var/www/admin.mailnica.com/public_html/public
    ErrorLog /var/www/admin.mailnica.com/error.log
    CustomLog /var/www/admin.mailnica.com/requests.log combined
</VirtualHost>
