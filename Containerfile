ARG BASE=ghcr.io/razorfinos/base:latest

FROM ${BASE}

ARG PLAYBOOK

LABEL containers.bootc=1

WORKDIR /workdir

COPY . .
RUN cp -rf /workdir/files/* /

RUN ansible-playbook /workdir/playbooks/${PLAYBOOK}

RUN rm -rdf /workdir /var/log /var/cache/pacman/pkg/*

RUN bootc container lint
