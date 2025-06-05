--[[
NOTE:
if you plan to always load your nixCats via nix,
you can safely ignore this setup call,
and the require('myLuaConf.non_nix_download') call below it.
as well as the entire lua/myLuaConf/non_nix_download file.
Unless you want the lzUtils file, or the lazy wrapper, you also wont need lua/nixCatsUtils

--[[ ----------------------------------- ]]
--[[ This setup function will provide    ]]
--[[ a default value for the nixCats('') ]]
--[[ function so that it will not throw  ]]
--[[ an error if not loaded via nixCats  ]]
--[[ ----------------------------------- ]]
require("nixCatsUtils").setup({
  non_nix_value = true,
})
--[[
Nix puts the plugins
into the directories paq-nvim expects them to be in,
because both follow the normal neovim scheme.
So you just put the URLs and build steps in there, and use its opt option to do the same
thing as putting a plugin in nixCat's optionalPlugins field.
then load the plugins via paq-nvim
YOU are in charge of putting the plugin
urls and build steps in there, which will only be used when not on nix,
and you should keep any setup functions
OUT of that file, as they are ONLY loaded when this
configuration is NOT loaded via nix.
--]]
-- TODO - make this install the propper plugins one I make my basic config
-- require("non_nix_download")
-- OK, again, that isnt needed if you load this setup via nix, but it is an option.

require("conf")
