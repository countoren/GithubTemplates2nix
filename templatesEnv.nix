{ nixpkgs        ? import <nixpkgs>{}
, templatePrefix ? "template-"
, githubUser     ? "countoren"
, githubToken    ? ""
, templatesFile  ? "./templates.nix"
}:
with nixpkgs;
let gitCmd = "${git}/bin/git";
    ght2nix = import ./githubTemplates2Nix.nix { inherit nixpkgs githubUser githubToken templatePrefix;};
in
buildEnv { 
  name = "templatesEnv";
  paths = [
    ( writeShellScriptBin "create-template-branch" ''
      read -p "template name: " $templateName
      ${gitCmd} branch ${templatePrefix}$templateName && ${gitCmd} checkout ${templatePrefix}$templateName
    '')
    ( writeShellScriptBin "template-init" ''
      cp ${./.}/basic-template.nix template.nix
    '')


    ght2nix

    ( writeShellScriptBin "update-templates" ''
      ${ght2nix}/bin/ght2nix > ${templatesFile}
    '')
  ];
}
