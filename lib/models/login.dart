import 'package:device_info_plus/device_info_plus.dart';

class LoginPost {
  final double phoneNumber;
  final String password;

  final BaseDeviceInfo deviceName;
  LoginPost({
    required this.phoneNumber,
    required this.password,
    required this.deviceName,
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
