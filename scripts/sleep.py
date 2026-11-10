#!/usr/bin/env python3
import subprocess

servers = [
    {"name": "T430", "ip": "192.168.0.228", "user": "server"},
    {"name": "Compaq", "ip": "192.168.0.109", "user": "server"}
]

for server in servers:
    print(f"stoped container on: {server['name']} ({server['ip']})...")
    command = ["ssh", f"{server['user']}@{server['ip']}", "docker stop $(docker ps -q) 2>/dev/null || true"]
    result = subprocess.run(command, capture_output=True, text=True)
    
    if result.returncode == 0:
        print(f" {server['name']}: stoped.")
    else:
        print(f" {server['name']}: error: {result.stderr}")
