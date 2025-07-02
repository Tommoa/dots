self: super: {
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