# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs
, lib
, config
, pkgs
, ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./vscode.nix
    ./zsh.nix
    # ./gtk.nix
    ./dconf.nix
    ./autostart.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      inputs.nur.overlay
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
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  fonts.fontconfig.enable = true;

  home = {
    username = "ogge";
    homeDirectory = "/home/ogge";
    sessionPath = [
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
    ];
    packages = with pkgs; [
      nix-index
      eza
      bat
      fd
      bottom
      dconf2nix
      neofetch
      ripgrep
      rsync
      chezmoi
      nixpkgs-fmt
      dracula-theme
      nordic
      whitesur-cursors
    ]
    ++ [
      inputs.nil.packages.${pkgs.system}.default
      inputs.home-manager.packages.${pkgs.system}.default
    ]
    ++ [
      gnomeExtensions.appindicator
      gnomeExtensions.tray-icons-reloaded
      gnomeExtensions.tiling-assistant
      gnome.dconf-editor
    ] ++
    [
      (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "Hack" ]; })
    ];
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.gh.enable = true;
  programs.firefox = {

    enable = true;
    #enableGnomeExtensions = true;
    package = pkgs.firefox.override {
      # See nixpkgs' firefox/wrapper.nix to check which options you can use
      nativeMessagingHosts = [
        pkgs.gnome-browser-connector
      ];
    };
    profiles.ogge = {
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        cookie-autodelete
        darkreader
        link-cleaner
        onepassword-password-manager
        gnome-shell-integration
        reddit-enhancement-suite
        ublock-origin
      ];
    };

  };
  programs.alacritty.enable = true;
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
  };
  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.ssh = {
    ## enable 1password ssh agent
    enable = true;
    matchBlocks = {
      "*" = {
        user = "ogge";
        extraOptions = {
          IdentityAgent = "~/.1password/agent.sock";
        };
      };
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}

