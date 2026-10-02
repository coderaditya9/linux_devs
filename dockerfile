FROM ubuntu:24.04

WORKDIR /app

COPY test.sh .

RUN chmod +x test.sh

CMD ["./test.sh"]
