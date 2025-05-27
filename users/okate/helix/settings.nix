{
  theme = "sonokai";

  editor = {
    bufferline = "always";
    cursorline = true;
    cursorcolumn = true;
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
}
