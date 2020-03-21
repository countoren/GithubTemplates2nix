{ nixpkgs        ? import <nixpkgs>{}
, templatePrefix ? "template-"
, githubUser     ? "countoren"
, githubToken    ? ""
}:
with nixpkgs;
let gitCmd = "${git}/bin/git";
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

    (import ./githubTemplates2Nix.nix { inherit nixpkgs githubUser githubToken templatePrefix;})

  ];
}
