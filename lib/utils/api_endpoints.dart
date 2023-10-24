class ApiEndPoints {
  static final String baseUrl = 'https://vstserver.com/';
  static _AuthEndPoints authEndPoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String loginEmail = 'login';
  final String register = 'register';
  final String requestOtp = 'request_otp';
  final String verifyOtp = 'verify_otp';
  final String forgotPassword = 'forgot_password';
}
