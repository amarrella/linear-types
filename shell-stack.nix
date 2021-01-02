{ system ? builtins.currentSystem
, pkgs ?  import ./nixpkgs.nix { inherit system; }
, ghc ? pkgs.haskell.compiler.ghcHEAD
}:

with pkgs;

haskell.lib.buildStackProject {
  name = "linear-types";
  buildInputs = [ git zlib ];
  ghc = pkgs.haskell.compiler.ghcHEAD;
  LANG = "en_US.utf8";
}
