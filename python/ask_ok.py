#!/usr/local/bin/python3.5

def ask_ok(prompt, retries=3, complaint="Only Yes or No, please !"):
	while True:
		ok=input(prompt)
		if ok in ('y','yes','Y',"YES"):
			return True
		if ok in ('n','no','N','NO','nope'):
			return False
		retries = retries-1
		if retries<0:
			raise IOError('Please try again later !')
		print (complaint)

#ask_ok("Do you really want to quit ?")
#ask_ok("Do you really want to quit ?",2)
ask_ok("Do you really want to quit ?",2,"Come on ! Only Yes or No !")
