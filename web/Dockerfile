# Build Project
FROM node:14.9-alpine
ARG WORKDIR

WORKDIR /usr/src/app

# Install build dependencies
RUN apk add --no-cache --virtual .build-deps python build-base vim curl git

RUN git clone https://github.com/sparcs-kaist/new-ara-web.git .

# Copy other sources
COPY .env .env

# Install npm packages
RUN npm install

# Delete dependencies
RUN apk del --purge .build-deps

EXPOSE 8080

# TODO: allow to edit like backend
# change alpine to normal
ENTRYPOINT ["npm", "run", "serve"]
