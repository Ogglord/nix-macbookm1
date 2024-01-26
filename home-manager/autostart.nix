{ inputs, pkgs, lib, config, ... }:
with lib;
{

  ## ${config.xdg.configHome}/autostart
  home.file.".config/autostart/1password.desktop".text = ''
    [Desktop Entry]
    Name=1Password
    Exec=1password %U
    Terminal=false
    Type=Application
    Icon=1password
    StartupWMClass=1Password
    Comment=Password manager and secure wallet
    MimeType=x-scheme-handler/onepassword;
    Categories=Office;
    # The path to the folder in which the executable is run
  '';

}

