setup () {
    teardown
}

teardown () {
    { [ -f sshd.pid ] && kill "$(cat sshd.pid)"; } || true
    git clean -fdX
}

@test "full test" {
    USERNAME="$(whoami)"
    ./ssh-ca init
    ./ssh-ca newuser "$USERNAME"
    ./ssh-ca newhost localhost
    echo "@cert-authority * $(cat CA.pub)" > known_hosts

    # Generating sshd_config
    echo "ListenAddress 127.0.0.1:22222" > sshd_config
    echo "HostKey $PWD/hosts/localhost/ssh_host_rsa_key" >> sshd_config
    echo "HostKey $PWD/hosts/localhost/ssh_host_dsa_key" >> sshd_config
    echo "HostKey $PWD/hosts/localhost/ssh_host_ecdsa_key" >> sshd_config
    echo "HostKey $PWD/hosts/localhost/ssh_host_ed25519_key" >> sshd_config
    echo "HostCertificate $$PWD/hosts/localhost/ssh_host_rsa_key-cert.pub" >> sshd_config
    echo "HostCertificate $$PWD/hosts/localhost/ssh_host_dsa_key-cert.pub" >> sshd_config
    echo "HostCertificate $$PWD/hosts/localhost/ssh_host_ecdsa_key-cert.pub" >> sshd_config
    echo "HostCertificate $$PWD/hosts/localhost/ssh_host_ed25519_key-cert.pub" >> sshd_config
    echo "PidFile sshd.pid" >> sshd_config
    echo "UsePrivilegeSeparation no" >> sshd_config
    echo "MaxAuthTries 20" >> sshd_config
    echo "TrustedUserCAKeys $PWD/CA.pub" >> sshd_config

    # Generating ssh_config
    echo "Host test" > ssh_config
    echo "HostName localhost" >> ssh_config
    echo "Port 22222"  >> ssh_config
    echo "IdentityFile users/%u/id_rsa" >> ssh_config
    echo "IdentityFile users/%u/id_dsa" >> ssh_config
    echo "IdentityFile users/%u/id_ecdsa" >> ssh_config
    echo "IdentityFile users/%u/id_ed25519" >> ssh_config
    echo "UserKnownHostsFile known_hosts" >> ssh_config
    echo "StrictHostKeyChecking yes" >> ssh_config
    echo "BatchMode yes" >> ssh_config

    # Launching test sshd
    $(PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin which sshd) -f sshd_config

    # Testing
    run ssh -F ssh_config test whoami
    [ "$status" -eq 0 ]
    [ "$output" = "$USERNAME" ]

}
