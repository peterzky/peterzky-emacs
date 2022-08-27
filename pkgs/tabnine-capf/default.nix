{ trivialBuild, fetchFromGitHub, dash, s, unicode-escape }:
trivialBuild {
  pname = "tabnine-capf";
  src = fetchFromGitHub {
    owner = "50ways2sayhard";
    repo = "tabnine-capf";
    rev = "b1079368498c09fb4e49367a5d6e5e04a061eaf9";
    sha256 = "1wn0ysjhj3izpfkmxx3ang1xr5ss1v5grbhhcmqmj3f5s7grvfz3";
    # date = "2022-05-26T10:06:05+08:00";
  };

  packageRequires = [ dash s unicode-escape ];
}
