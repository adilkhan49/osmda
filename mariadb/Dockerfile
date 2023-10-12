# Use an official Ubuntu base image
FROM ubuntu:latest
RUN apt-get update && apt-get install -y wget
RUN echo 1

FROM mariadb:latest

COPY entrypoint.sh /docker-entrypoint-initdb.d/
ENV MYSQL_ROOT_PASSWORD root_password
ENV MYSQL_DATABASE northwind
ENV MYSQL_USER dev
ENV MYSQL_PASSWORD pwd

EXPOSE 3306