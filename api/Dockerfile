FROM python:3.8

RUN apt-get update && apt-get install netcat-openbsd supervisor gettext git vim curl default-mysql-client -y

RUN pip install --upgrade pip virtualenv awscli

WORKDIR /tmp/newara/www

#### Poetry commands
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH=/root/.local/bin:$PATH
RUN poetry config virtualenvs.in-project true

RUN git clone https://github.com/sparcs-kaist/new-ara-api.git .
RUN git fetch
RUN git checkout develop

# RUN virtualenv -p python3 /tmp/newara/www/venv

# Copy other sources
COPY ./.env /tmp/newara/.env
COPY firebaseServiceAccountKey.json /tmp/newara/firebaseServiceAccountKey.json
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod u+x /docker-entrypoint.sh

RUN mkdir -p /var/log/tmp/newara/

WORKDIR /root/api
EXPOSE 9000

# ENTRYPOINT bash
ENTRYPOINT ["bash", "-c", "/docker-entrypoint.sh"]

