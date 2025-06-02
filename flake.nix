{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      perSystem =
        {
          pkgs,
          lib,
          system,
          ...
        }:
        let
          hoblisp = pkgs.stdenv.mkDerivation rec {
            pname = "hoblisp-java";
            version = "0.1.0";
            src = lib.cleanSource ./.;

            gradleBuildTask = "build";

            nativeBuildInputs = [
              pkgs.gradle
            ];

            installPhase = ''
              mkdir -p $out/bin
              mkdir -p $out/share
              mkdir -p $out/opt

              cp -r build/distributions/source.tar $out/opt
              tar xf $out/opt/source.tar -C $out/share

              ln -s $out/share/source/bin/source $out/bin/hoblisp-java
            '';
          };
        in
        {
          treefmt = {
            projectRootFile = "flake.nix";

            # Nix
            programs.nixfmt.enable = true;

            # Java
            programs.google-java-format.enable = true;

            # GitHub Actions
            programs.actionlint.enable = true;

            # Markdown
            programs.mdformat.enable = true;

            # ShellScript
            programs.shellcheck.enable = true;
            programs.shfmt.enable = true;
          };

          packages = {
            inherit hoblisp;
            default = hoblisp;
          };

          devShells.default = pkgs.mkShell {
            packages = [
              # Java
              pkgs.openjdk
              pkgs.gradle

              # Nix
              pkgs.nil
            ];

            shellHook = ''
              export PS1="\n[nix-shell:\w]$ "
            '';
          };
        };
    };
}
