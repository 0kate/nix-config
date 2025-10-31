[
  {
    context = "Workspace";
    bindings = {
      # shift shift = file_finder::Toggle
      ctrl-j = "zed::NoAction";
      ctrl-alt-f = "workspace::ToggleZoom";
    };
  }
  {
    context = "Editor";
    bindings = {
      # j k = [workspace::SendKeystrokes, escape]
    };
  }
  {
    context = "Pane";
    bindings = {
      ctrl-shift-tab = "pane::ActivatePrevItem";
      ctrl-tab = "pane::ActivateNextItem";
    };
  }
]
