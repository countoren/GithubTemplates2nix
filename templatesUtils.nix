with import <nixpkgs>{};
rec {
  tarUrlToDrv = { url, name, meta ? {}}  : repoToDrv { inherit name ; meta = { inherit url;} ; repo =(fetchTarball url);};

  repoToDrv =  {repo, name, meta ?{} } : 
  assert (lib.assertMsg (lib.isStorePath repo) "repo must be a store path folder");
  if (lib.hasAttr "template.nix" (builtins.readDir repo) ) then
    import "${repo}/template.nix" { inherit repo name meta; }  
  else 
    import ./basic-template.nix { inherit repo name meta; };
}
