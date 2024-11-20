{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, cargo
, cargo-c
, pkg-config
, rustc
, rust
}:

rustPlatform.buildRustPackage rec {
  pname = "hyper-ffi";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "hyperium";
    repo = "hyper";
    rev = "ffi-cargo-c";
    hash = "sha256-j2ZRQBca1YyRw32zCmX4/RQdWjXF/1zyF6MdB1G9KZI=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    cp ${./Cargo.lock} ./Cargo.lock
  '';

  env = {
    RUSTFLAGS = "--cfg hyper_unstable_ffi";
  };

  buildPhase = ''
    runHook preBuild
    ${rust.envVars.setEnv} cargo cbuild -j $NIX_BUILD_CORES --features client,http1,http2,ffi --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    ${rust.envVars.setEnv} cargo cinstall -j $NIX_BUILD_CORES --features client,http1,http2,ffi --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
    runHook postInstall
  '';

  # TODO: use `cargo ctest` when it's available, does not work upstream yet
  checkPhase = ''
    runHook preCheck
    ${rust.envVars.setEnv} cargo test -j $NIX_BUILD_CORES --features full --release --frozen
    runHook postCheck
  '';

  nativeBuildInputs = [ cargo-c ];

  meta = with lib; {
    description = "Hyper FFI bindings";
    homepage = "https://hyper.rs/";
    license = with lib.licenses; [ mit ];
    maintainers = [];
  };
}
