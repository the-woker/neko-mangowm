{
  description = "A Nix flake for neko-mangowm";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    neko = {
      url = "github:the-woker/neko-mangowm";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      neko,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.${system}.default = pkgs.rustPlatform.buildRustPackage {
        pname = "neko-mangowm";
        version = "0.1.0";

        src = neko;

        cargoLock = {
          lockFile = "${neko}/Cargo.lock";
        };

        postUnpack = ''
          cat << EOF > "$sourceRoot/Cargo.toml"
          [workspace]
          members = ["mangowm"]
          resolver = "2"
          EOF
        '';

        cargoBuildFlags = [
          "-p"
          "mangowm"
        ];
        cargoCheckFlags = [
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

      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          cargo
          rustc
          pkg-config
        ];
        buildInputs = with pkgs; [
          libx11
          libxrandr
          libxinerama
          libxkbcommon
        ];
      };
    };
}
