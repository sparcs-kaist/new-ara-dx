FROM python:3.8

RUN apt-get update && apt-get install netcat-openbsd supervisor gettext git vim curl default-mysql-client -y

RUN pip install --upgrade pip virtualenv awscli

WORKDIR /tmp/newara/www
RUN git clone https://github.com/sparcs-kaist/new-ara-api.git .

ENV VIRTUAL_ENV=/tmp/newara/www/venv
RUN virtualenv -p python3 $VIRTUAL_ENV
ENV PATH_TMP=$PATH
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Copy other sources
COPY ./.env .env
COPY firebaseServiceAccountKey.json firebaseServiceAccountKey.json

RUN pip install poetry
RUN poetry config virtualenvs.create false
RUN mkdir -p /var/log/tmp/newara/

EXPOSE 9000

WORKDIR /root

ENV VIRTUAL_ENV=/root/api/venv
ENV PATH=$PATH_TMP
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENTRYPOINT ["bash", "-c", " echo ====File move start====; mv -n /tmp/newara/www/* /tmp/newara/www/.* /root/api; echo ====File move done====; sleep infinity;"]
# ENTRYPOINT bash
