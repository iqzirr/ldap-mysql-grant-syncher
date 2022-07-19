FROM alpine:latest
LABEL maintainer="Rizqi Firmansyah"
LABEL version="0.1"

RUN apk update 
RUN apk upgrade
RUN apk add openldap-clients mariadb-client 
RUN apk add --no-cache bash

COPY ldap-sql-sync.sh .

ENV MYSQL_USER="test"
ENV MYSQL_PASS="test"
ENV MYSQL_HOST="test"
ENV MYSQL_PORT="test"
ENV LDAP_USER="test"
ENV LDAP_HOST="test"
ENV LDAP_PASS="test"
ENV LDAP_PORT="test"

ENTRYPOINT ["bash","ldap-sql-sync.sh"]
