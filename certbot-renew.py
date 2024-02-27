#!/usr/bin/python3

import os
import signal
import platform
import subprocess
from pathlib import Path

RENEW_DNS = ""
EMAIL = ""
AWS_ACCESS_KEY_ID = ""
AWS_SECRET_ACCESS_KEY = ""
AWS_SESSION_TOKEN = ""
SUDO = ""

_SUPPORTED_PLATFORMS = ["linux"]
_PROCESS: subprocess.Popen = None
_ENV_PATH = Path(".certbot.env")

try:
    import boto3
    BOTO3 = True
except ImportError:
    BOTO3 = False

def _command(command: str) -> str:
    return SUDO+command

def _get_env() -> None:
    global AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_SESSION_TOKEN, RENEW_DNS, EMAIL
    required_envs = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY", "AWS_SESSION_TOKEN", "RENEW_DNS", "EMAIL"]
    missing_envs = []

    if _ENV_PATH.exists():
        environ_raw = _ENV_PATH.read_text().split("\n")
        for line in environ_raw:
            if line and not line.startswith("#"):
                line = line.split("=")
                if line[1].startswith("\""): line[1] = line[1][1:]
                if line[1].endswith("\""): line[1] = line[1][:-1]
                globals()[line[0]] = "=".join(line[1:])
    
    for env in required_envs:
        if not globals()[env]:
            globals()[env] = os.environ.get(env, "")
            if not globals()[env]:
                missing_envs.append(env)

    if missing_envs:
        raise EnvironmentError(f"Missing environment variables: {missing_envs}")
    

def _check_platform() -> None:
    if platform.system().lower() not in _SUPPORTED_PLATFORMS:
        raise OSError(f"Unsupported platform: {platform.system()}")

def _check_admin_privileges() -> None:
    global SUDO

    if os.geteuid() == 0:
        return
    elif os.system("sudo -n true") == 0:
        SUDO = "sudo "
        return
    else:
        raise PermissionError("You need to have admin privileges to run this script")

def has_certbot():
    return not os.system("command -v certbot > /dev/null")

def install_boto3() -> None:
    command = _command("su - -c 'python3 -m pip install boto3'")
    os.system(command)
    print("Please restart this script.")
    exit(2)

def update_route53(acme_domain:str, value: str) -> None:
    client = boto3.client("route53", aws_access_key_id=AWS_ACCESS_KEY_ID, aws_secret_access_key=AWS_SECRET_ACCESS_KEY, aws_session_token=AWS_SESSION_TOKEN)
    
    level2_dns = ".".join(RENEW_DNS.split(".")[-2:])
    zones = client.list_hosted_zones_by_name(DNSName=level2_dns)["HostedZones"][0]
    if zones["Name"] != f"{level2_dns}.":
        raise ValueError(f"Zone not found: {level2_dns}")
    
    hostedzone = zones["Id"].split("/")[-1]
    changes = {"Changes": []}

    if not acme_domain.endswith("."):
        acme_domain = f"{acme_domain}."
    
    changes["Changes"].append({
        "Action": "UPSERT",
        "ResourceRecordSet": {
            "Name": acme_domain,
            "Type": "TXT",
            "TTL": 300,
            "ResourceRecords": [{"Value": f'"{value}"'}]
        }
    })

    response = client.change_resource_record_sets(HostedZoneId=hostedzone, ChangeBatch=changes)
    if response["ResponseMetadata"]["HTTPStatusCode"] != 200:
        raise ConnectionError(f"Failed to update DNS: {response}")

def renew_cert() -> int:
    global _PROCESS, RENEW_DNS, EMAIL
    command = _command(f"certbot certonly --manual --preferred-challenges dns --email {EMAIL} --agree-tos -d {RENEW_DNS}")
    _PROCESS = subprocess.Popen(command, shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    outputs = ""
    while "Before continuing" not in outputs:
        output = _PROCESS.stdout.readline().decode("utf-8")
        if output:
            outputs += output
    
    acme_domain = outputs.split("Please deploy a DNS TXT record under the name:")[1].split("with the following value:")[0].strip()
    acme_value = outputs.split("with the following value:")[1].split("Before continuing, verify")[0].strip()
    print(f"acme_domain: {acme_domain}")
    print(f"acme_value: {acme_value}")
    print()
    print("Does value show clearly? (y/n)")
    yn = input("> ")
    if yn.lower() == "y":
        update_route53(acme_domain, acme_value)
    else:
        print("Please re-run this script.")
        _PROCESS.send_signal(signal.SIGINT)
        _PROCESS.wait()
        exit(3)

    _PROCESS.communicate(input="\n".encode("utf-8"))
    return _PROCESS.wait()

def reload_nginx() -> int:
    command = _command("systemctl reload nginx")
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    return process.wait()

if __name__ == "__main__":
    _check_platform()
    _check_admin_privileges()
    if not BOTO3: install_boto3()
    _get_env()
    try:
        if renew_cert():
            print("Failed to renew certificate.")
            
            output = _PROCESS.stdout.readline().decode("utf-8")
            while output:
                print(output)
                output = _PROCESS.stdout.readline().decode("utf-8")
            
            output = _PROCESS.stderr.readline().decode("utf-8")
            while output:
                print(output)
                output = _PROCESS.stderr.readline().decode("utf-8")
            
            exit(4)
        else:
            print("Certificate renewed successfully.")
            yn = input("Do you want to reload nginx? (y/n) ")
            if yn.lower() == "y":
                if reload_nginx():
                    print("Failed to reload nginx.")
                    output = _PROCESS.stdout.readline().decode("utf-8")
                    while output:
                        print(output)
                        output = _PROCESS.stdout.readline().decode("utf-8")
                    exit(5)
                else:
                    print("Nginx reloaded successfully.")

    except KeyboardInterrupt:
        if isinstance(_PROCESS, subprocess.Popen):
            _PROCESS.send_signal(signal.SIGINT)
            _PROCESS.wait()
        exit(1)
