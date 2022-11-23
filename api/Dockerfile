FROM python:3.8

RUN apt-get update && apt-get install netcat-openbsd supervisor gettext git vim curl default-mysql-client -y

RUN pip install --upgrade pip virtualenv awscli

WORKDIR /tmp/newara/www
RUN git clone https://github.com/sparcs-kaist/new-ara-api.git .
RUN git fetch
RUN git checkout develop

# RUN virtualenv -p python3 /tmp/newara/www/venv

# Copy other sources
COPY ./.env .env
COPY firebaseServiceAccountKey.json firebaseServiceAccountKey.json

#### Poetry commands
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH=/root/.local/bin:$PATH
####
RUN poetry config virtualenvs.in-project true

# RUN poetry config cache-dir /root/api/cache-dir
RUN mkdir -p /var/log/tmp/newara/

WORKDIR /root
ENV VIRTUAL_ENV=/root/api/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
EXPOSE 9000
ENTRYPOINT ["bash", "-c", " echo ====File move start====; mv -n /tmp/newara/www/* /tmp/newara/www/.* /root/api; echo ====File move done====; sleep infinity;"]
# ENTRYPOINT bash
