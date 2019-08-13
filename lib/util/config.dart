class AppConfig {
  final bool useFingerprint;

  AppConfig({
    this.useFingerprint,
  });

  @override
  String toString() {
    return '$runtimeType(useFingerprint: $useFingerprint)';
  }
}
