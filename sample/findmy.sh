docker compose exec newara-api cat /root/.ssh/id_rsa
docker compose ps -a | awk -v RS="" '{match($0, /.*\n.*:([0-9]*).*\n.*:([0-9]*).*/, m); print "SSH Port: " m[1] "\nDB Port: " m[2]}'

echo ""
echo "####################YOU MUST DO BELOW TASK#####################"
echo "1. Copy the above key and paste to .ssh/newaradx in your PC"
echo "2. Run 'chmod 400 newaradx' in your PC"
echo "3. Check connection using 'ssh root@myeonglan.sparcs.org -p <ssh port> -i newaradx' in your PC"
echo "You can check ssh and mysql port from above result or 'docker compose ps -a'"
