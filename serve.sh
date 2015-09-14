#!/usr/bin/env bash

function serve() {
    if [[ "$1" && "$2" ]] then
        block="server {\n    listen 80;\n    server_name $1;\n    root \"$2\";\n    index index.html index.htm index.php;\n    charset utf-8;\n    location / {\n        try_files \$uri \$uri/ /index.php?\$query_string;\n    }\n    location = /favicon.ico { access_log off; log_not_found off; }\n    location = /robots.txt  { access_log off; log_not_found off; }\n    access_log off;\n    error_log  /var/log/nginx/$1-error.log error;\n    sendfile off;\n    client_max_body_size 100m;\n    location ~ \.php$ {\n        fastcgi_split_path_info ^(.+\.php)(/.+)$;\n        fastcgi_pass unix:/var/run/php5-fpm.sock;\n        fastcgi_index index.php;\n        include fastcgi_params;\n        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;\n        fastcgi_intercept_errors off;\n        fastcgi_buffer_size 16k;\n        fastcgi_buffers 4 16k;\n        fastcgi_connect_timeout 300;\n        fastcgi_send_timeout 300;\n        fastcgi_read_timeout 300;\n    }\n    location ~ /\.ht {\n        deny all;\n    }\n}\n"

        sudo touch "/etc/nginx/sites-available/$1"
        sudo echo "$block" >> "/etc/nginx/sites-available/$1"
        sudo ln -fs "/etc/nginx/sites-available/$1" "/etc/nginx/sites-enabled/$1"
        service nginx restart
        service php5-fpm restart
    else
        echo "Error: missing required parameters."
        echo "Usage: "
        echo "  serve domain path"
    fi
}