{
  description = "A Nix flake for neko-mangowm";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        neko-mangowm = pkgs.rustPlatform.buildRustPackage {
          pname = "neko-mangowm";
          version = "0.1.0";

          src = self.inputs.neko or pkgs.fetchFromGitHub {
            owner = "the-woker";
            repo = "neko-mangowm";
            rev = "1b3750d0697498c29c55b31b812b8ed71774d35c";
            hash = "sha256-3BWuBGDsvlyeio7ZyviSfiPF3pwmntBfs8k9eIzucuo=";
          };

          cargoLock = {
            lockFile = "${neko-mangowm.src}/Cargo.lock";
          };

          cargoBuildFlags = [
            "-p"
            "mangowm"
          ];

          nativeBuildInputs = with pkgs; [
            pkg-config
          ];

          buildInputs = with pkgs; [
            libx11
            libxrandr
            libxinerama
            libxkbcommon
          ];
        };
      in
      {
        packages.default = neko-mangowm;

        apps.default = flake-utils.lib.mkApp {
          drv = neko-mangowm;
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ neko-mangowm ];
          nativeBuildInputs = with pkgs; [
            cargo
            rustc
          ];
        };
      }
    );
}
