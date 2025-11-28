{
  description = "This library enables to use Amazon S3 as a git remote and LFS server.";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    poetry2nix.url = "github:nix-community/poetry2nix";
  };
  outputs = {
    self,
    nixpkgs,
    poetry2nix,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    inherit (poetry2nix.lib.mkPoetry2Nix {inherit pkgs;}) mkPoetryApplication;
  in {
    packages.${system}.default = let
      src = pkgs.fetchFromGitHub {
        owner = "awslabs";
        repo = "git-remote-s3";
        rev = "v0.3.1";
        hash = "sha256-+50yq54ROvN7VA0JTxJ+v1izJigTYt119dqaX+MSODQ=";
      };
    in
      mkPoetryApplication {projectDir = src;};
  };
}
