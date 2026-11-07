{
  onboarding = false;

  keys = {
    prefix = "ctrl+b";

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
