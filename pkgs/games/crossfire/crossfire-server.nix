{ pkgs, stdenv, fetchsvn, autoreconfHook, version, rev, sha256, maps, arch }:

stdenv.mkDerivation rec {
  version = "r${toString rev}";
  name = "crossfire-server-${version}";

  src = fetchsvn {
    url = "http://svn.code.sf.net/p/crossfire/code/server/trunk/";
    sha256 = sha256;
    rev = rev;
  };

  nativeBuildInputs = with pkgs; [autoconf automake libtool flex perl check pkg-config];
  hardeningDisable = [ "format" ];

  preConfigure = ''
    ln -s ${arch} lib/arch
    sh autogen.sh --help
  '';

  configureFlags = ["--with-python=${pkgs.python2}"];

  postInstall = ''
    ln -s ${maps} "$out/share/crossfire/maps"
  '';

  meta = with stdenv.lib; {
    description = "Server for the Crossfire free MMORPG";
    homepage = "http://crossfire.real-time.com/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
