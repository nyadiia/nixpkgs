{ stdenv
, fetchFromGitHub
, pkg-config
, libtool
, automake
, autoconf
, autoreconfHook
, libxml2
, libusb1
}:
stdenv.mkDerivation rec {
  pname = "libvitamtp";
  version = "2.5.9";

  src = fetchFromGitHub {
    owner = "codestation";
    repo = "vitamtp";
    rev = "v${version}";
    hash = "sha256-yKlfy+beEd0uxfWvMCA0kUGhj8lkuQztdSz6i99xiSU=";
  };

  nativeBuildInputs = [
    pkg-config
    libtool
    automake
    autoconf
    autoreconfHook
  ];

  buildInputs = [
    libxml2
    libusb1
  ];

  postInstall = ''
    install -Dm644 debian/libvitamtp5.udev "$out/lib/udev/rules.d/60-psvita.rules"
  '';
}
