{
  format = builtins.concatStringsSep "" [
    "[](color_bg3)"
    "$os"
    "$username"
    "[](bg:color_bg1 fg:color_bg3)"
    "$directory"
    "[](fg:color_bg1 bg:color_lightgray)"
    "$\{custom.jj\}"
    "[ ](fg:color_lightgray)"
    "$fill"
    "$nix_shell"
    "$c"
    "$golang"
    "$gradle"
    "$java"
    "$lua"
    "$meson"
    "$nodejs"
    "$python"
    "$ruby"
    "$rust"
    "$terraform"
    "$zig"
    "$time"
    "$line_break$character"
  ];

  palette = "cool_tones";

  palettes.cool_tones = {
    color_fg0 = "#e0f7fa";
    color_bg1 = "#1e3a5f";
    color_bg2 = "#2f4b70";
    color_bg3 = "#324b6e";
    color_blue = "#4a90e2";
    color_aqua = "#53a4e5";
    color_green = "#4caf50";
    color_orange = "#ffa726";
    color_purple = "#7e57c2";
    color_red = "#ef5350";
    color_yellow = "#ffee58";
    color_darkgray = "#333333";
    color_lightgray = "#3c3c3c";
    color_brown = "#9c7711";
    color_clearblue = "#94cbff";
  };

  os = {
    disabled = false;
    style = "bg:color_bg3 fg:color_fg0";
    symbols = {
      Alpaquita = " ";
      Alpine = " ";
      AlmaLinux = " ";
      Amazon = " ";
      Android = " ";
      Arch = " ";
      Artix = " ";
      CentOS = " ";
      Debian = " ";
      DragonFly = " ";
      Emscripten = " ";
      EndeavourOS = " ";
      Fedora = " ";
      FreeBSD = " ";
      Garuda = "󰛓 ";
      Gentoo = " ";
      HardenedBSD = "󰞌 ";
      Illumos = "󰈸 ";
      Kali = " ";
      Linux = " ";
      Mabox = " ";
      Macos = " ";
      Manjaro = " ";
      Mariner = " ";
      MidnightBSD = " ";
      Mint = " ";
      NetBSD = " ";
      NixOS = " ";
      OpenBSD = "󰈺 ";
      openSUSE = " ";
      OracleLinux = "󰌷 ";
      Pop = " ";
      Raspbian = " ";
      Redhat = " ";
      RedHatEnterprise = " ";
      RockyLinux = " ";
      Redox = "󰀘 ";
      Solus = "󰠳 ";
      SUSE = " ";
      Ubuntu = " ";
      Unknown = " ";
      Void = " ";
      Windows = "󰍲 ";
    };
  };

  username = {
    show_always = true;
    style_user = "bg:color_bg3 fg:color_fg0";
    style_root = "bg:color_bg3 fg:color_fg0";
    format = "[ $user ]($style)";
  };

  directory = {
    style = "fg:color_fg0 bg:color_bg1";
    format = "[ $path ]( $style )";
    truncation_length = 3;
    truncation_symbol = "…/";

    substitutions = {
      "Documents" = "󰈙 ";
      "Downloads" = " ";
      "Music" = "󰝚 ";
      "Pictures" = " ";
      "Developer" = "󰲋 ";
    };
  };

  git_branch = {
    disabled = true;
  };

  git_status = {
    disabled = true;
  };

  nix_shell = {
    symbol = " ";
    style = "fg:color_clearblue";
    format = "[ $symbol$state \($name\) ]($style)";
  };

  fill = {
    symbol = "·";
    style = "bold color_lightgray";
  };

  time = {
    disabled = false;
    style = "fg:color_fg0";
    format = "[ 󰅐 $time ]($style)";
  };

  line_break = {
    disabled = false;
  };

  character = {
    disabled = false;
    success_symbol = "[❯](bold fg:color_green)";
    error_symbol = "[❯](bold fg:color_red)";
  };

  c = {
    symbol = " ";
    style = "fg:color_blue";
    format = "[ $symbol($version) ]($style)";
  };

  golang = {
    symbol = " ";
    style = "fg:color_aqua";
    format = "[ $symbol($version) ]($style)";
  };

  gradle = {
    symbol = " ";
    style = "fg:color_bg3";
    format = "[ $symbol($version) ]($style)";
  };

  java = {
    symbol = " ";
    style = "fg:color_brown";
    format = "[ $symbol($version) ]($style)";
  };

  lua = {
    symbol = " ";
    style = "fg:color_bg3";
    format = "[ $symbol($version) ]($style)";
  };

  meson = {
    symbol = "󰔷 ";
    style = "fg:color_purple";
    format = "[ $symbol($version) ]($style)";
  };

  nodejs = {
    symbol = " ";
    style = "fg:color_green";
    format = "[ $symbol($version) ]($style)";
  };

  python = {
    symbol = " ";
    style = "fg:color_blue";
    format = "[ $symbol($version) ]($style)";
  };

  ruby = {
    symbol = " ";
    style = "fg:color_red";
    format = "[ $symbol($version) ]($style)";
  };

  rust = {
    symbol = "󱘗 ";
    style = "fg:color_orange";
    format = "[ $symbol($version) ]($style)";
  };

  terraform = {
    symbol = "󱁢 ";
    style = "fg:color_purple";
    format = "[ $symbol($version) ]($style)";
  };

  zig = {
    symbol = " ";
    style = "fg:color_yellow";
    format = "[ $symbol($version) ]($style)";
  };

  custom = {
    jj = {
      when = "jj-starship detect";
      symbol = "";
      shell = [ "jj-starship" "--no-symbol" "--no-jj-prefix" "--no-color" "--no-git-prefix" ];
      style = "bg:color_lightgray";
      format = "[[ $symbol $output ](fg:color_fg0 bg:color_lightgray)]($style)";
    };
  };
}
