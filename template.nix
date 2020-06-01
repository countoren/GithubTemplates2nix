{ name ? "template-init", repo ? ./., meta ? {} } :
with import <nixpkgs>{};
(writeShellScriptBin name '' cp -r ${repo}/* .  '')
.overrideAttrs (d : { inherit meta; })
