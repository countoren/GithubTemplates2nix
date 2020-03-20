{ nixpkgs        ? import <nixpkgs>{}
, templatePrefix ? "tempalte-"
}:
with nixpkgs;
let gitCmd = "${git}/bin/git";
in
buildEnv {
  name = "templatesEnv";
  paths = [
    ( writeShellScriptBin "create-tempalte-branch" ''
      read -p "template name: " $templateName
      ${gitCmd} branch ${templatePrefix}$templateName && ${gitCmd} checkout ${templatePrefix}$templateName
    '')
    ( writeShellScriptBin "template-init" ''
      cp ${./basic-template.nix} template.nix
    '')

  ];
}
