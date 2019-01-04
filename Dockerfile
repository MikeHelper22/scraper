FROM alpine:latest

RUN apk add --no-cache curl bash

WORKDIR /app
ADD ./scrape.sh ./districts.map ./districts.conf ./run.sh /app/
CMD ["/app/run.sh"]
