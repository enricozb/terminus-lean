# from: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/data/fonts/terminus-font/default.nix#L32

{
  lib,
  stdenv,
  fetchurl,
  python3,
  bdftopcf,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "terminus-font";
  version = "5.0.0";

  src = ./.;

  patches = [ ./SOURCE_DATE_EPOCH-for-otb.patch ];

  nativeBuildInputs = [
    python3
    bdftopcf
    xorg.mkfontscale
  ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace Makefile --replace 'fc-cache' '#fc-cache'
    substituteInPlace Makefile --replace 'gzip'     'gzip -n'
  '';

  installTargets = [
    "install"
    "install-otb"
    "fontdir"
  ];

  # fontdir depends on the previous two targets, but this is not known
  # to make, so we need to disable parallelism:
  enableParallelInstalling = false;
}
