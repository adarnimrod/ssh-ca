.PHONY: install clean test

install:
	cp ssl-ca /usr/local/bin/ssh-ca
	chmod 755 /usr/local/bin/ssh-ca

clean:
	rm -rf CA CA.pub users hosts

test: clean
	./ssh-ca init
	./ssh-ca newuser $$USER
	./ssh-ca newhost localhost
	$$(which sshd) -dddf sshd_config
