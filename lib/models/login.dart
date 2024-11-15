import 'package:device_info_plus/device_info_plus.dart';

class LoginPost {
  final String phoneNumber;
  final String password;
  final String wallet;
  // final BaseDeviceInfo deviceName;
  final String workerAuthen;
  final String profileImage;
  final String type;
  final String name;
  final String status;
  final String address;
  final String regProfile;
  LoginPost({
    required this.name,
    required this.wallet,
    required this.phoneNumber,
    required this.password,
    // required this.deviceName,
    required this.profileImage,
    required this.type,
    required this.workerAuthen,
    required this.status,
    required this.address,
    required this.regProfile,
  });
}
//   final Dio _dio = Dio();

//   //  Future<Response> registerUser() async {
//   //       //IMPLEMENT USER REGISTRATION
//   //   }

//   Future<Response> login(
//     double phoneNumber,
//     String password,
//     String deviceName,
//   ) async {
//     try {
//       Response response = await _dio.post(
//         'https://vstserver.com/login',
//         data: {'user_id': phoneNumber, 'password': password, 'device': deviceName},
//       );
//       //returns the successful user data json object
//       print(response.data);
//       return response.data;
//     } on DioException catch (e) {
//       //returns the error object if any
//       print(e.response!.data);
//       return e.response!.data;
//     }
//   }
//   // Future<Response> getUserProfileData() async {
//   //     //GET USER PROFILE DATA
//   // }

//   // Future<Response> logout() async {
//   //     //IMPLEMENT USER LOGOUT
//   //  }
// }
