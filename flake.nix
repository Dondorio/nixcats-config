{
  description = "My very cool nvim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
  };

  outputs = {
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
        (utils.standardPluginOverlay inputs)
      ];

    categoryDefinitions = {pkgs, ...}: {
      lspsAndRuntimeDeps = {
        general = with pkgs; [
          kdlfmt
          lldb
          ripgrep
          vscode-extensions.vadimcn.vscode-lldb.adapter
        ];

        lsp = {
          langs = {
            lua = [pkgs.lua-language-server];

            nix = with pkgs; [
              nil
              nixd
            ];

            rust = [pkgs.rust-analyzer];

            cpp = [pkgs.clang-tools];

            go = [pkgs.gopls];

            ocaml = [pkgs.ocamlPackages.ocaml-lsp];

            python = [pkgs.pyright];

            zig = [pkgs.zls];

            # Beam
            elixir = [pkgs.elixir-ls];

            gleam = [pkgs.gleam];

            web = {
              general = with pkgs; [
                emmet-ls
                tailwindcss-language-server
                typescript-language-server
                vscode-css-languageserver
              ];

              svelte = [pkgs.svelte-language-server];
            };
          };
        };

        lint = {
          langs = {
            lua = [pkgs.lua54Packages.luacheck];

            nix = with pkgs; [
              deadnix
              statix
            ];

            rust = [pkgs.clippy];

            go = [pkgs.golangci-lint];

            python = [pkgs.ruff];

            zig = [pkgs.zig-zlint];

            web = {
              general = with pkgs; [
                eslint_d
                stylelint-lsp
              ];
            };
          };
        };

        format = {
          always = [pkgs.prettierd];

          lua = [pkgs.stylua];

          nix = [pkgs.alejandra];

          rust = [pkgs.rustfmt];

          go = with pkgs; [
            go-tools
            gotools
          ];

          ocaml = [pkgs.ocamlPackages.ocamlformat];

          python = [pkgs.ruff];

          zig = [pkgs.zls];

          # Beam
          elixir = [pkgs.elixir];

          gleam = [pkgs.gleam];
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

            c = true;
            cpp = true;
            go = true;
            ocaml = true;

            # Beam
            elixir = true;
            gleam = true;

            web = {
              general = true;
              svelte = true;
            };

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
            ocaml = true;

            # Beam
            elixir = true;
            gleam = true;

            # Web
            web = {
              general = true;
              svelte = true;
            };

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
