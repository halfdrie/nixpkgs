{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, wrapQtAppsHook

, qtbase
, qttools
, qtsvg
, qtimageformats

, exiv2
, opencv4
, libraw
, libtiff
, quazip
}:

stdenv.mkDerivation rec {
  pname = "nomacs";
  version = "3.17.2285";

  src = fetchFromGitHub {
    owner = "nomacs";
    repo = "nomacs";
    rev = version;
    hash = "sha256-/K7LRPwNy2PG7tIGD0tiKnEOPZ491lxFRlgf4xWYtxs=";
  };

  setSourceRoot = ''
    sourceRoot=$(echo */ImageLounge)
  '';

  nativeBuildInputs = [cmake
                       pkg-config
                       wrapQtAppsHook];

  buildInputs = [qtbase
                 qttools
                 qtsvg
                 qtimageformats
                 exiv2
                 opencv4
                 libraw
                 libtiff
                 quazip];

  cmakeFlags = ["-DENABLE_OPENCV=ON"
                "-DENABLE_RAW=ON"
                "-DENABLE_TIFF=ON"
                "-DENABLE_QUAZIP=ON"
                "-DENABLE_TRANSLATIONS=ON"
                "-DUSE_SYSTEM_QUAZIP=ON"];

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/lib
    mv $out/libnomacsCore.dylib $out/lib/libnomacsCore.dylib
  '';

  meta = with lib; {
    homepage = "https://nomacs.org";
    description = "Qt-based image viewer";
    maintainers = with lib.maintainers; [ mindavi ];
    license = licenses.gpl3Plus;
    inherit (qtbase.meta) platforms;
  };
}
