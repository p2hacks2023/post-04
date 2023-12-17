FROM golang:alpine
ENV TZ=Asia/Tokyo
RUN mkdir /app
WORKDIR /app
COPY . .
RUN go mod tidy
RUN go build ./server.go
CMD ["./server"]