//import 'package:aifa_control_app/model/device.dart';
import 'package:upyong_test/lib/secure_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ApiService {
  final String _baseUrl = 'https://api.wificontrolbox.com';
  final String _clientId = 'Ecp5TUQxtOjdQ24u';

  Dio _dio = Dio();
  final SecureStorageService _secureStorageService = SecureStorageService();

  ApiService() {
    _dio = Dio(BaseOptions(
        baseUrl: _baseUrl, connectTimeout: const Duration(seconds: 5)));
    _dio.interceptors
        .add(LogInterceptor(responseBody: true)); // For debugging purposes
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) async {
        // Add the access token to the headers
        final accessToken = await _secureStorageService
            .getAccessToken(); // Replace with your logic
        options.headers['Authorization'] = 'Bearer $accessToken';
        print("accessToken:成功的$accessToken");
        return handler.next(options);
      },
      onError: (DioException e, ErrorInterceptorHandler handler) async {
        if (e.response?.statusCode == 401) {
          final responseData = e.response?.data;
          if (responseData != null && responseData['name'] == 'JWT_EXPIRED') {
            // Token expired, trigger token refresh and retry the original request
            final newAccessToken = await _refreshTokenIfNeeded();
            e.requestOptions.headers['Authorization'] =
            'Bearer $newAccessToken';
            print("newAccessToken:刷新後$newAccessToken");
            return handler.resolve(await _dio.fetch(e.requestOptions));
          }
        }
        return handler.next(e);
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        // Do something with response data.
        // If you want to reject the request with a error message,
        // you can reject a `DioException` object using `handler.reject(dioError)`.
        return handler.next(response);
      },
    ));
  }

  Future<Response<dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/v1/user/auth',
        data: {
          'email': email,
          'password': password,
          'grant_type': 'password',
          'client_id': _clientId
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        _secureStorageService.saveAccessToken(responseData['access_token']);
        _secureStorageService.saveRefreshToken(responseData['refresh_token']);
        print("accessToken:登入後$responseData['access_token']");

      }

      return response;
    } catch (error) {
      throw Exception('Failed to login');
    }
  }

  Future<int?> checkUser(String email) async {
    try {
      final response = await _dio.post(
        '/v1/user/check',
        data: {
          'email': email
        },
      );

      return response.statusCode;
    } on DioException catch (error) {
      if (error.response != null ) {
        return error.response?.statusCode;
      }else {
        throw Exception('Failed to check');
      }
    }
  }

  Future<Response<dynamic>> register(String email, String password) async {
    try {
      final response = await _dio.post(
        '/v1/user/register',
        data: {
          'email': email,
          'password': password,
          'username': '',
          'phone': '',
          'avatar': ''
        },
      );

      return response;
    } catch (error) {
      throw Exception('Failed to login');
    }
  }

  bool isAccessTokenExpired(String accessToken) {
    final decodedToken =
    JwtDecoder.decode(accessToken); // Assuming you're using JW

    final expirationTimestamp = decodedToken['exp'] as int;
    final currentTimestamp =
        DateTime.now().millisecondsSinceEpoch ~/ 1000; // Convert to seconds

    return expirationTimestamp < currentTimestamp;
  }

  Future<String> _refreshTokenIfNeeded() async {
    final accessToken = await _secureStorageService.getAccessToken();
    // Simulate checking if token needs refreshing
    if (isAccessTokenExpired(accessToken)) {
      final refreshToken = await _secureStorageService
          .getRefreshToken(); // Replace with your logic

      try {
        final response = await _dio.post(
          '/oauth2/token',
          data: {
            'refresh_token': refreshToken,
            'client_id': _clientId,
            'grant_type': 'refresh_token'
          },
        );

        if (response.statusCode == 200) {
          final responseData = response.data as Map<String, dynamic>;
          final newAccessToken = responseData['access_token'];
          final newRefreshToken = responseData['refresh_token'];

          // Update the access token for future requests
          _dio.options.headers['Authorization'] = 'Bearer $newAccessToken';
          _secureStorageService.saveAccessToken(newAccessToken);
          _secureStorageService.saveRefreshToken(newRefreshToken);
          return newAccessToken;
        } else {
          throw Exception('Failed to refresh token');
        }
      } catch (error) {
        throw Exception('Failed to refresh token');
      }
    }
    return accessToken;
  }

  Future<void> addDevice(String inMac) async {
    final SecureStorageService secureStorageService = SecureStorageService();
    final accessToken = await secureStorageService.getAccessToken();
    final response = await _dio.post(
      '/devices',
      data: {
        'mac': inMac,
      },
      // options: Options(
      //   headers: {'Authorization':'Bearer $accessToken'}, // 手动添加头部
      // ),
    );
    if (response.statusCode == 201) {
      return response.data;
    } else {
      print('HTTP Status: ${response.statusCode}');
      throw Exception('Failed to add device');
    }
    }

  // Future<List<Device>> getDevices() async {
  //   try {
  //     final response = await _dio.get('/devices');
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> data = response.data;
  //
  //       final List<dynamic> deviceList = data['devices'];
  //       final devices =
  //       deviceList.map((json) => Device.fromJson(json)).toList();
  //       return devices; //顯示模型裡面印射出來的列表
  //     } else {
  //       print('HTTP Status: ${response.statusCode}');
  //       throw Exception('Failed to get devices');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     throw Exception('Failed to get devices');
  //   }
  // }
  //
  // Future<void> delsubDevice(int id) async {
  //   try {
  //     final response = await _dio.delete('/sub-devices/$id');
  //     if (response.statusCode == 200) {
  //       print('Device deleted successfully');
  //     } else {
  //       print('HTTP Status: ${response.statusCode}');
  //       throw Exception('Failed to get devices');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     throw Exception('Failed to get devices');
  //   }
  // }
  //
  // Future<void> addsubDevice(int subid) async {
  //   try {
  //     List<Device> devices = await getDevices();
  //
  //     // 首先找到具有匹配 subid 的设备
  //     final targetDevice =
  //     devices.firstWhere((device) => device.subDeviceid == subid);
  //
  //     final postData = {
  //       'deviceId': subid,
  //       'name': targetDevice.subDevicesNames,
  //       'type': targetDevice.subDevicetype,
  //     };
  //
  //     // 如果目标设备具有 subDevicesubtype，则将其添加到 postData 中
  //     if (targetDevice.subDevicesubtype.isNotEmpty) {
  //       postData['subType'] = targetDevice.subDevicesubtype;
  //     }
  //
  //     final response = await _dio.post('/sub-devices', data: postData);
  //
  //     if (response.statusCode == 201) {
  //       print('Subdevice added successfully');
  //     } else {
  //       print('HTTP Status: ${response.statusCode}');
  //       throw Exception('Failed to add subdevice');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     throw Exception('Failed to add subdevice');
  //   }
  // }
}