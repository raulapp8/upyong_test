
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

//const String serverUrl = 'https://api.tecoserver.com';
const String serverUrl = 'https://api.wificontrolbox.com';
const String clientId = 'Ecp5TUQxtOjdQ24u';

class HttpRequests {
  Future registerUser(String email, String password) async {
    http.Response response = await http.post(Uri.parse('$serverUrl/v1/user/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
          'username': '',
          'phone': '',
          'avatar': ''
        }));
    if (response.statusCode == 201) {
      var decoded = jsonDecode(response.body);
      return decoded;
    } else {
      print('HTTP Status: ${response.statusCode}');
      return null;
    }
  }

  Future loginUser(String email, String password) async {
    http.Response response = await http.post(Uri.parse('$serverUrl/v1/user/auth'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
          'grant_type': 'password',
          'client_id': clientId
        }));
    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      return decoded;
    } else {
      print('HTTP Status: ${response.statusCode}');
      return null;
    }

  }

  Future<int> checkUser(String email) async {
    http.Response response = await http.post(Uri.parse('$serverUrl/v1/user/check'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,

        }));

    print('HTTP Status: ${response.statusCode}');
    return response.statusCode;
  }

  Future refreshToken(String refreshToken, String accessToken) async {
    http.Response response = await http.post(Uri.parse('$serverUrl/v1/user/auth'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(<String, String>{
          'refresh_token': refreshToken,
          'grant_type': 'refresh_token',
          'client_id': clientId
        }));
    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      return decoded;
    } else {
      print('HTTP Status: ${response.statusCode}');
      return null;
    }
  }

  Future revokeToken(String refreshToken, String accessToken) async {
    final client = http.Client();
    try {
      final response = await client.send(
          http.Request("DELETE", Uri.parse("$serverUrl/oauth2/token"))
            ..headers["Authorization"] = "Bearer $accessToken"
            ..headers["Content-Type"] = "application/json; charset=UTF-8"
            ..body = jsonEncode(<String, String>{
              'refresh_token': refreshToken,
            }));
      if(response.statusCode == 204) {
        print("Logout OK");
      }
      else {
        print('Logout error');
      }
    } finally {
      client.close();
    }
  }

  // Future getDevices(String accessToken) async {
  //   print(accessToken);
  //   http.Response response = await http.get(
  //     Uri.parse('$serverUrl/devices'),
  //     headers: <String, String>{
  //       'Authorization': 'Bearer $accessToken',
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     var decoded = jsonDecode(response.body);
  //     return decoded;
  //   } else {
  //     print('HTTP Status: ${response.statusCode}');
  //   }
  // }

  //-google signin
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
