FROM golang:1.15.6-alpine as build_img
RUN apk add --no-cache git
WORKDIR /output/
COPY go.mod .
COPY go.sum .
RUN go mod download
COPY . .
RUN go build -o /output/go-live .

FROM alpine:3.9 
RUN apk add ca-certificates
WORKDIR /app
COPY --from=build_img /output/go-live /app/go-live
EXPOSE 8080
CMD ["/app/go-live"]