{
  "$schema" = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json";
  version = 4;
  blocks = [
    {
      alignment = "left";
      type = "prompt";
      segments = [
        {
          background = "#29315A";
          foreground = "#3EC669";
          leading_diamond = "";
          options = {
            style = "mixed";
          };
          style = "diamond";
          template = " {{ .Path }}";
          trailing_diamond = "";
          type = "path";
        }
        {
          background = "#29315A";
          foreground = "#43CCEA";
          foreground_templates = [
            "{{ if or (.Working.Changed) (.Staging.Changed) }}#FF9248{{ end }}"
            "{{ if and (gt .Ahead 0) (gt .Behind 0) }}#ff4500{{ end }}"
            "{{ if gt .Ahead 0 }}#B388FF{{ end }}"
            "{{ if gt .Behind 0 }}#B388FF{{ end }}"
          ];
          leading_diamond = " ";
          options = {
            branch_template = "{{ trunc 25 .Branch }}";
            fetch_status = true;
            fetch_upstream_icon = true;
          };
          style = "diamond";
          template = " {{ .UpstreamIcon }}{{ .HEAD }}{{if .BranchStatus }} {{ .BranchStatus }}{{ end }}{{ if .Working.Changed }}  {{ .Working.String }}{{ end }}{{ if and (.Working.Changed) (.Staging.Changed) }} |{{ end }}{{ if .Staging.Changed }}  {{ .Staging.String }}{{ end }}{{ if gt .StashCount 0 }}  {{ .StashCount }}{{ end }} ";
          trailing_diamond = "";
          type = "git";
        }
        {
          type = "jujutsu";
          style = "diamond";
          leading_diamond = " ";
          trailing_diamond = "";
          template = " {{ .ChangeID }}";
          foreground = "#193549";
          background = "#ffeb3b";
          options = {
            change_id_min_len = 10;
            fetch_status = true;
            ignore_working_copy = false;
            fetch_ahead_counter = true;
            ahead_icon = "⇡";
          };
        }
        {
          foreground = "#C94A16";
          style = "plain";
          template = "x ";
          type = "status";
        }
      ];
    }
    {
      alignment = "right";
      type = "prompt";
      segments = [
        {
          type = "node";
          style = "plain";
          foreground = "#88e570";
          options = {
            display_mode = "files";
            fetch_package_manager = true;
            fetch_version = true;
            bun_icon = "<#e5dbcc> bun</>";
            npm_icon = "<#e5272d> npm</> ";
            pnpm_icon = "<#e5a100> pnpm</> ";
            yarn_icon = "<#37aee5> yarn</> ";
          };
          template = "{{ if .PackageManagerIcon }}{{ .PackageManagerIcon }} {{ end }} {{ .Full }}";
        }
        {
          foreground = "#4063D8";
          options = {
            display_mode = "files";
            fetch_version = true;
          };
          style = "plain";
          template = " {{ if .Error }}{{ .Error }}{{ else }}{{ .Full }}{{ end }}";
          type = "crystal";
        }
        {
          foreground = "#DE3F24";
          options = {
            display_mode = "files";
            fetch_version = true;
          };
          style = "plain";
          template = " {{ if .Error }}{{ .Error }}{{ else }}{{ .Full }}{{ end }}";
          type = "ruby";
        }
        {
          foreground = "#FED142";
          options = {
            display_mode = "context";
            fetch_virtual_env = false;
          };
          style = "plain";
          template = " {{ if .Error }}{{ .Error }}{{ else }}{{ .Full }}{{ end }}";
          type = "python";
        }
      ];
    }
    {
      alignment = "left";
      newline = true;
      type = "prompt";
      segments = [
        {
          foreground = "#63F08C";
          style = "plain";
          template = "➜ ";
          type = "text";
        }
      ];
    }
  ];
}
