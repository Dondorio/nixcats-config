{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

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
      settings,
      categories,
      extra,
      name,
      mkPlugin,
      ...
    } @ packageDef: {
      lspsAndRuntimeDeps = {
        lsp = with pkgs; [
          lua-language-server
          nixd
          nil
          rust-analyzer
        ];
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
          # builtins.getAttr (categories.colorscheme or "onedark") {
          #   # Theme switcher without creating a new category
          #   "onedark" = onedark-nvim;
          #   "catppuccin" = catppuccin-nvim;
          #   "catppuccin-mocha" = catppuccin-nvim;
          #   "tokyonight" = tokyonight-nvim;
          #   "tokyonight-day" = tokyonight-nvim;
          # } 
          ];
      };

      # Lazily loaded plugins
      optionalPlugins = {
        gitPlugins = with pkgs.neovimPlugins; [];
        general = {
          always = with pkgs.vimPlugins; [
            which-key-nvim
            luasnip
            friendly-snippets
            lazydev-nvim
            blink-cmp
            blink-compat
            blink-cmp-spell
            blink-ripgrep-nvim
            blink-emoji-nvim

            flash-nvim
            mini-nvim
          ];

          lsp = with pkgs.vimPlugins; [
            nvim-lspconfig
          ];

          treesitter = with pkgs.vimPlugins; [
            nvim-treesitter-textobjects
            nvim-treesitter.withAllGrammars
          ];
        };
      };

      sharedLibraries = {
        general = with pkgs; [
          # libgit2
        ];
      };

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
      nixCatsPkg = {
        pkgs,
        name,
        ...
      }: {
        # they contain a settings set defined above
        # see :help nixCats.flake.outputs.settings
        settings = {
          suffix-path = true;
          suffix-LD = true;
          wrapRc = true;
          aliases = ["nixCats"];
        };
        # and a set of categories that you want
        # (and other information to pass to lua)
        categories = {
          general = true;
          gitPlugins = true;
          customPlugins = true;

          lsp = true;
          themer = true;
          colorscheme = "catppuccin";
          # test = true;
          # example = {
          #   youCan = "add more than just booleans";
          #   toThisSet = [
          #     "and the contents of this categories set"
          #     "will be accessible to your lua with"
          #     "nixCats('path.to.value')"
          #     "see :help nixCats"
          #   ];
          # };
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
          gitPlugins = true;
          customPlugins = true;

          lsp = true;
          themer = true;
          colorscheme = "catppuccin";
        };
        extra = {};
      };
    };
    defaultPackageName = "nixCatsPkg";
  in
    forEachSystem (system: let
      nixCatsBuilder =
        utils.baseBuilder luaPath {
          inherit nixpkgs system dependencyOverlays extra_pkg_config;
        }
        categoryDefinitions
        packageDefinitions;
      defaultPackage = nixCatsBuilder defaultPackageName;
      # this is just for using utils such as pkgs.mkShell
      # The one used to build neovim is resolved inside the builder
      # and is passed to our categoryDefinitions and packageDefinitions
      pkgs = import nixpkgs {inherit system;};
    in {
      # these outputs will be wrapped with ${system} by utils.eachSystem

      # this will make a package out of each of the packageDefinitions defined above
      # and set the default package to the one passed in here.
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
