{
  zramSwap = {
    enable = true;
    priority = 5;
    algorithm = "zstd";
    numDevices = 1;
    swapDevices = 1;
    memoryPercent = 50;
  };
}