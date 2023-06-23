#! /bin/bash
if [ -z "$1" ]; then
  echo "Error: please enter nickname."
  exit 1
fi

docker compose exec dind-$1 cat /root/.ssh/id_rsa
echo "SSH and DB ports"
docker ps --format "table {{.Names}}\t{{.Ports}}" | grep $1


echo ""
echo "####################YOU MUST DO BELOW TASK#####################"
echo "1. Copy the above key and paste to .ssh/newaradx in your PC"
echo "2. Run 'chmod 400 newaradx' in your PC"
echo "3. Check connection using 'ssh root@bap.sparcs.org -p <ssh port> -i newaradx' in your PC"