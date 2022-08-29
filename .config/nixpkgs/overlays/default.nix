self: super:

{
  yabai = super.yabai.overrideAttrs (o: rec {
    version = "4.0.2";
    src = builtins.fetchTarball {
      url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
      sha256 = "00nxzk1g0hd8jqd1r0aig6wdsbpk60551qxnvvqb9475i8qbzjf6";
    };


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
