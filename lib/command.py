import subprocess

class Command(object):
    def __init__(self, cmd = []):
        out = subprocess.Popen(cmd,
                         stdout = subprocess.PIPE,
                         stderr = subprocess.PIPE)
        self.stdout = out.stdout
        self.stderr = out.stderr
    
    def pipe(self, cmd = []):
        out = subprocess.Popen(cmd,
                         stdin = self.stdout,
                         stdout = subprocess.PIPE,
                         stderr = subprocess.PIPE)
        self.stdout = out.stdout
        self.stderr = out.stderr

