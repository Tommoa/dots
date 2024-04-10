self: super:

{
  yabai = super.yabai.overrideAttrs (o: rec {
    version = "7.1.0";
    src = builtins.fetchTarball {
      url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
      sha256 = "0gjlxgb2rfxryvg49nwwv01vh8d8pmni9v1873f0wv635skj9jl3";
    };

    postPatch = '''';

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/man/man1/
      cp ./bin/yabai $out/bin/yabai
      cp ./doc/yabai.1 $out/share/man/man1/yabai.1
    '';
  });

  goimapnotify = super.goimapnotify.overrideAttrs (o: rec {
    meta.platforms = super.pkgs.lib.platforms.darwin;
  });
}
