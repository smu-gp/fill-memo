class User {
  final String uid;
  final String displayName;
  final String email;

  User({
    this.uid,
    this.displayName,
    this.email,
  });

  @override
  String toString() {
    return "$runtimeType(uid: $uid, displayName: $displayName, email: $email)";
  }
}
