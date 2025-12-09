{
  leo,
  mkShell,
  snarkos-testnet,
}:
mkShell {
  inputsFrom = [
    leo
  ];
  buildInputs = [
    snarkos-testnet
  ];
  env = {
    inherit (snarkos-testnet) LIBCLANG_PATH;
  };
}
