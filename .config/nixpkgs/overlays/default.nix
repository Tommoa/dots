self: super:

{
  yabai = super.yabai.overrideAttrs (o: rec {
    version = "7.1.15";
    src = builtins.fetchTarball {
      url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
      sha256 = "1qz143jyw9nfxdjgqjf8qqbjm2gd8nsa98x8rfz0xvkdzvzasca0";
    };

    postPatch = '''';

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/man/man1/
      cp ./bin/yabai $out/bin/yabai
      cp ./doc/yabai.1 $out/share/man/man1/yabai.1
    '';
  });
  whatsapp-for-mac = super.whatsapp-for-mac.overrideAttrs (o: rec {
    version = "2.25.17.82";
    src = super.fetchzip {
      extension = "zip";
      name = "WhatsApp.app";
      url = "https://web.whatsapp.com/desktop/mac_native/release/?version=${version}&extension=zip&configuration=Release&branch=relbranch";
      hash = "sha256-PBQZ8KPe3uK9M/YpgHKlljPdzl0W48mBrSuNNUgM9YQ=";
    };
  });
}
