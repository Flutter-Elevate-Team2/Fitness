abstract class AuthLocalDataSourceContract {
  Future<void> saveToken(String token);

  Future<String?> getToken();

  Future<void> clearUserData();
}
