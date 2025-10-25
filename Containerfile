ARG BASE=ghcr.io/razorfinos-org/base:latest

FROM ${BASE}

ARG PLAYBOOK

LABEL containers.bootc=1

WORKDIR /workdir

COPY . .
RUN cp -rf /workdir/files/* /

RUN ansible-playbook /workdir/playbooks/${PLAYBOOK} && \
    rm -rf /var/cache/pacman/pkg/* && \
    rm -rf /workdir /var/log

RUN bootc container lint
