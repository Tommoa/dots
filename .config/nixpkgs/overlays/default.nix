self: super:

{
  yabai = super.yabai.overrideAttrs (o: rec {
    version = "3.3.6";
    src = builtins.fetchTarball {
      url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
      sha256 = "00iblhdx89wyvasl3hm95w91z4mrwb7pbfdvg9cmpcnqphbfs5ld";
    };

    
    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/man/man1/
      cp ./archive/bin/yabai $out/bin/yabai
      cp ./archive/doc/yabai.1 $out/share/man/man1/yabai.1
    '';
  });

  goimapnotify = super.goimapnotify.overrideAttrs (o: rec {
    meta.platforms = super.stdenv.lib.platforms.darwin;
  });
}
