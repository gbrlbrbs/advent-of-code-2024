{
  description = "An Elixir flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      allowUnfree = true;
    };
    nativeBuildInputs = with pkgs; [bashInteractive];
  in
    with pkgs; {
      devShells.${system}.default = mkShell {
        inherit nativeBuildInputs;
        buildInputs = [
          erlang
          elixir
          mix2nix
        ];
      };
    };
}
