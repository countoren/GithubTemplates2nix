with import <nixpkgs>{};
rec {
  tarUrlToDrv = { url, name, meta ? {}}  : repoToDrv { inherit name ; meta = { inherit url;} ; repo =(fetchTarball url);};

  repoToDrv =  {repo, name, meta ?{} }@repoParams : 
  assert (lib.assertMsg (lib.isStorePath repo) "repo must be a store path folder");
  if (lib.hasAttr "template.nix" (builtins.readDir repo) ) then
    import "${repo}/template.nix" repoParams
  else 
    import ./basic-template.nix repoParams;
}
