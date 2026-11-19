{ stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "codex";
  version = "0.170.0";

  src = fetchurl {
    url = "https://github.com/openai/codex/releases/download/rust-v${finalAttrs.version}/codex-aarch64-apple-darwin.tar.gz";
    hash = "sha256-fJ8h1cuuSGDRSzef3PcJ/zmc6HT9cUtYeD4bQZnCuak=";
  };

  sourceRoot = ".";
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 codex-aarch64-apple-darwin "$out/bin/codex"
    runHook postInstall
  '';

  meta.platforms = [ "aarch64-darwin" ];
  meta.mainProgram = "codex";
})
