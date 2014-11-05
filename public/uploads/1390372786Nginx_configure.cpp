server {

        listen       8888;
        server_name  require.js;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            root   /Users/khalilz/khalil_vmware/heroapp-DaysOff/public;
            index  index.html index.htm;
            if ( $uri !~ ^/(index\.html|css|js|img|pages|favicon\.ico) ) {
                rewrite ^ /index.html last;
            }
        }

        location ~ ^/li\/api/(.*)$ {
            proxy_pass http://127.0.0.1:4567;
        }

        location ~ (common).(css|js) {
            proxy_pass http://127.0.0.1:4567;
        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }