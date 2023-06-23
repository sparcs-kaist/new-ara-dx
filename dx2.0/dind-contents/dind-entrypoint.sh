#!/bin/bash

docker_is_ready() {
    docker info > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        return 0 # Docker is ready
    else
        return 1 # Docker is not ready
    fi
}

wait_for_docker() {
    exec /usr/local/bin/dockerd-entrypoint.sh &
    while ! docker_is_ready; do
        echo "Docker is not ready yet. Waiting..."
        sleep 1
    done
    echo "Docker is ready!"
}

init_always() {
    # Start the SSH server and provide the custom path for the RSA key
    service ssh start
    sh /root/ara/login.sh
}

# Function to fill in variable into .api.env
fill_variable() {
    variable_name=$1
    new_value=${!variable_name}
    sed -i "s|^$variable_name=.*|$variable_name=$new_value|" /root/ara/api/.env
}

init_once() {
    if [ ! -f /root/.init.lock ]; then
        # make ssh id_rsa key
        ssh-keygen -t rsa -b 4096 -N "" -f /root/.ssh/id_rsa
        cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
   
        # init aws credential
        mkdir /root/.aws

        cat <<- EOF > /root/.aws/credentials
        [default]
            aws_access_key_id = $NEWARA_ECR_ACCESS_KEY
            aws_secret_access_key = $NEWARA_ECR_SECRET_ACCESS
EOF

        # fill variable into .api.env
        fill_variable "SSO_CLIENT_ID"
        fill_variable "SSO_SECRET_KEY"

        # fill web/Dockerfile [Nickname], .web-dev.env
        sed -i "s/REPLACEMENT_NICKNAME/$NICKNAME/g" /root/ara/web/Dockerfile
        sed -i "s/REPLACEMENT_NICKNAME/$NICKNAME/g" /root/ara/web-dev/.env

        # Add docker alias
        echo "alias dc='docker compose'" >> /root/.bashrc
        echo "alias d=docker" >> /root/.bashrc

        # initial image build & run
        cd /root/ara
        sh /root/ara/login.sh
        if [ "$DISABLE_INIT_DC_UP" != "true" ]; then
            docker compose up -d
        fi
        
        # make lock
        touch /root/.init.lock
    else
        echo "Already initialized."
    fi
}


wait_for_docker
init_once
init_always

echo "============ entrypoint script done ============"
sleep infinity