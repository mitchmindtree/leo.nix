{
  description = "A flake for the Provable ecosystem.";

  inputs = {
    leo-src = {
      url = "github:provablehq/leo";
      flake = false;
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs:
    let
      overlays = [
        inputs.rust-overlay.overlays.default
        inputs.self.overlays.default
      ];
      perSystemPkgs =
        f:
        inputs.nixpkgs.lib.genAttrs (import inputs.systems) (
          system: f (import inputs.nixpkgs { inherit overlays system; })
        );
    in
    {
      overlays = {
        default = final: prev: {
          leo = prev.callPackage ./pkgs/leo.nix { src = inputs.leo-src; };
        };
      };

      packages = perSystemPkgs (pkgs: {
        leo = pkgs.leo;
      });

      devShells = perSystemPkgs (pkgs: {
        leo-dev = pkgs.callPackage ./pkgs/leo-dev.nix { };
      });

      formatter = perSystemPkgs (pkgs: pkgs.nixfmt-tree);
    };
}
