#!/usr/bin/env python3
import requests
import subprocess
import sys
import time
from pathlib import Path

def set_wallpaper(url):
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    }
    
    print(f"Скачиваю: {url}...")
    try:
        response = requests.get(url, headers=headers, timeout=30, stream=True)
        response.raise_for_status()
    except Exception as e:
        print(f"Ошибка скачивания: {e}")
        return

    wallpaper_dir = Path.home() / "Pictures" / "wallpapers"
    wallpaper_dir.mkdir(parents=True, exist_ok=True)
    
    ext = url.split('.')[-1].split('?')[0]
    if len(ext) > 4: 
        ext = "jpg"
    
    filepath = wallpaper_dir / f"current_wall.{ext}"
    
    with open(filepath, 'wb') as f:
        for chunk in response.iter_content(chunk_size=8192):
            f.write(chunk)
    
    print(f"Сохранено: {filepath}")

    print("Обновляю палитру (wal)...")
    try:
        subprocess.run(["wal", "-i", str(filepath)], check=True)
        print("Палитра обновлена.")
    except Exception as e:
        print(f"Ошибка pywal: {e}")

    print("Перезапускаю Waybar...")
    subprocess.run(["pkill", "waybar"])
    time.sleep(0.5)
    subprocess.Popen(["waybar"])
    
    print("Ставлю обои...")
    try:
        subprocess.run(["awww", "img", str(filepath)], check=True)
    except Exception as e2:
        print(f"Ошибка установки обоев (swww): {e2}")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Использование: python wallpaper.py <URL_картинки>")
        sys.exit(1)
    
    set_wallpaper(sys.argv[1])
