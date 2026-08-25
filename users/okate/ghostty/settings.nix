{
  font-family = "HackGen Console NF";
  font-size = 13.5;
  font-feature = "-calt";

  theme = "GitHub Dark Dimmed";

  # NOTE: shell integration forces a bar cursor at the prompt; `no-cursor`
  # lets it fall back to `cursor-style` (block).
  # https://ghostty.org/docs/config/reference#cursor-style
  shell-integration-features = "no-cursor";

  keybind = [
    "ctrl+shift+h=goto_split:left"
    "ctrl+shift+j=goto_split:down"
    "ctrl+shift+k=goto_split:up"
    "ctrl+shift+l=goto_split:right"
  ];
}
