self: super:

{
  yabai = super.yabai.overrideAttrs (o: rec {
    version = "7.1.4";
    src = builtins.fetchTarball {
      url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
      sha256 = "1cvvw5f5dg17vqhsrxqzd9wljdvfjibqg895jy3i7xacg7cqd77w";
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
