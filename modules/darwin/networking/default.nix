_: {
  networking = {
    knownNetworkServices = ["Wi-Fi" "Thunderbolt Ethernet Slot 0"];
    dns = [
      # Tailscale
      "100.100.100.100"
      # NextDNS
      "45.90.28.65"
      "45.90.30.65"
      "2a07:a8c0::9c:b526"
      "2a07:a8c1::9c:b526"
      # Fallback
      "9.9.9.9"
    ];
  };
}
