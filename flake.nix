{
  description = "Jandro's NVF Config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nvf.url = "github:NotAShelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    nvf,
    ...
  }: let
    darwinSystems = {
      aarch64 = "aarch64-darwin";
    };

    linuxSystems = {
      x86_64 = "x86_64-linux";
      aarch64 = "aarch64-linux";
    };

    allSystems = builtins.attrValues darwinSystems ++ builtins.attrValues linuxSystems;
    forAllSystems = func: (nixpkgs.lib.genAttrs allSystems func);
  in {
    lib.neovimConfiguration = {system}:
      (nvf.lib.neovimConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [./default.nix];
      }).neovim;

    packages = forAllSystems (system: {
      default = self.lib.neovimConfiguration {inherit system;};
      nvim = self.lib.neovimConfiguration {inherit system;};
    });
  };
}
