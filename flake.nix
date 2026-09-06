{
  description = "Lean 4 Example Project";

  inputs = {
    nixpkgs.follows = "lean4-nix/nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    lean4-nix.url = "github:lenianiva/lean4-nix";
  };

  outputs =
    inputs@{
      nixpkgs,
      flake-parts,
      lean4-nix,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      perSystem =
        {
          system,
          pkgs,
          ...
        }:
        let
          # Lean's official macOS release ships dylibs whose install names are
          # @rpath-based. nixpkgs' fixDarwinDylibNames hook rewrites install
          # names to absolute store paths, and libleanshared_1.dylib has no
          # header padding left to hold the longer string, so the prebuilt
          # toolchain cannot be realised on darwin at all (lean4-nix#76, open
          # since 2025-10 and unaffected by which Lean version is pinned).
          #
          # Building from source sidesteps it: libraries compiled inside the
          # store are linked against their final absolute paths from the start,
          # so there is nothing for the hook to rewrite. Linux takes the
          # autoPatchelfHook branch instead and is unaffected, so it keeps the
          # prebuilt archive and CI stays fast.
          isDarwin = nixpkgs.lib.hasSuffix "-darwin" system;
        in
        {
          _module.args.pkgs = import nixpkgs {
            inherit system;
            overlays = [
              (lean4-nix.readToolchainFile {
                toolchain = ./lean-toolchain;
                binary = !isDarwin;
              })
            ];
          };

          devShells.default = pkgs.mkShell {
            packages = with pkgs.lean; [ lean-all ];
          };
        };
    };
}
