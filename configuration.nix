{ config, pkgs, ... }:

{
  # ============================================
  # Boot
  # ============================================

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ============================================
  # network
  # ============================================

  networking.hostName = "Serverdmitrj";
  networking.networkmanager.enable = true;

  # ============================================
  # Tailscale
  # ============================================

  services.tailscale.enable = true;

  # ============================================
  # Ssh
  # ============================================

  services.openssh.enable = true;

  # ============================================
  # Linger
  # ============================================
  
  users.users.server.linger = true;

  # ============================================
  # TLP
  # ============================================

  services.tlp = {
    enable = true;
    settings = {
      STOP_CHARGE_THRESH_BAT0 = 70;
      START_CHARGE_THRESH_BAT0 = 60;
    };
  };

  services.power-profiles-daemon.enable = false;

  # ============================================
  # Docker 
  # ============================================

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  virtualisation.docker.enable = true;


  # ============================================
  # Locale / Time
  # ============================================

  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_TIME = "ru_RU.UTF-8";

  };

  # ============================================
  # Keyboard
  # ============================================

  services.xserver.xkb = {
    layout = "us,ru";
    options = "grp:caps_toggle,caps:shift_capslock";
  };

  # ============================================
  # User
  # ============================================

  users.users.server = {
    isNormalUser = true;

    extraGroups = [
      "wheel"

      "networkmanager"

      "video"

      "input"

      "docker"
  ];

    shell = pkgs.bash;
  };

  # ============================================
  # Monitor_ignore
  # ============================================

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
  };

  
  # ============================================
  # Firmware
  # ============================================


  hardware.enableRedistributableFirmware = true;

  # ============================================
  # Fonts
  # ============================================

  fonts.fontconfig.enable = true;

  # ============================================
  # Nix
  # ============================================

  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 4d";
  };

  
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 
      22
      8096
      9091
      3000
      4533
      25565
      1443
      8080
    ];
    allowedUDPPorts = [
      25565
    ];
  };


  systemd.services.docker-night-stop = {
    description = "Stop Docker containers for the night";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.docker}/bin/docker stop $(docker ps -q)";
    };
  };

  systemd.timers.docker-night-stop = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "02:00";
      Persistent = true;
    };
  };

  systemd.services.docker-morning-start = {
    description = "Start Docker containers in the morning";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.docker}/bin/docker start $(docker ps -aq)";
    };
  };

  systemd.timers.docker-morning-start = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "13:00";
      Persistent = true;
    };
  };



  # ============================================
  # Appimage_rule
  # ============================================

  nixpkgs.config.allowUnfree = true;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };


  # ============================================
  # NixOS version
  # ============================================

  system.stateVersion = "26.05";
}
