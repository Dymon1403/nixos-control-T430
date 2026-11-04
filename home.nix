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

  programs.home-manager.enable = true;
}
