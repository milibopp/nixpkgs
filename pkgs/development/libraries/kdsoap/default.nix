{ stdenv
, lib
, fetchurl
, cmake
, qtbase
, wrapQtAppsHook
}:

let
  isQt6 = lib.versions.major qtbase.version == "6";
  cmakeName = if isQt6 then "KDSoap-qt6" else "KDSoap";
in stdenv.mkDerivation rec {
  pname = "kdsoap";
  version = "2.1.1";

  src = fetchurl {
    url = "https://github.com/KDAB/KDSoap/releases/download/kdsoap-${version}/kdsoap-${version}.tar.gz";
    sha256 = "sha256-rtV/ayAN33YvXSiY9+kijdBwCIHESRrv5ABvf6X1xic=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake wrapQtAppsHook ];

  buildInputs = [ qtbase ];

  cmakeFlags = [ (lib.cmakeBool "KDSoap_QT6" isQt6) ];

  postInstall = ''
    moveToOutput bin/kdwsdl2cpp* "$dev"
    sed -i "$out/lib/cmake/${cmakeName}/KDSoapTargets.cmake" \
        -e "/^  INTERFACE_INCLUDE_DIRECTORIES/ c   INTERFACE_INCLUDE_DIRECTORIES \"$dev/include\""
    sed -i "$out/lib/cmake/${cmakeName}/KDSoapTargets-release.cmake" \
        -e "s@$out/bin@$dev/bin@"
  '';

  meta = with lib; {
    description = "A Qt-based client-side and server-side SOAP component";
    longDescription = ''
      KD Soap is a Qt-based client-side and server-side SOAP component.

      It can be used to create client applications for web services and also
      provides the means to create web services without the need for any further
      component such as a dedicated web server.
    '';
    license = with licenses; [ gpl2 gpl3 lgpl21 ];
    maintainers = [ maintainers.ttuegel ];
  };
}
