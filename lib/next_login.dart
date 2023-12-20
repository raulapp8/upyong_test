import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:upyong_test/lib/http_requests.dart';
import 'package:upyong_test/lib/api_service.dart';
import 'package:upyong_test/constants.dart';
import 'package:upyong_test/components/round_button.dart';
import 'package:upyong_test/register_user.dart';
import 'package:upyong_test/login_post.dart';

class NextLoginScreen extends StatefulWidget {
  const NextLoginScreen({super.key});


  @override

  _NextLoginScreenState createState() => _NextLoginScreenState();
}

class _NextLoginScreenState extends State<NextLoginScreen>{
  String email = '' ;
  bool showSpinner = false;

  void goToNext() async {
    ApiService apiService = ApiService();
    //HttpRequests requests = HttpRequests();
    final response = await apiService.checkUser(email);
    if (response == 400) {
      //輸入email不正確
      Get.snackbar('警告', '無效的email');
    }
    // else if (response == 409) {
    //   // ignore: use_build_context_synchronously
    //   Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPostScreen(email)));
    // }
    else if (response == 404)
    {
      Future.delayed(Duration.zero, () {
        Get.to(() => RegisterPage(email));
        // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //   return RegisterPage(email);
        // }));
      });

    } else {
      Get.to(() => LoginPostScreen(email));
      //Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPostScreen(email)));
    }

  }

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(LOGIN_SINUP),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),

              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                  child:Text(EMAIL,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: color3,
                    ),
                  ),)
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: TextEditingController()..text= email,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your email',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.black,
                  ),
                  //minimumSize: const Size(100, 42),
                  backgroundColor: backgroundColor,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.all(0),
                ),
                onPressed: (){
                  goToNext();
                },
                child: const Text('下一步'),

              ),
              const SizedBox(
                height: 50,
              ),


              RoundButton(
                text: 'Login with Google',
                //color: const Color(0xfffe9200),
                onPressed: () async {
                  HttpRequests requests = HttpRequests();
                  final response = await requests.signInWithGoogle();


                  print('-=-=-==-=--=-$response');



                },
              ),
              // TextField(
              //   controller: TextEditingController()..text= password,
              //   textAlign: TextAlign.center,
              //   obscureText: true,
              //   keyboardType: TextInputType.emailAddress,
              //   onChanged: (value) {
              //     password = value;
              //   },
              //   decoration: kTextFieldDecoration.copyWith(
              //       hintText: 'Enter your password'),
              // ),

            ],
          ),
        ),
      ),
    );

  }

}