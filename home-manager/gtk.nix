{ inputs, pkgs, lib, ... }:

{

  gtk = {
    enable = true;
    theme = {
      package = pkgs.dracula-theme;
      name = "Dracula";
    };
  };

}

