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

    categoryDefinitions = {pkgs, ...} @ packageDef: {
      lspsAndRuntimeDeps = {
        general = with pkgs; [
          codespell
          ripgrep
          vscode-extensions.vadimcn.vscode-lldb.adapter
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
              # clangd
            ];

            # Extra

            go = with pkgs; [
              gopls
            ];

            java = with pkgs; [
              jdt-language-server
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

            # Extra

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

          # Extra

          go = with pkgs; [
            go-tools
            gotools
          ];
        };
      };

      startupPlugins = {
        general = with pkgs.vimPlugins; [
          lze
          lzextras

          yuck-vim
          lualine-nvim
          nvim-nio
          oil-nvim
          snacks-nvim
        ];

        langs = {
          rust = with pkgs.vimPlugins; [
            rustaceanvim
          ];
        };

        themes = with pkgs.vimPlugins; [
          onedark-nvim
          catppuccin-nvim
          catppuccin-nvim
          tokyonight-nvim
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
            blink-emoji-nvim
            blink-ripgrep-nvim
            friendly-snippets
            lazydev-nvim
            luasnip

            # Navigation
            flash-nvim
            harpoon2

            # Ui
            bufferline-nvim
            gitsigns-nvim
            noice-nvim
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
      nixCats = {
        pkgs,
        name,
        ...
      }: {
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
            markdown = true;
          };

          debug = true;
          format = true;
          lint = true;
          lsp = true;

          themes = true;
          colorscheme = "catppuccin";
        };
      };

      testnvim = {
        pkgs,
        name,
        ...
      }: {
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
