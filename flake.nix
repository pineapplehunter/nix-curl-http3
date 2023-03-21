{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      curl-http3-overlay =
        (prev: final: {
          curl-http3 = prev.curl.override {
            http3Support = true;
            openssl = prev.quictls;
          };
        });
    in
    { overlays.default = curl-http3-overlay; } //
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; overlays = [ self.overlays.default ]; };
      in
      {
        packages.default = pkgs.curl-http3;
        formatter = pkgs.nixpkgs-fmt;
      });
}
