{
  zramSwap = {
    enable = true;
    priority = 5;
    algorithm = "zstd";
    swapDevices = 1;
    memoryPercent = 50;
  };
}
