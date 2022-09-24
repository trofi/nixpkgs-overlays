{ lib
, stdenv
, fetchFromGitLab
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "hid-tools";
  version = "unstable-2022-08-10";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "libevdev";
    repo = "hid-tools";
    rev = "cea52b33e39a94cde773373257a69ecce7afc520";
    hash = "sha256-eA+ry3S2d+nJ5ILrkxPF9Ew5MdcX6yRO4ZrMJv5yVRM=";
  };

  checkInputs = with python3.pkgs; [
    libevdev
    pytest
    pyudev
  ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    parse
    pyyaml
  ];

  meta = with lib; {
    description = "Python scripts to manipulate HID data.";
    homepage = "https://gitlab.freedesktop.org/libevdev/hid-tools";
    license = licenses.gpl2;
    maintainers = with maintainers; [ trofi ];
    platforms = platforms.linux;
  };
}
