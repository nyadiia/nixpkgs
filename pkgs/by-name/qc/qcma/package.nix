{ stdenv
, lib
, fetchFromGitHub
, wrapQtAppsHook
, qtbase
, qttools
, libxml2
, libusb1
, autoreconfHook
, pkg-config
, libtool
, automake
, autoconf
, libnotify
, git
, qmake
, libvitamtp
}:

stdenv.mkDerivation rec {
  pname = "qcma";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "codestation";
    repo = "qcma";
    rev = "v${version}";
    hash = "sha256-eZ6ww01xaFSsD21PdInV2UXSNrYgfZEFzX9Z2c+TmZc=";
  };

  nativeBuildInputs = [
    wrapQtAppsHook
    pkg-config
    qtbase
    qttools
    qmake
  ];

  buildInputs = [
    libvitamtp
    libnotify
  ];

  postPatch = ''
    substituteInPlace config.pri \
      --replace-fail 'QCMA_GIT_VERSION=''$$system(git describe --tags)' 'QCMA_GIT_VERSION="${version}"'
  '';

  qmakeFlags = [
    "CONFIG+=DISABLE_FFMPEG"
  ];

  preBuild = ''
    lrelease common/resources/translations/*.ts
  '';

  postInstall = ''
    install -Dm644 ${libvitamtp}/lib/udev/rules.d/60-psvita.rules "$out/lib/udev/rules.d/60-psvita.rules"
  '';

  meta = with lib; {
    description = "Cross-platform content manager assistant for the PS Vita";
    homepage = "https://codestation.github.io/qcma/";
    maintainers = with maintainers; [ nyadiia ];
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
  };
}
