class ApiEndPoints {
  static const String baseUrl = 'https://vstserver.com/';
  static _AuthEndPoints authEndPoints = _AuthEndPoints();
  static const String servicesUrl = 'https://vstserver.com/services/';
}

class _AuthEndPoints {
  final String loginEmail = 'login';
  final String register = 'register';
  final String requestOtp = 'request_otp';
  final String verifyOtp = 'verify_otp';
  final String forgotPassword = 'forgot_password';
  final String getStuffs = "get_stuffs";
  final String postStuffs = "post_stuff";
  final String uploadJobPhoto = "upload_job_photo";
  final String getOtherfee = "get_otherfee";
  final String soldOut = 'sold_out';
  final String logout = 'logout';
  final String updateInfo = 'update_info';
  final String changeAvatar = 'change_avatar';
  final String getNotis = 'get_notis';
  final String getJobType = 'get_job_type';
  final String getVouchersValid = 'get_vouchers_valid';
  final String getNews = 'get_newss';
  final String getJobItem = 'get_jobitem';
  final String getJobService = 'get_jobservice';
  final String getPriceV2 = 'get_price_v2';
  final String bookJobV3 = 'book_job_v3';
  final String getHostJobs = 'get_host_jobs';
  final String getAJob = 'get_a_job';
  final String getPostJobs = 'get_post_jobs';
  final String applyJob = 'apply_job';
  final String acceptWorker = 'accept_worker';
  final String workerDone = 'worker_done';
  final String hostDone = 'host_done';
  final String workerRate = 'worker_rate';
  final String hostRate = 'host_rate';
  final String statistics = 'statistics';
  final String statisticsUser = 'statistics_user';
  final String getWorkerJobs = 'get_worker_jobs';
  final String getAUser = 'get_a_user';
  final String deactiveUser = 'deactive_user';
  final String activeUser = 'active_user';
  final String requestOtpAccount = 'request_otp';
  final String getOrdersUser = 'get_orders_user';
  final String getJobsByType2 = 'get_jobs_by_type_2';
  final String getAStuff = 'get_stuff';
  final String getWorkerByLocation = 'get_worker_by_location';
  final String uploadCcidPhoto = 'upload_ccid_photo';
  final String uploadCertPhoto = 'upload_cert_photo';
  final String registerWorker = 'register_worker_2';
  final String getReg = 'get_reg';
  final String uploadAvatarPhoto = 'upload_avatar_photo';
}
