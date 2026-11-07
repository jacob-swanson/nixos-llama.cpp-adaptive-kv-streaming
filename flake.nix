{
  description = "NixOS llama.cpp adaptive KV streaming";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";
    llama-cpp-adaptive-kv.url = "github:RaymondHuang210129/llama.cpp-adaptive-kv-streaming/feature/adaptive-kv-stream-v2";
  };

  nixConfig = {
    extra-substituters = [ "https://cache.nixos-cuda.org" ];
    extra-trusted-public-keys = [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];
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
            config.cudaCapabilities = [ "8.9" ];
          };
        in
        {
          default =
            (pkgs.llama-cpp.overrideAttrs (old: {
              src = llama-cpp-adaptive-kv;
              #npmDepsHash = nixpkgs.lib.fakeHash;
              npmDepsHash = "sha256-hqYzdp1FwPhYkBP278fQXgY9NCKB6Q3P6Gko7BfP0m0=";
              doCheck = false; # there is a failing test
              # Reduce peak memory use to prevent out of memory errors
              ninjaFlags = (old.ninjaFlags or [ ]) ++ [ "-j4" ];
              cmakeFlags = (old.cmakeFlags or [ ]) ++ [
                (nixpkgs.lib.cmakeFeature "CMAKE_CUDA_FLAGS" "--threads=1")
              ];
            })).override
              {
                cudaSupport = true;
                cpuArchDynamicDispatch = false; # skip building all CPU variants
              };
        }
      );
    };
}
