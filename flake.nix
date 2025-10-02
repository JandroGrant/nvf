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
    ...
  } @ inputs: {
    packages."x86_64-linux" = let
      neovimConfigured = inputs.nvf.lib.neovimConfiguration {
        inherit (nixpkgs.legacyPackages."x86_64-linux") pkgs;
        modules = [
          ./default.nix
        ];
      };
    in {
      default = neovimConfigured.neovim;
    };
  };
}
