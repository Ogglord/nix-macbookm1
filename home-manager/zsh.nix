{ inputs, pkgs, lib, ... }:

{
  programs.zsh = {

    envExtra = ''
      function _source {
        for filepath in "$@"; do
          if [[ -f "$filepath" ]]; then
            source "$filepath"
          else
            echo "File '$filepath' does not exist."
          fi
         
        done
      }
      
      function _rebuild_nix_flake_dir {
        directory="''${1:-.}"
        if [[ -d "$directory" ]]; then

           # Remove trailing slash from directory if present
          if [[ "$directory" == */ ]]; then
            directory="''${directory%?}"
          fi
          flakepath="$directory/flake.nix"
          if [[ -f "$flakepath" ]]; then
            pushd $directory > /dev/null
            echo "Rebuilding nix-os using flake.nix in $directory"
            sudo nixos-rebuild switch --flake .#
            popd > /dev/null
          else
            echo "Flake '$flakepath' does not exist."
          fi

         
        else
          echo "Directory '$directory' does not exist."
        fi
      }


      
    '';


    shellAliases = {
      rebuild = ''_rebuild_nix_flake_dir "''${HOME}/nix"'';
      z = ''(source $ZDOTDIR/.zshrc ; echo "Reloading zsh config"...)'';
      exa = "eza --group-directories-first --color-scale -g";
      ls = "eza -l";
      ll = "eza -alh";
      l = "eza -lh";
      lt = "eza -laTh";
      la = "eza -al";
      cat = "bat";
      g = "git";
      ga = "git add";
      gaa = "git add --all";

      gbs = "git bisect";
      gbss = "git bisect start";
      gbsb = "git bisect bad";
      gbsg = "git bisect good";
      gbsr = "git bisect run";
      gbsre = "git bisect reset";

      gc = "git commit -v";
      "gc!" = "git commit -v --amend";
      "gcan!" = "git commit -v -a --no-edit --amend";
      gcb = "git checkout -b";

      gcm = "git checkout master";
      gcmsg = "git commit -m";
      gcp = "git cherry-pick";

      gd = "git diff";
      gdc = "git diff --cached";
      gdw = "git diff --word-diff";
      gdcw = "git diff --cached --word-diff";

      gf = "git fetch";
      gl = "git pull";
      glg = "git log --stat";
      glgp = "git log --stat -p";
      gp = "git push";
      gpsup = "git push -u origin $(git symbolic-ref --short HEAD)";
      gr = "git remote -v";
      grb = "git rebase";
      grbi = "git rebase -i";
      grhh = "git reset --hard HEAD";
      gst = "git status";
      gsts = "git stash show --text --include-untracked";
      gsta = "git stash save";
      gstaa = "git stash apply";
      gstl = "git stash list";
      gstp = "git stash pop";
      glum = "git pull upstream master";
      gwch = "git log --patch --no-merges";

    };
    completionInit = "";
    initExtra = ''
      ZINIT_HOME="''${XDG_DATA_HOME:-''${HOME}/.local/share}/zinit/zinit.git"
      [ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
      [ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
      source "''${ZINIT_HOME}/zinit.zsh"

      # A glance at the new for-syntax – load all of the above
      # plugins with a single command. For more information see:
      # https://zdharma-continuum.github.io/zinit/wiki/For-Syntax/
      zinit for \
      light-mode \
      zsh-users/zsh-autosuggestions \
      light-mode \
      zdharma-continuum/fast-syntax-highlighting \
      zdharma-continuum/history-search-multi-word \
      zsh-users/zsh-history-substring-search \
      light-mode \
      pick"async.zsh" \
      src"pure.zsh" \
      sindresorhus/pure

      ## Completion
      autoload -Uz compinit
      compinit
      zinit cdreplay -q

      ## use up-arrow and down-arrow to search history (any word)
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down

      # fzf
      if (( $+commands[fd] )); then
        export FZF_DEFAULT_OPTS="--reverse --ansi"
        export FZF_DEFAULT_COMMAND="fd ."
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND="fd -t d . $HOME"
      fi

      _source $ZDOTDIR/aliases.zsh
      _source $ZDOTDIR/completion.zsh
      _source $ZDOTDIR/keybinds.zsh
    '';

  };
  home.file.".config/zsh/keybinds.zsh" =
    {
      enable = true;
      source = ./files/zsh/keybinds.zsh;
    };
  home.file.".config/zsh/completion.zsh" =
    {
      enable = true;
      source = ./files/zsh/completion.zsh;
    };


}

