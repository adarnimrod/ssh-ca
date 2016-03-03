.PHONY: install clean test lint


sshd_config:
	@echo "ListenAddress 127.0.0.1:22222" > sshd_config
	@echo "HostKey $$PWD/hosts/localhost" >> sshd_config
	@echo "TrustedUserCAKeys $$PWD/CA.pub" >> sshd_config
	@echo "HostCertificate $$PWD/hosts/localhost-cert.pub" >> sshd_config
	@echo "PidFile sshd.pid" >> sshd_config
	@echo "UsePrivilegeSeparation no" >> sshd_config

install:
	cp ssl-ca /usr/local/bin/ssh-ca
	chmod 755 /usr/local/bin/ssh-ca

clean:
	if [ -f sshd.pid ] && [ -d "/proc/$$(cat sshd.pid)" ]; then kill "$$(cat sshd.pid)"; fi
	rm -rf CA CA.pub users hosts known_hosts sshd.pid sshd_config

lint:
	/bin/sh -en ssh-ca

test: clean sshd_config lint
	./ssh-ca init
	./ssh-ca newuser $$USER
	./ssh-ca newhost localhost
	echo "@cert-authority * $$(cat CA.pub)" > known_hosts
	$$(PATH=$$PATH:/usr/local/sbin:/usr/sbin:/sbin which sshd) -f sshd_config
	test "$$(ssh -F ssh_config test whoami)" = "$$USER"
	kill $$(cat sshd.pid)
