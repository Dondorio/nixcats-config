{
  description = "My very cool nvim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
  };

  outputs = {
    self,
    nixpkgs,
    nixCats,
    ...
  } @ inputs: let
    inherit (nixCats) utils;
    luaPath = ./.;
    forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
    extra_pkg_config = {
      allowUnfree = true;
    };

    dependencyOverlays =
      /*
      (import ./overlays inputs) ++
      */
      [
        # This overlay grabs all the inputs named in the format
        # `plugins-<pluginName>`
        # Once we add this overlay to our nixpkgs, we are able to
        # use `pkgs.neovimPlugins`, which is a set of our plugins.
        (utils.standardPluginOverlay inputs)
        # add any other flake overlays here.

        # when other people mess up their overlays by wrapping them with system,
        # you may instead call this function on their overlay.
        # it will check if it has the system in the set, and if so return the desired overlay
        # (utils.fixSystemizedOverlay inputs.codeium.overlays
        #   (system: inputs.codeium.overlays.${system}.default)
        # )
      ];

    categoryDefinitions = {pkgs, ...}: {
      lspsAndRuntimeDeps = {
        general = with pkgs; [
          kdlfmt
          ripgrep
          vscode-extensions.vadimcn.vscode-lldb.adapter
          lldb
        ];

        lsp = {
          langs = {
            lua = with pkgs; [
              lua-language-server
            ];

            nix = with pkgs; [
              nil
              nixd
            ];

            rust = with pkgs; [
              rust-analyzer
            ];

            cpp = with pkgs; [
              clang-tools
            ];

            go = with pkgs; [
              gopls
            ];

            elixir = with pkgs; [
              elixir-ls
            ];
          };
        };

        lint = {
          langs = {
            lua = with pkgs; [
              lua54Packages.luacheck
            ];

            nix = with pkgs; [
              deadnix
              statix
            ];

            rust = with pkgs; [
              clippy
            ];

            go = with pkgs; [
              golangci-lint
            ];
          };
        };

        format = {
          always = with pkgs; [
            prettierd
          ];

          lua = with pkgs; [
            stylua
          ];

          nix = with pkgs; [
            alejandra
          ];

          rust = with pkgs; [
            rustfmt
          ];

          go = with pkgs; [
            go-tools
            gotools
          ];

          elixir = with pkgs; [
            # mix format
            elixir
          ];
        };
      };

      startupPlugins = {
        general = with pkgs.vimPlugins; [
          lze
          lzextras

          friendly-snippets
          lualine-nvim
          nvim-nio
          oil-nvim
          snacks-nvim
          tiny-inline-diagnostic-nvim
          undotree
        ];

        langs = {
          rust = with pkgs.vimPlugins; [
            rustaceanvim
          ];

          cpp = with pkgs.vimPlugins; [
            clangd_extensions-nvim
          ];
        };

        themes = with pkgs.vimPlugins; [
          catppuccin-nvim
          gruvbox
          gruvbox-material
          kanagawa-nvim
          kanagawa-paper-nvim
          onedark-nvim
          rose-pine
          sonokai
          sonokai
          tokyonight-nvim
        ];
      };

      # Lazily loaded plugins
      optionalPlugins = {
        general = {
          always = with pkgs.vimPlugins; [
            # General utility
            mini-nvim

            # Completion
            blink-cmp
            blink-cmp-spell
            blink-compat
            friendly-snippets
            luasnip

            # Navigation
            flash-nvim
            harpoon2

            # Ui
            bufferline-nvim
            gitsigns-nvim
            noice-nvim
            nvim-biscuits
            render-markdown-nvim
            trouble-nvim
            which-key-nvim

            nvim-ufo
          ];

          debug = with pkgs.vimPlugins; [
            nvim-dap
            nvim-dap-ui
            nvim-dap-virtual-text
          ];

          lint = with pkgs.vimPlugins; [
            nvim-lint
          ];

          lsp = with pkgs.vimPlugins; [
            lazydev-nvim
            nvim-lspconfig
          ];

          format = with pkgs.vimPlugins; [
            conform-nvim
          ];

          treesitter = with pkgs.vimPlugins; [
            nvim-treesitter-textobjects
            nvim-treesitter.withAllGrammars
            nvim-treesitter-context
          ];
        };
      };
    };

    packageDefinitions = {
      nixCats = {...}: {
        settings = {
          suffix-path = true;
          suffix-LD = true;
          wrapRc = true;
          aliases = ["nvim" "vim" "vi"];
        };

        categories = {
          general = true;
          gitPlugins = true;
          customPlugins = true;

          langs = {
            lua = true;
            nix = true;
            rust = true;

            java = false;

            # TODO
            c = true;
            cpp = true;
            go = true;

            elixir = true;

            markdown = true;
          };

          debug = true;
          format = true;
          lint = true;
          lsp = true;

          themes = true;
          colorscheme = "kanagawa";
        };
      };

      testnvim = {...}: {
        settings = {
          suffix-path = true;
          suffix-LD = true;
          wrapRc = false;
          # Due to flakes not letting you get the flake's local directory this
          # is used as a workaround. Run nix ``shell .#testnvim`` inside of the
          # nixcats folder to get wrapRc working. With this you can also run
          # other configurations just by running ``testnvim`` inside of another
          # config
          unwrappedCfgPath = utils.mkLuaInline "os.getenv('PWD')";
        };
        categories = {
          general = true;

          langs = {
            lua = true;
            nix = true;
            rust = true;

            java = false;

            c = true;
            cpp = true;
            go = true;

            elixir = true;

            markdown = true;
          };

          debug = true;
          format = true;
          lint = true;
          lsp = true;

          themes = true;

          colorscheme = "catppuccin";
        };
        extra = {};
      };
    };
    defaultPackageName = "nixCats";
  in
    forEachSystem (system: let
      nixCatsBuilder =
        utils.baseBuilder luaPath {
          inherit nixpkgs system dependencyOverlays extra_pkg_config;
        }
        categoryDefinitions
        packageDefinitions;
      defaultPackage = nixCatsBuilder defaultPackageName;
      pkgs = import nixpkgs {inherit system;};
    in {
      packages = utils.mkAllWithDefault defaultPackage;

      devShells = {
        default = pkgs.mkShell {
          name = defaultPackageName;
          packages = [defaultPackage];
          inputsFrom = [];
          shellHook = ''
          '';
        };
      };
    })
    // (let
      nixosModule = utils.mkNixosModules {
        moduleNamespace = [defaultPackageName];
        inherit
          defaultPackageName
          dependencyOverlays
          luaPath
          categoryDefinitions
          packageDefinitions
          extra_pkg_config
          nixpkgs
          ;
      };
      homeModule = utils.mkHomeModules {
        moduleNamespace = [defaultPackageName];
        inherit
          defaultPackageName
          dependencyOverlays
          luaPath
          categoryDefinitions
          packageDefinitions
          extra_pkg_config
          nixpkgs
          ;
      };
    in {
      overlays =
        utils.makeOverlays luaPath {
          inherit nixpkgs dependencyOverlays extra_pkg_config;
        }
        categoryDefinitions
        packageDefinitions
        defaultPackageName;

      nixosModules.default = nixosModule;
      homeModules.default = homeModule;

      inherit utils nixosModule homeModule;
      inherit (utils) templates;
    });
}
