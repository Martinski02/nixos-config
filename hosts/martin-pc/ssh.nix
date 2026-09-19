{ ... }:

{
  users.users.martin.openssh.authorizedKeys.keys = [
    # martin-laptop
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBuliE+0C4H7r/J/ND6pMFdRyXOZjbfHiWjTHXByvsTo martin-laptop"

    # martin-server
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGybPGy3NZfC14Dek8N7kj/RXB4x4tbroKh6Mq4rnbMt martin-server"
  ];
}
