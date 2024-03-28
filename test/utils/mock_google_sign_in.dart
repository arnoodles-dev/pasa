import 'package:google_sign_in/google_sign_in.dart';

class MockGoogleSignIn implements GoogleSignIn {
  MockGoogleSignInAccount? _currentUser;

  bool _isCancelled = false;

  /// Used to simulate google login cancellation behaviour.
  // ignore: avoid_setters_without_getters
  set isCancelled(bool value) => _isCancelled = value;

  @override
  GoogleSignInAccount? get currentUser => _currentUser;

  @override
  Future<GoogleSignInAccount?> signIn() {
    _currentUser = MockGoogleSignInAccount();
    return Future<MockGoogleSignInAccount?>.value(
      _isCancelled ? null : _currentUser,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockGoogleSignInAccount implements GoogleSignInAccount {
  @override
  Future<GoogleSignInAuthentication> get authentication =>
      Future<GoogleSignInAuthentication>.value(
        MockGoogleSignInAuthentication(),
      );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockGoogleSignInAuthentication implements GoogleSignInAuthentication {
  @override
  String get idToken => 'idToken';

  @override
  String get accessToken => 'accessToken';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
