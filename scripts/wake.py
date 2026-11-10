#!/usr/bin/env python3
import subprocess

servers = [
    {"name": "server", "ip": "192.168.0.228", "user": "server", "path": "~/server"}, 
    {"name": "server", "ip": "192.168.0.109", "user": "server", "path": "~/server"}
]

for server in servers:
    print(f"Waking up {server['name']} ({server['ip']})...")
    
    ssh_cmd = f"ssh {server['user']}@{server['ip']} 'docker compose up -d'"
    
    result = subprocess.run(ssh_cmd, shell=True, capture_output=True, text=True)
    
    if result.returncode == 0:
        print(f"[{server['name']}]: Successfully started!")
        print(result.stdout)
    else:
        print(f"[{server['name']}]: error: {result.stderr}")
