{ inputs, pkgs, lib, config, ... }:

{

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = false;
      desktop = null;
      videos = null;
      music = null;
      pictures = null;
      documents = "${config.home.homeDirectory}/documents";
      downloads = "${config.home.homeDirectory}/downloads";

    };
  };

}

