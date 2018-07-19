"""
# Implemented by minipunch for USA REALISM RP

# Description:
# Keep a process up and running.
# If you have a long running process that can be killed for strange and unknown
reason, you might want it to be restarted ... this script does that.

# To start a FiveM server with it do:

keepalive.py ..\run.cmd +exec server.cfg

from the server-data directory.
"""

#!/usr/bin/env python

import sys
import time
import subprocess

MAX_SERVER_UP_TIME = 1440 # in minutes (1440 = 24 hours)
startTime = 0
currentTime = 0

cmd = ' '.join(sys.argv[1:])

def start_subprocess():
	return subprocess.Popen(cmd)

p = start_subprocess()
startTime = (time.time()) / 60.0 # in minutes since epoch

while True:
    
	res = p.poll()
	if res is not None:
		print(p.pid, 'killed... restarting...')
		time.sleep(10)
		p = start_subprocess()
		startTime = (time.time()) / 60.0 # in minutes since epoch
	else:
		# not killed, check uptime
		currentTime = (time.time()) / 60.0 # in minutes since epoch
		if (currentTime - startTime >= MAX_SERVER_UP_TIME): # MAX_SERVER_UP_TIME minute(s)  has passed
			print("*******MAX_SERVER_UP_TIME minute(s) has passed! restarting the server!!!!!!!*******")
			print("*******MAX_SERVER_UP_TIME minute(s) has passed! restarting the server!!!!!!!*******")
			print("*******MAX_SERVER_UP_TIME minute(s) has passed! restarting the server!!!!!!!*******")
			# This kills the entire process tree (includes cmd.exe and FXServer.exe)
			py_kill = subprocess.Popen("TASKKILL /PID "+ str(p.pid) + " /f /t")
			py_kill2 = subprocess.Popen("TASKKILL /im erl.exe /f /t")
			# TODO: add taskkill for erl.exe (since it takes up all the memory for some reason sometimes)

	time.sleep(1)