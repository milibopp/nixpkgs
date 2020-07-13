{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "oneshot";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "raphaelreyna";
    repo = "oneshot";
    rev = "v${version}";
    sha256 = "11v6ljp645hp0fh16s1azxxj6644hrq8j1varwycapyyn0661azs";
  };

  goPackagePath = "github.com/raphaelreyna/oneshot";
  vendorSha256 = "02y4pblsl6f069hm521f8pzdrhkgrs5qh49zj6xc3bjm6av1pamm";

  subPackages = [ "." ];

  meta = with lib; {
    description = "A first-come-first-serve single-fire HTTP server";
    homepage = "https://github.com/raphaelreyna/oneshot";
    license = licenses.mit;
    maintainers = with maintainers; [ edibopp ];
    platforms = platforms.all;
  };
}
