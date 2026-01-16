{
  language-server = {
    vscode-json-languageserver = {
      command = "vscode-json-languageserver";
      args = [ "--stdio" ];
    };
  };

  language = [
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
      name = "hcl";
      language-id = "terraform";
      language-servers = [ "terraform-ls" "gpt" ];
    }
    {
      name = "tfvars";
      language-id = "terraform-vars";
      language-servers = [ "terraform-ls" "gpt" ];
    }
  ];
}
