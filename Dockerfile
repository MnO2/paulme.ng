FROM nginx
EXPOSE 80
COPY _site/ /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
