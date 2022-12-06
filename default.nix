{ pkgs ? import <nixpkgs> { }
}:

pkgs.stdenv.mkDerivation {
  name = "dragonvoid";
  src = ./.;

  nativeBuildInputs = [ pkgs.adoptopenjdk-jre-openj9-bin-8 ];

  installPhase = ''
    ls $src
    mkdir -p $out/lib
    mkdir -p $out/usr/bin
    cp $src/DragonVoid.jar  $out/lib
    cat <<EOF > $out/usr/bin/dragonvoid
    #/usr/bin/env sh
    
    java -cp $out/lib/DragonVoid.jar tbs.StartArenaMode
    EOF
    chmod 755 $out/usr/bin/dragonvoid
  '';
}
