{
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
}
