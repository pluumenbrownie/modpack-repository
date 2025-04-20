{
  description = "Flake used for computational science. Shows how to add python packages to config when unavailable.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        toml-cli
        mdbook
        shfmt
        shellcheck
        zip
      ];

      env = {
        REPO_URL = "https://pluumenbrownie.github.io/modpack-repository";
      };
    };

    doCheck = false;
  };
}
