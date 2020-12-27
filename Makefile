.PHONY: clean
clean:
	- kill $$(cat sshd.pid)
	git clean -fdx

.PHONY: install
install:
	install -m 755 ssl-ca /usr/local/bin/ssh-ca
