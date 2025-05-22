{ inputs, isWSL, ... }:
{ config, pkgs, lib, ... }:
{
  home.stateVersion = "22.11";

  home.packages = with pkgs; [
    awscli2
    bundler
    clamav
    clang
    cmake
    curl
    direnv
    docker-compose-language-service
    dockerfile-language-server-nodejs
    eza
    gettext
    git
    gnupg
    google-cloud-sdk
    helix
    helix-gpt
    jq
    just
    lazydocker
    lazygit
    navi
    nb
    nil
    ninja
    nixpkgs-fmt
    nodePackages_latest.vscode-json-languageserver
    pass
    peco
    pinentry-qt
    ripgrep
    rustup
    sheldon
    ssm-session-manager-plugin
    taplo
    tree-sitter
    unzip
    vim
    yaml-language-server
    zellij
  ] ++ (lib.optionals (!isWSL) [
    alacritty
    android-studio
    bitwarden-desktop
    brave
    dbeaver-bin
    drawio
    firefox
    gnome-boxes
    google-chrome
    slack
    xclip
    xdg-desktop-portal-gnome
    xdotool
    xorg.xprop
    xorg.xrandr
    xorg.xwininfo
    zoom-us
  ]);

  xdg.configFile = {
    "zellij/config.kdl".text = builtins.readFile ./zellij.kdl;
    "alacritty/alacritty.toml".text = builtins.readFile ./alacritty/config.toml;
    "alacritty/themes/sonokai.toml".text = builtins.readFile ./alacritty/themes/sonokai.toml;
    "starship.toml".text = builtins.readFile ./starship.toml;
  };
  
  dconf = {
    enable = !isWSL;
    settings = {
      "org/gnome/shell" = {
        enabled-extensions = [
          "Bluetooth-Battery-Meter@maniacx.github.com"
          "clipboard-indicator@tudmotu.com"
          "dash-to-dock@micxgx.gmail.com"
          "kimpanel@kde.org"
          "paperwm@paperwm.github.com"
          "system-monitor@gnome-shell-extensions.gcampax.github.com"
          "tailscale-status@maxgallup.github.com"
        ];
      };
    };
  };

  programs.zsh = {
    enable = true;
    initExtra = builtins.readFile ./zshrc;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      lgd = "lazydocker";
      lgg = "lazygit";
      ls  = "eza --icons";
      zj  = "zellij";
    };

    plugins = [
      {
        name = "powerlevel10k";
        src  = pkgs.fetchFromGitHub {
          owner  = "romkatv";
          repo   = "powerlevel10k";
          rev    = "v1.20.0";
          sha256 = "ES5vJXHjAKw/VHjWs8Au/3R+/aotSbY7PWnWAMzCR8E=";
        };
      }
      {
        name = "zsh-autocomplete";
        src  = pkgs.fetchFromGitHub {
          owner  = "marlonrichert";
          repo   = "zsh-autocomplete";
          rev    = "24.09.04";
          sha256 = "o8IQszQ4/PLX1FlUvJpowR2Tev59N8lI20VymZ+Hp4w=";
        };
      }
    ];
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "sonokai";

      editor = {
        bufferline = "always";
        cursorline = true;
        scrolloff = 10;
        true-color = true;
        undercurl = true;
        end-of-line-diagnostics = "hint";
        completion-replace = true;

        statusline = {
          left = [
            "spacer"
            "mode"
            "spacer"
            "read-only-indicator"
            "file-name"
            "spacer"
            "version-control"
          ];
          center = [];
          right = [
            "spinner"
            "diagnostics"
            "selections"
            "register"
            "spacer"
            "position"
            "position-percentage"
            "spacer"
            "file-type"
            "file-encoding"
            "file-line-ending"
          ];
        };

        cursor-shape = {
          insert = "bar";
          select = "underline";
        };

        file-picker = {
          hidden = false;
          git-ignore = false;
          git-global = false;
        };

        whitespace = {
          render = {
            space = "all";
            tab = "all";
          };
          characters = {
            space = "·";
            tab = "→";
          };
        };

        indent-guides = {
          render = true;
          character = "╎";
        };

        inline-diagnostics = {
          cursor-line = "error";
        };
      };

      keys = {
        normal = {
          "tab" = "goto_next_buffer";
          "S-tab" = "goto_previous_buffer";
          "C-x" = ":buffer-close";
        };
        insert = {
          "C-[" = "normal_mode";
        };
        select = {
          "C-[" = "normal_mode";
        };
      };
    };

    languages = {
      language-server = {
        jdtls = {
          command = "jdtls";
        };
        gpt = {
          command = "helix-gpt";
        };
        vscode-json-languageserver = {
          command = "vscode-json-languageserver";
          args = [ "--stdio" ];
        };
        typescript-language-server = {
          config.plugins = {
            name = "@vue/typescript-plugin";
            location = "/nix/store/3ihrs9w5yvfl6g7ib3mmw9i70mplcmmz-vue-language-server-2.1.6/lib/node_modules/@vue/language-server";
            languages = [ "vue" ];
          };
        };
      };

      language = [
        {
          name = "vue";
          auto-format = true;
          formatter = { command = "prettier"; args = [ "--parser" "vue" ]; };
          language-servers = [ "typescript-language-server" "gpt" ];
        }
        {
          name = "typescript";
          formatter = { command = "prettier"; };
          language-servers = [ "typescript-language-server" "gpt" ];
        }
        {
          name = "java";
          roots = [ "build.gadle" ];
          language-servers = [ "jdtls" "gpt" ];
        }
        {
          name = "nix";
          formatter = { command = "nixpkgs-fmt"; };
          language-servers = [ "nil" "gpt" ];
        }
        {
          name = "json";
          language-servers = [ "vscode-json-languageserver" "gpt" ];
        }
        {
          name = "python";
          language-servers = [ "pylsp" "gpt" ];
        }
        {
          name = "ruby";
          language-servers = [ "solargraph" "gpt" ];
        }
        {
          name = "hcl";
          language-id = "terraform";
          language-servers = [ "terraform-ls" "gpt" ];
        }
        {
          name = "tfvars";
          language-id = "terraform-vars";
          language-servers = [ "terraform-ls" "gpt" ];
        }
        {
          name = "go";
          language-servers = [ "gopls" "gpt" ];
        }
      ];
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.navi = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "keito-osaki";
    userEmail = "o.keito317@gmail.com";
    ignores = [
      "devbox.json"
      "devbox.lock"
      "devenv.lock"
      "devenv.local.nix"
      "devenv.nix"
      "devenv.yaml"
      "shell.nix"
      ".envrc"
      ".devenv*"
      ".direnv"
      ".pre-commit-config.yaml"
      ".venv"
    ];
  };

  programs.lazygit = {
    enable = true;
    settings = builtins.fromJSON (builtins.readFile ./lazygit.json);
  };
  
  programs.zellij = {
    enable = true;
  };
}
