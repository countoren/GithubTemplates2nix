{ nixpkgs ? import <nixpkgs>{}
, githubUser ? "countoren"
, githubToken ? ""
, templatePrefix ? "template-"

, curl ? nixpkgs.curl
, jq   ? nixpkgs.jq
}:
let 
  curlCmd = ''${curl}/bin/curl ${(if githubToken != "" then "-u \"${githubUser}:${githubToken}\"" else "")}'';
  jqCmd = ''${jq}/bin/jq'';
in 
nixpkgs.writeShellScriptBin "ght2nix" ''
    echo 'let ghUrlToDerivation = import ${./ghUrlToDerivation.nix};'
    echo 'in'
    echo '{'

    for line in $(
      ${curlCmd} "https://api.github.com/users/countoren/repos" \
      | ${jqCmd} -r '"https://api.github.com/repos/countoren/\(.[] .name)/branches?per_page=1000"' \
      | xargs ${curlCmd} \
      | ${jqCmd} -r '.[] | "\(.name)@@\(.commit.sha)"' 
    ) ; do

      if [[ $line =~ (^${templatePrefix})([^@]+)@@(.*) ]]; then

      templatePrefix=''${BASH_REMATCH[1]}
      templateName=''${BASH_REMATCH[2]}
      revision=''${BASH_REMATCH[3]}

      echo "''${templateName} = ghUrlToDerivation \"https://github.com/countoren/''${templatePrefix}''${templateName}/archive/''${revision}.tar.gz\";"  

      fi
    done

    echo '}'
''
