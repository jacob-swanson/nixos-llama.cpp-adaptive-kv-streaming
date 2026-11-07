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
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    in
    {
      packages = nixpkgs.lib.genAttrs systems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          llama-cpp-adaptive-kv = pkgs.llama-cpp.overrideAttrs {
            src = llama-cpp-adaptive-kv;
          };

          default = pkgs.llama-cpp.overrideAttrs {
            src = llama-cpp-adaptive-kv;
          };
        }
      );
    };
}
