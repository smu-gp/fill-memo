class AppConfig {
  /// Static config constants
  static const bool runOnWeb = false;

  /// Runtime config constants
  final bool useFingerprint;

  AppConfig({
    this.useFingerprint = false,
  });

  @override
  String toString() {
    return '$runtimeType(useFingerprint: $useFingerprint)';
  }
}
