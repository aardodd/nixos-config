# Custom development shell templates using nix-flakes.
# You can initialize them in the current directory using
# 'nix flake init --template github:aardodd/nixos-config#${ENV}'
# or in a custom directory using
# 'nix flake new --template github:aardodd/nixos-config#${ENV} ${DIRECTORY}'

{
  rust = {
    description = "Rust development environment";
    path = ./rust;
  };

  rust-toolchain = {
    description = "Rust toolchain development environment";
    path = ./rust-toolchain;
  };

  node = {
    description = "Node development environment";
    path = ./node;
  };
}
