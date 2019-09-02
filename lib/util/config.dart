class AppConfig {
  final bool useFingerprint;
  final bool runOnWeb;

  AppConfig({
    this.useFingerprint = false,
    this.runOnWeb = false,
  });

  @override
  String toString() {
    return '$runtimeType(useFingerprint: $useFingerprint, runOnWeb: $runOnWeb)';
  }
}
