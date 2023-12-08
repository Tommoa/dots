self: super:

{
  yabai = super.yabai.overrideAttrs (o: rec {
    version = "6.0.1";
    src = builtins.fetchTarball {
      url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
      sha256 = "08cs0h4x1ah3ipyj2dgskbpciwqfddc3ax8z176cadylr9svjrf0";
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
