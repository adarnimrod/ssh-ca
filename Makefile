.PHONY: install clean test

install:
	cp ssl-ca /usr/local/bin/ssh-ca
	chmod 755 /usr/local/bin/ssh-ca

clean:
	rm -rf CA CA.pub

test: clean
	echo Not implemented.
