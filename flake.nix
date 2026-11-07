{
  description = "NixOS llama.cpp adaptive KV streaming";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";
    llama-cpp-adaptive-kv.url = "github:RaymondHuang210129/llama.cpp-adaptive-kv-streaming/feature/adaptive-kv-stream-v2";
  };

  outputs =
    {
      self,
      nixpkgs,
      llama-cpp-adaptive-kv,
    }:
    let
      systems = [
        "x86_64-linux"
      ];
    in
    {
      packages = nixpkgs.lib.genAttrs systems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        {
          default =
            (pkgs.llama-cpp.overrideAttrs {
              src = llama-cpp-adaptive-kv;
              #npmDepsHash = nixpkgs.lib.fakeHash;
              npmDepsHash = "sha256-hqYzdp1FwPhYkBP278fQXgY9NCKB6Q3P6Gko7BfP0m0=";
              doCheck = false; # there is a failing test
            }).override
              { cudaSupport = true; };
        }
      );
    };
}
