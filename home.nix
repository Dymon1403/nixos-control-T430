{ config, pkgs, ... }:

{
  home.username = "server";
  home.homeDirectory = "/home/server";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    
    fastfetch
    
    htop
    
    openssh

    pingu

    curl
    git
    
    wget
    
    gcc
    gnumake
    
    btop
    
    unzip
    
    neovim

    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code

      (pkgs.python3.withPackages (ps: with ps; [
	watchdog
      ]))

  ];

    programs.git = {
      enable = true;
      settings = {
      user = {
	name = "Dymon1403";
	email = "dymaroxer1403@gmail.com"; 
      };
      url."git@github.com:".insteadOf = "https://github.com/";
      init.defaultBranch = "main";
    };
  };


   programs.bash = {
    enable = true;

    shellAliases = {

      ls = "ls --color=auto";
      grep = "grep --color=auto";
      ff = "fastfetch";
      ss = "sudo nixos-rebuild switch --flake .#server";
    };

    initExtra = ''
    export EDITOR="nvim";
    export TERMINAL="alacritty"
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };




  home.file.".local/bin/anime-sync.py".source = ./scripts/sync.py;
  home.file.".local/bin/anime-sync.py".executable = true;

  systemd.user.services.anime-sync = {
    Unit = {
      Description = "Sync anime from T430 to Compaq";
      After = [ "network.target" ];
    };
    Service = {
      ExecStart = "${pkgs.python3.withPackages (ps: [ ps.watchdog ])}/bin/python3 %h/.local/bin/anime-sync.py";
      Restart = "on-failure";
      RestartSec = 10;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };






  programs.home-manager.enable = true;
}
