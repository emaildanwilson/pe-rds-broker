# build stage
FROM golang AS build-env

WORKDIR /go/src/github.com/cloudfoundry-community/pe-rds-broker
ADD . .
RUN go get . && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix nocgo -o /rds-broker

# final stage
FROM centurylink/ca-certs
ADD config-sample.json /config.json
COPY --from=build-env /rds-broker /
ENTRYPOINT ["/rds-broker"]
CMD ["--config=/config.json"]
EXPOSE 3000
