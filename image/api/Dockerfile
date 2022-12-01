FROM python:3.8

RUN apt-get update && apt-get install netcat-openbsd supervisor gettext git vim curl default-mysql-client htop nano openssh-server zsh -y

RUN pip install --upgrade pip virtualenv awscli

WORKDIR /tmp/newara/www

#### Poetry commands
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH=/root/.local/bin:$PATH
RUN poetry config virtualenvs.in-project true

RUN curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
RUN chsh -s `which zsh`

RUN mkdir -p /var/log/tmp/newara/

# Copy all in /root
RUN cp -a /root .

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod u+x /docker-entrypoint.sh

WORKDIR /root/api
EXPOSE 9000
# ENTRYPOINT bash
ENTRYPOINT ["bash", "-c", "/docker-entrypoint.sh"]

