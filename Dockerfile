FROM alpine:latest as alpine

COPY . /go
RUN apk --update add ca-certificates
RUN apk --update add mailcap git go musl-dev gcc npm nodejs
RUN cd /go && PATH="/root/go/bin/:${PATH}" ./wizard.sh -b

FROM scratch
COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=alpine /etc/mime.types /etc/mime.types
COPY --from=alpine /go/filebrowser /filebrowser

VOLUME /srv
EXPOSE 80

COPY .docker.json /.filebrowser.json

ENTRYPOINT [ "/filebrowser" ]
