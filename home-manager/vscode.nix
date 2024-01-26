{ inputs, pkgs, lib, ... }:
let
  extensions = inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace;
in
{
  home.file.".config/code-flags.conf".enable = true; ## skip for now
  home.file.".config/code-flags.conf".text = ''
    --enable-features=UseOzonePlatform
    --ozone-platform=wayland
  '';

  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    mutableExtensionsDir = false;
    #package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      arcticicestudio.nord-visual-studio-code
      jnoortheen.nix-ide
      yzhang.markdown-all-in-one
      tamasfe.even-better-toml
      tyriar.sort-lines
      ms-vscode-remote.remote-ssh
      extensions.equinusocio.vsc-material-theme-icons
      vscode-icons-team.vscode-icons
    ];

    userSettings = {
      "editor.formatOnSave" = true;
      "window.zoomLevel" = 0;
      "workbench.colorTheme" = "Nord";
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "editor.minimap.enabled" = false;
      "nix.serverSettings" = {
        "nil" = {
          "diagnostics" = {
            "ignored" = [ "unused_binding" "unused_with" ];
          };
          "formatting" = {
            "command" = [ "nixpkgs-fmt" ];
          };
        };
      };
      "editor.fontSize" = 15;
      "editor.fontFamily" = "Hack Nerd Font Mono";
      "git.enableSmartCommit" = true;
      "git.confirmSync" = false;
      "window.titleBarStyle" = "custom";
      "workbench.tree.indent" = 22;

      "workbench.iconTheme" = "vscode-icons";
      #"workbench.iconTheme" = "eq-material-theme-icons-ocean"; ## darker folders
      "terminal.integrated.copyOnSelection" = true;
      "terminal.integrated.fontSize" = 12;
      "terminal.integrated.fontFamily" = "Hack Nerd Font Mono";
    };


    globalSnippets = {
      nix = {
        body = [
          ''
            { ... }:
            {
              $0
            }
          ''
        ];
        description = "Empty nix body for import (non-flake)";
        prefix = [
          "Empty nix"
        ];
      };
    };


  };

}


