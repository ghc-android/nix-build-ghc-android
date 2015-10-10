{ pkgs ? (import <nixpkgs>{}) }:

with pkgs;

let hsenv = haskell.packages.ghc7102.ghcWithPackages
              (p: with p; [cabal-install network-simple monad-loops text-binary ]);

    haskell-packages = import ./nixpkgs/top-level/haskell-packages.nix { inherit pkgs callPackage stdenv; };
    
    ghc-android-env = haskell-packages.packages.ghc-android.ghcWithPackages
                        (p: with p; [network-simple monad-loops text-binary ] ); 
    

    ndkWrapper = import ./ndk-wrapper.nix { inherit stdenv makeWrapper androidndk; };

in stdenv.mkDerivation {
     name = "ghc-android-shell";

     buildInputs = [ hsenv ghc-android-env ndkWrapper jdk.home ]; #hsenv

     shellHook = ''
       export JAVA_HOME=${jdk.home}
     #  export PATH=${ndkWrapper}/bin:$PATH
     #  export NIX_GHC="${hsenv}/bin/ghc"
     #  export NIX_GHCPKG="${hsenv}/bin/ghc-pkg"
     #  export NIX_GHC_DOCDIR="${hsenv}/share/doc/ghc/html"
     #  export NIX_GHC_LIBDIR=$( $NIX_GHC --print-libdir )
     '';
     

}