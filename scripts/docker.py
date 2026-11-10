#!/usr/bin/env python3
import subprocess

servers = [
    {"name": "T430 (NixOS)", "ip": "192.168.0.228", "user": "server"},
    {"name": "Compaq (NixOS)", "ip": "192.168.0.109", "user": "server"}
]

for server in servers:
    print(f"\n{'='*40}")
    print(f"{server['name']} ({server['ip']})")
    
    command = ["ssh", f"{server['user']}@{server['ip']}", "docker ps"]
    
    result = subprocess.run(command, capture_output=True, text=True)
    
    if result.returncode == 0:
        print(result.stdout)
    else:
        print(f"{result.stderr}")
