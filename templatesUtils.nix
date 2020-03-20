{
  nixpkgs ? import <nixpkgs>{}
}:
with nixpkgs;
rec {
  tarUrlToDrv = { name, url, meta ? {}}  : repoToDrv { inherit name meta; repo =(fetchTarball url);};

  repoToDrv =  repoParams : 
  if (lib.hasAttr "template.nix" (builtins.readDir ./. ) ) then
    import "${repo}/template.nix" repoParams
  else 
    import ./basic-template.nix repoParams;
}
