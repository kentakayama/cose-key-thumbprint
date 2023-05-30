FROM python:latest

RUN apt-get update && apt-get install -y make ruby xxd
RUN pip install cbor2
RUN gem install cbor-diag
COPY . .

CMD make validate
