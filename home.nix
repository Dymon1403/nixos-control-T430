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

  programs.home-manager.enable = true;
}
