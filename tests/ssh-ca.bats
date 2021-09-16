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
    {
    echo "ListenAddress 127.0.0.1:22222"
    echo "HostKey $PWD/hosts/localhost/ssh_host_rsa_key"
    echo "HostKey $PWD/hosts/localhost/ssh_host_dsa_key"
    echo "HostKey $PWD/hosts/localhost/ssh_host_ecdsa_key"
    echo "HostKey $PWD/hosts/localhost/ssh_host_ed25519_key"
    echo "HostCertificate $$PWD/hosts/localhost/ssh_host_rsa_key-cert.pub"
    echo "HostCertificate $$PWD/hosts/localhost/ssh_host_dsa_key-cert.pub"
    echo "HostCertificate $$PWD/hosts/localhost/ssh_host_ecdsa_key-cert.pub"
    echo "HostCertificate $$PWD/hosts/localhost/ssh_host_ed25519_key-cert.pub"
    echo "PidFile sshd.pid"
    echo "UsePrivilegeSeparation no"
    echo "MaxAuthTries 20"
    echo "TrustedUserCAKeys $PWD/CA.pub"
    } > sshd_config

    # Generating ssh_config
    {
    echo "Host test"
    echo "HostName localhost"
    echo "Port 22222"
    echo "IdentityFile users/%u/id_rsa"
    echo "IdentityFile users/%u/id_dsa"
    echo "IdentityFile users/%u/id_ecdsa"
    echo "IdentityFile users/%u/id_ed25519"
    echo "UserKnownHostsFile known_hosts"
    echo "StrictHostKeyChecking yes"
    echo "BatchMode yes"
    } > ssh_config

    # Launching test sshd
    $(PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin which sshd) -f sshd_config

    # Testing
    run ssh -F ssh_config test whoami
    [ "$status" -eq 0 ]
    [ "$output" = "$USERNAME" ]

}
