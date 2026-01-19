{
  description = "This library enables to use Amazon S3 as a git remote and LFS server.";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs =
    {
      self,
      nixpkgs,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      inherit (pkgs.python3Packages) buildPythonPackage;
    in
    {
      packages.${system}.default = buildPythonPackage rec {
        pname = "git-remote-s3";
        version = "v0.3.1";
        pyproject = true;
        src = pkgs.fetchFromGitHub {
          owner = "awslabs";
          repo = "git-remote-s3";
          rev = version;
          hash = "sha256-QDx4jDGfPvakrYp8hv1apGmxr04Sb2gUe4kLDpZFL3o=";
        };
        patches = [ ./deps.patch ];
        dependencies = with pkgs.python3Packages; [
          poetry-core
          botocore
          boto3
          urllib3
        ];
      };

      formatter.${system} = pkgs.nixfmt-tree;
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          alejandra
          nil
        ];
      };

      nixosConfigurations.hostname = pkgs.lib.nixosSystem {
        modules = [ ];
      };

      templates.default.path = ./.;
    };
}
