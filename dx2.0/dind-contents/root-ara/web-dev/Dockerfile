# Build Project
FROM node:14
ARG WORKDIR

WORKDIR /usr/src/app

# Install build dependencies
RUN apt-get update && apt-get install python build-essential vim curl git htop nano zsh -y
RUN curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
RUN chsh -s `which zsh`


RUN git clone https://github.com/sparcs-kaist/new-ara-web.git .

RUN ln -s /usr/src/app /root/web
WORKDIR /root/web

# Install npm packages
RUN npm install

EXPOSE 8080
RUN apt-get install dumb-init -y
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["sleep", "infinity"]
