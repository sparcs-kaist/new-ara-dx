FROM python:3.8

RUN apt-get update && apt-get install netcat-openbsd supervisor gettext git vim curl -y

RUN pip install --upgrade pip virtualenv awscli

WORKDIR /tmp/newara/www
RUN git clone https://github.com/sparcs-kaist/new-ara-api.git .

ENV VIRTUAL_ENV=/tmp/newara/www/venv
RUN virtualenv -p python3 $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Copy other sources
COPY .env .env
COPY firebaseServiceAccountKey.json firebaseServiceAccountKey.json

RUN pip install poetry
RUN poetry config virtualenvs.create false && poetry install
RUN mkdir -p /var/log/tmp/newara/

EXPOSE 9000

RUN echo

ENTRYPOINT ["cp -nr /tmp/newara/www /root/api"]
