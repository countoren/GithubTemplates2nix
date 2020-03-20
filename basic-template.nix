{ name ? "template-init", repo ? ./., meta ? {} } :
with import <nixpkgs>{};
assert (lib.assertMsg (name!="") "template name must be given if repo does not contain template.nix file"); 
(writeShellScriptBin name '' cp -r ${repo}/* .  '')
.overrideAttrs (d : { inherit meta; })
