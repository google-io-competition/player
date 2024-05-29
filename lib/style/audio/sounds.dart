List<String> soundTypeToFilename(SfxType type) => switch (type) {
  SfxType.huhsh => const [
  ],
  SfxType.wssh => const [
  ],
  SfxType.buttonTap => const [
  ],
  SfxType.congrats => const [
  ],
  SfxType.erase => const [
  ],
  SfxType.swishSwish => const [
  ]
};

/// Allows control over loudness of different SFX types.
double soundTypeToVolume(SfxType type) {
  switch (type) {
    case SfxType.huhsh:
      return 0.4;
    case SfxType.wssh:
      return 0.2;
    case SfxType.buttonTap:
    case SfxType.congrats:
    case SfxType.erase:
    case SfxType.swishSwish:
      return 1.0;
  }
}

enum SfxType {
  huhsh,
  wssh,
  buttonTap,
  congrats,
  erase,
  swishSwish,
}
