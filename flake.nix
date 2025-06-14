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

    categoryDefinitions = {
      pkgs,
      # settings,
      # categories,
      # extra,
      # name,
      # mkPlugin,
      ...
    } @ packageDef: {
      lspsAndRuntimeDeps = {
        lsp = {
          langs = {
            rust = with pkgs; [
              rust-analyzer
            ];
            lua = with pkgs; [
              lua-language-server
            ];
            nix = with pkgs; [
              nil
              nixd
            ];
          };
        };
        lint = {
          langs = {
            rust = with pkgs; [
              clippy
            ];
            lua = with pkgs; [
              lua54Packages.luacheck
            ];
            nix = with pkgs; [
              deadnix
              statix
            ];
          };
        };
        format = {
          rust = with pkgs; [
            rustfmt
          ];
          lua = with pkgs; [
            stylua
          ];
          nix = with pkgs; [
            alejandra
          ];
        };
      };

      startupPlugins = {
        general = with pkgs.vimPlugins; [
          lze
          lzextras

          snacks-nvim
          oil-nvim
          lualine-nvim
        ];

        themer = with pkgs.vimPlugins; [
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
            blink-cmp
            blink-cmp-spell
            blink-compat
            blink-emoji-nvim
            blink-ripgrep-nvim
            friendly-snippets
            lazydev-nvim
            luasnip

            mini-nvim

            flash-nvim
            harpoon2

            which-key-nvim
            gitsigns-nvim
            bufferline-nvim
            noice-nvim

            conform-nvim
            nvim-ufo
            rustaceanvim
          ];

          lint = with pkgs.vimPlugins; [
            nvim-lint
          ];

          lsp = with pkgs.vimPlugins; [
            nvim-lspconfig
          ];

          treesitter = with pkgs.vimPlugins; [
            nvim-treesitter-textobjects
            nvim-treesitter.withAllGrammars
            nvim-treesitter-context
          ];
        };
      };

      # sharedLibraries = {
      #   general = with pkgs; [
      #     # libgit2
      #   ];
      # };

      environmentVariables = {
        # test = {
        #   CATTESTVAR = "It worked!";
        # };
      };

      # If you know what these are, you can provide custom ones by category here.
      # If you dont, check this link out:
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
      extraWrapperArgs = {
        test = [
          ''--set CATTESTVAR2 "It worked again!"''
        ];
      };

      python3.libraries = {
        test = _: [];
      };
      # populates $LUA_PATH and $LUA_CPATH
      extraLuaPackages = {
        test = [(_: [])];
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

            # TODO
            c = true;
            cpp = true;
            go = true;
            markdown = true;
          };

          format = true;
          lint = true;
          lsp = true;

          themer = true;
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
          unwrappedCfgPath = utils.mkLuaInline "os.getenv('HOME') .. '/nix/modules/nixcats/'";
        };
        categories = {
          general = true;

          langs = {
            lua = true;
            nix = true;
            rust = true;

            c = true;
            cpp = true;
            go = true;
            markdown = true;
          };

          format = true;
          lint = true;
          lsp = true;

          themer = true;
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
