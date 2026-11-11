{
  onboarding = false;

  keys = {
    prefix = "ctrl+b";

    # Navigate mode: j/k move through the sidebar's workspace list instead of
    # between panes. Pane movement moves to the up/down arrows to avoid a clash.
    navigate_workspace_up = "k";
    navigate_workspace_down = "j";
    navigate_pane_up = "up";
    navigate_pane_down = "down";

    # Freed up for the reviewr plugin below. Config reloads still happen through
    # `herdr server reload-config`, which home-manager runs on every rebuild.
    reload_config = "";

    command = [
      {
        key = "prefix+shift+r";
        type = "plugin_action";
        command = "persiyanov.reviewr.toggle";
        description = "Toggle the reviewr code review pane";
      }
    ];
  };
}
