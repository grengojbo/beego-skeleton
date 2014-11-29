# BeeGo APP
#
# VERSION               2.0.1

FROM  grengojbo/busyboxplus:git
MAINTAINER Oleg Dolya "oleg.dolya@gmail.com"

# Configuring timezone
# RUN cp /usr/share/zoneinfo/Europe/Kiev /etc/localtime
EXPOSE 8080

ADD bin /app/bin
ADD conf /app/conf
#ADD views /app/views
ADD public /app/public
VOLUME /app/public

ADD dist/run /app/run

#ADD . /go/src/sssua
#WORKDIR /go/src/sssua

#RUN go get
#RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -tags netgo -ldflags '-w' -o /app/run main.go
#CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -a -tags netgo -ldflags '-w' -o run main.go
##RUN bee pack
##RUN tar -C /tmp/app -zxf sssua.tar.gz
##RUN mv /tmp/app/sssua /app/
##RUN rm -Rf /go/src/sssua

ADD swagger /app/swagger

# define work environment
WORKDIR /app
#ENTRYPOINT ["/app/bin/boot"]
CMD ["/app/run"]
