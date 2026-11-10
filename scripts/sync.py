import time
import subprocess
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

WATCH_DIR = "/home/server/anime"
REMOTE = "server@192.168.0.109:~/anime/"

class AnimeHandler(FileSystemEventHandler):
    def on_created(self, event):
        if not event.is_directory:
            filepath = event.src_path
            filename = filepath.split('/')[-1]
            
            time.sleep(600) 
            
            try:
                subprocess.run(["scp", filepath, REMOTE], check=True)
                print(f"Copy ready: {filename}")
            except subprocess.CalledProcessError as e:
                print(f"ERROR: {e}")

if __name__ == "__main__":
    event_handler = AnimeHandler()
    observer = Observer()
    observer.schedule(event_handler, WATCH_DIR, recursive=False)
    observer.start()
    
    print(f"wathing_dir {WATCH_DIR}...")
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()
