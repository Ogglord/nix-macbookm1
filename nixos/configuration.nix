# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ inputs
, outputs
, lib
, config
, pkgs
, ...
}:
let
  #Note! Change this to your username
  username = "ogge";
in
{
  # You can import other NixOS modules here
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # Apple Silicon Support
    #./apple-silicon-support
    #inputs.apple-silicon-support.nixosModules.aarch64-linux.apple-silicon-support
    inputs.apple-silicon-support.nixosModules.apple-silicon-support
    inputs.home-manager.nixosModules.home-manager
  ];

  hardware.asahi.peripheralFirmwareDirectory = ./firmware;

  #hardware.asahi.pkgsSystem = "x86_64-linux";

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      (final: prev: {
        gnome = prev.gnome.overrideScope' (gnomeFinal: gnomePrev: {
          mutter = gnomePrev.mutter.overrideAttrs (old: {
            src = pkgs.fetchgit {
              url = "https://gitlab.gnome.org/vanvugt/mutter.git";
              # GNOME 45: triple-buffering-v4-45
              rev = "0b896518b2028d9c4d6ea44806d093fd33793689";
              sha256 = "sha256-mzNy5GPlB2qkI2KEAErJQzO//uo8yO0kPQUwvGDwR4w=";
            };
          });
        });
      })

      # custom dwm points to local git repo
      (final: prev: {
        dwm = prev.dwm.overrideAttrs (old: { src = /home/${username}/repos/dwm-ogglord; });
      })

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: { inherit flake; })) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = [ "/etc/nix/path" ];
  environment.etc =
    lib.mapAttrs'
      (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  networking.hostName = "m1nixos";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  users.users = {
    ${username} = {
      isNormalUser = true;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHBm+WLnkUfa5whfKM3OToFMPumRpLZve11/8wdwQnET"
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = [ "wheel" ];
    };
  };

  ## Update home manager together with nixos-rebuild. Simple. What I want :)     
  home-manager = {
    #pkgs = pkgs.legacyPackages.aarch64-linux;
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      # Import your home-manager configuration
      ${username} = import ../home-manager/home.nix;
    };
  };

  ## iwd is best for mac
  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Swedish keyboard
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "sv-latin1";
  };

  # Enable the X11 windowing system with Swe keyboard
  services.xserver = {
    xkb.layout = "se";
    xkb.options = "eurosign:e";
  };

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    #gedit # text editor
    epiphany # web browser
    geary # email reader
    gnome-characters
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
    yelp # Help view
    gnome-contacts
    gnome-initial-setup
  ]);

  ###############################
  ## system-wide programs
  ###############################
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks

  ];
  services.gnome.gnome-browser-connector.enable = true;

  programs.zsh.enable = true;
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ "${username}" ];
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Forbid root login through SSH.
      PermitRootLogin = "no";
      # Use keys only. Remove if you want to SSH using password (not recommended)
      PasswordAuthentication = true;
    };
  };

  security.sudo =
    let
      allowedCommands = [
        "/run/current-system/sw/bin/nixos-rebuild"
        "/run/current-system/sw/bin/nix-collect-garbage"
        "/run/current-system/sw/bin/reboot"
        "/run/current-system/sw/bin/tailscale"
        "${pkgs.systemd}/bin/reboot"
        "${pkgs.systemd}/bin/poweroff"
        "${pkgs.systemd}/bin/systemctl suspend"
      ];
    in
    {
      enable = true;
      wheelNeedsPassword = true; # Whether users of the `wheel` group must provide a password to run commands
      execWheelOnly = true; #Only allow members of the `wheel` group to execute sudo
      ## do not require password for these, I am lazy
      extraRules = with lib;[
        {
          users = [ "${username}" ];
          commands = map (bin: { command = bin; options = [ "NOPASSWD" ]; }) allowedCommands;
        }
      ];
      ## longer timeout please, 2 hours
      extraConfig = ''
        Defaults        timestamp_timeout=120
      '';
    };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
