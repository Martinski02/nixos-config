{ ... }:

let
  commonIdentity = {
    IdentityFile = "~/.ssh/id_ed25519";
    IdentitiesOnly = true;
    AddKeysToAgent = "yes";
  };

  martinHost = commonIdentity // {
    User = "martin";
  };
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        ForwardAgent = false;
        AddKeysToAgent = "no";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };

      "github.com" = commonIdentity // {
        HostName = "github.com";
        User = "git";
      };

      "martin-server" = martinHost // {
        HostName = "martin-server";
      };

      "martin-pc" = martinHost // {
        HostName = "martin-pc";
      };

      "martin-laptop" = martinHost // {
        HostName = "martin-laptop";
      };
    };
  };
}
