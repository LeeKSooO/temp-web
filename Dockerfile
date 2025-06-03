# nginx.conf 를 컨테이너 내부 설정 위치로 복사
#FROM nginx:latest
#COPY nginx/nginx.conf /etc/nginx/nginx.conf
#COPY static /usr/share/nginx/html

## -- React App 빌드 -- ##
FROM node:20-alpine as build-stage

WORKDIR /app

# package.json과 package-lock.json 을 먼저 복사해서 종속성 설치 최적화
# 파일 변경 시 종속성 재설치 방지
COPY package*.json ./

# 종속성 설치
RUN npm install

# 모든 프론트엔드 소스 코드 복사(public, css, index.html, vite.config.ts 등등)
# Vite 프로젝트의 모든 소스 파일들이 /app 디렉토리로 복사
COPY . . 

# React 앱 빌드
RUN npm run build

## --Nginx Server Config 및 빌드된 React 앱 서빙 -- ##
FROM nginx:alpine

# Nginx 설정 파일을 컨테이너 내부 경로로 복사
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# 빌드된 React 앱을 Nginx 문서 루트로 복사
# build-stage에서 생성된 /app/dist 폴더의 내용을 Nginx의 /usr/share/nginx/html로 복사
COPY --from=build-stage /app/dist /usr/share/nginx/html

EXPOSE 80

