# syntax=docker/dockerfile:1
FROM ubuntu:latest
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
RUN apt-get update \
    && apt-get -y install default-jre \
    maven \
    git
WORKDIR /source
RUN git clone https://github.com/turik207/petProject.git ./
# RUN sed -i 's/10.0.0.12/172.17.0.2/g' src/main/resources/application-mysql.properties
RUN useradd -m appuser
RUN mkdir app
RUN ./mvnw package
RUN cp target/spring-petclinic-2.6.0-SNAPSHOT.jar app/
RUN chown appuser ./app/spring-petclinic-2.6.0-SNAPSHOT.jar
RUN chgrp appuser ./app/spring-petclinic-2.6.0-SNAPSHOT.jar
ENTRYPOINT java -jar ./app/spring-petclinic-2.6.0-SNAPSHOT.jar
EXPOSE 8080
