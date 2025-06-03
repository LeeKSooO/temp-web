# nginx.conf 를 컨테이너 내부 설정 위치로 복사
FROM nginx:latest
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY static /usr/share/nginx/html
