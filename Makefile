.PHONY: install clean test lint

USERNAME = $$(whoami)

CA CA.pub users hosts:
	./ssh-ca init

users/$(USERNAME): users CA CA.pub
	./ssh-ca newuser $(USERNAME)

hosts/localhost: hosts CA CA.pub
	./ssh-ca newhost localhost

known_hosts: CA.pub
	echo "@cert-authority * $$(cat CA.pub)" > known_hosts

sshd_config:
	@echo "ListenAddress 127.0.0.1:22222" > sshd_config
	@echo "HostKey $$PWD/hosts/localhost/ssh_host_rsa_key" >> sshd_config
	@echo "HostKey $$PWD/hosts/localhost/ssh_host_dsa_key" >> sshd_config
	@echo "HostKey $$PWD/hosts/localhost/ssh_host_ecdsa_key" >> sshd_config
	@echo "HostKey $$PWD/hosts/localhost/ssh_host_ed25519_key" >> sshd_config
	@echo "HostCertificate $$PWD/hosts/localhost/ssh_host_rsa_key-cert.pub" >> sshd_config
	@echo "HostCertificate $$PWD/hosts/localhost/ssh_host_dsa_key-cert.pub" >> sshd_config
	@echo "HostCertificate $$PWD/hosts/localhost/ssh_host_ecdsa_key-cert.pub" >> sshd_config
	@echo "HostCertificate $$PWD/hosts/localhost/ssh_host_ed25519_key-cert.pub" >> sshd_config
	@echo "PidFile sshd.pid" >> sshd_config
	@echo "UsePrivilegeSeparation no" >> sshd_config
	@echo "MaxAuthTries 20" >> sshd_config
	@echo "TrustedUserCAKeys $$PWD/CA.pub" >> sshd_config

ssh_config:
	@echo "Host test" > ssh_config
	@echo "HostName localhost" >> ssh_config
	@echo "Port 22222"  >> ssh_config
	@echo "IdentityFile users/%u/id_rsa" >> ssh_config
	@echo "IdentityFile users/%u/id_dsa" >> ssh_config
	@echo "IdentityFile users/%u/id_ecdsa" >> ssh_config
	@echo "IdentityFile users/%u/id_ed25519" >> ssh_config
	@echo "UserKnownHostsFile known_hosts" >> ssh_config
	@echo "StrictHostKeyChecking yes" >> ssh_config
	@echo "BatchMode yes" >> ssh_config

install:
	cp ssl-ca /usr/local/bin/ssh-ca
	chmod 755 /usr/local/bin/ssh-ca

clean:
	if [ -f sshd.pid ] && [ -d "/proc/$$(cat sshd.pid)" ]; then kill "$$(cat sshd.pid)"; fi
	rm -rf CA CA.pub users hosts known_hosts sshd.pid sshd_config ssh_config

lint:
	/bin/sh -en ssh-ca

test: lint clean ssh_config sshd_config CA CA.pub users/$(USERNAME) hosts/localhost known_hosts
	$$(PATH=$$PATH:/usr/local/sbin:/usr/sbin:/sbin which sshd) -f sshd_config
	test "$$(ssh -F ssh_config test whoami)" = "$$USER"
	kill $$(cat sshd.pid)
