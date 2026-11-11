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

    # Herdr's built-in "new worktree" always places checkouts at
    # <worktrees.directory>/<repo>/<branch-slug>, which does not match the
    # ~/src/workspaces/<slug>/<repo> layout. Disable it and bind the same key
    # to herdr-new-workspace (./new-workspace.sh) instead: it creates one
    # worktree per selected repo and one herdr workspace per purpose (<slug>)
    # with a tab per repo.
    new_worktree = "";

    command = [
      {
        key = "prefix+shift+g";
        type = "popup";
        command = "herdr-new-workspace";
        description = "New/extend workspace ~/src/workspaces/<branch>/<repo...>";
        width = "70%";
        height = "60%";
      }
      {
        key = "prefix+shift+r";
        type = "plugin_action";
        command = "persiyanov.reviewr.toggle";
        description = "Toggle the reviewr code review pane";
      }
    ];
  };
}
