# Build Project
FROM node:14.9
ARG WORKDIR

WORKDIR /usr/src/app

# Install build dependencies
RUN apt-get update && apt-get install python build-essential vim curl git -y

RUN git clone https://github.com/sparcs-kaist/new-ara-web.git .

# Copy other sources
COPY .env .env

# Install npm packages
RUN npm install

RUN git fetch
RUN git checkout -b origin/dev

EXPOSE 8080

# TODO: allow to edit like backend
# change alpine to normal
ENTRYPOINT ["npm", "run", "serve"]
