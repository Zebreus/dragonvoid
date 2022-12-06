{ pkgs ? import <nixpkgs> { }
}:

pkgs.stdenv.mkDerivation {
  name = "dragonvoid";
  src = ./.;

  nativeBuildInputs = [ pkgs.adoptopenjdk-jre-openj9-bin-8 pkgs.makeWrapper pkgs.unzip pkgs.mktemp ];

  installPhase = ''
    mkdir -p $out/lib
    mkdir -p $out/bin
    cp $src/DragonVoid.jar $out/lib

    cat <<EOF > $out/bin/dragonvoid
    #/usr/bin/env sh

    # The saves are stored inside the resource directory.
    # We copy the resources to a temporary directory and link to a saves directory in your home folder
    SAVE_DIR=''${SAVE_DIR-"\$HOME/.dragonvoid/"}
    WORK_DIR=\$(${pkgs.mktemp}/bin/mktemp -d)
    cd \$WORK_DIR 
    ${pkgs.unzip}/bin/unzip -q $out/lib/DragonVoid.jar "res/*" -d \$WORK_DIR
    if ! test -e "\$SAVE_DIR"
    then
        mkdir -p "\$SAVE_DIR"
        cp -r \$WORK_DIR/res/saves/* "\$SAVE_DIR"
    fi
    rm -rf \$WORK_DIR/res/saves
    ln -s "\$SAVE_DIR" \$WORK_DIR/res/saves
    ${pkgs.adoptopenjdk-jre-openj9-bin-8}/bin/java -cp $out/lib/DragonVoid.jar tbs.StartMainMenu
    EOF

    cat <<EOF > $out/bin/dragonvoid-arena
    #/usr/bin/env sh

    # The saves are stored inside the resource directory.
    # We copy the resources to a temporary directory and link to a saves directory in your home folder
    SAVE_DIR=''${SAVE_DIR-"\$HOME/.dragonvoid/"}
    WORK_DIR=\$(${pkgs.mktemp}/bin/mktemp -d)
    cd \$WORK_DIR 
    ${pkgs.unzip}/bin/unzip -q $out/lib/DragonVoid.jar "res/*" -d \$WORK_DIR
    if ! test -e "\$SAVE_DIR"
    then
        mkdir -p "\$SAVE_DIR"
        cp -r \$WORK_DIR/res/saves/* "\$SAVE_DIR"
    fi
    rm -rf \$WORK_DIR/res/saves
    ln -s "\$SAVE_DIR" \$WORK_DIR/res/saves
    ${pkgs.adoptopenjdk-jre-openj9-bin-8}/bin/java -cp $out/lib/DragonVoid.jar tbs.StartArenaMode
    EOF

    chmod 755 $out/bin/dragonvoid-arena
    chmod 755 $out/bin/dragonvoid
  '';
}
