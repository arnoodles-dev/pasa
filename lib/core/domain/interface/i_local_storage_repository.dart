abstract interface class ILocalStorageRepository {
  Future<String?> getAccessToken();
  Future<void> setAccessToken(String? accessToken);

  Future<String?> getIdToken();
  Future<void> setIdToken(String? idToken);

  Future<bool?> getIsOnboardingDone();
  Future<void> setIsOnboardingDone();
}
