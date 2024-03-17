abstract interface class ILocalStorageRepository {
  Future<String?> getAccessToken();
  Future<bool> setAccessToken(String? accessToken);

  Future<String?> getRefreshToken();
  Future<bool> setRefreshToken(String? refreshToken);

  Future<String?> getLastLoggedInEmail();
  Future<bool> setLastLoggedInEmail(String? emailAddress);

  Future<bool?> getIsOnboardingDone();
  Future<bool> setIsOnboardingDone();
}
