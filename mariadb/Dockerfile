FROM mariadb:latest

RUN apt-get -y update && apt-get install -y wget
RUN echo 1
COPY init /docker-entrypoint-initdb.d/

ENV MYSQL_ROOT_PASSWORD root_password
ENV MYSQL_DATABASE northwind
ENV MYSQL_USER dev
ENV MYSQL_PASSWORD pwd

EXPOSE 3306