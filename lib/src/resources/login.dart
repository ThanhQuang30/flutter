import 'package:provider/provider.dart';
import 'package:split/src/resources/home.dart';
import 'package:split/src/resources/register.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../fire_base/fire_base.dart';

enum LoginType{
  email,
  google,
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final _logger = Logger('LoginUser');

  void _loginUser({
    required LoginType type,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);

    try {
      String _returnString = "error";

      switch (type) {
        case LoginType.email:
          _returnString = await _currentUser.loginUserWithEmail(email, password);
          break;
        case LoginType.google:
          _returnString = await _currentUser.loginUserWithGoogle();
          break;
        default:
      }
      
      if (_returnString == "success") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
              (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_returnString),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      _logger.severe('Error signing up user: $e');
    }
  }

  Widget _googleButton() {
    return OutlinedButton(
      onPressed: () {
        _loginUser(
            type: LoginType.google, context: context, email: '', password: '');
      },
      style: OutlinedButton.styleFrom(
      foregroundColor: Colors.grey, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      side: const BorderSide(color: Colors.grey),
      splashFactory: InkSplash.splashFactory,
      ),
      child: const Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 25.0),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        constraints: const BoxConstraints.expand(),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 140,
              ),
              Image.asset('assets/sp_login.png'),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 6),
                child: Text(
                  "Welcome back!",
                  style: TextStyle(fontSize: 25, color: Color(0xff333333)),
                ),
              ),
              const Text(
                "Login to continue using iSplitMoney",
                style: TextStyle(fontSize: 20, color: Color(0xff606470)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Container(
                          width: 50, child: Image.asset("assets/sp_mail.png")
                      ),
                      border: const OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Color(0xffCED0D2), width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6)))),
                ),
              ),
              TextFormField(
                controller: _passController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: Container(
                        width: 50, child: Image.asset("assets/sp_lock.png")
                    ),
                    border: const OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Color(0xffCED0D2), width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(6)))),
              ),
              Container(
                constraints: BoxConstraints.loose(const Size(double.infinity, 30)),
                alignment: AlignmentDirectional.centerEnd,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Text(
                    "Forgot password?",
                    style: TextStyle(fontSize: 20, color: Color(0xff606470)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      _loginUser(
                          type: LoginType.email,
                          email: _emailController.text,
                          password: _passController.text,
                          context: context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff3277D8),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                    ),
                    child: const Text(
                      "Log In",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: RichText(
                  text: TextSpan(
                      text: "New user? ",
                      style: const TextStyle(color: Color(0xff606470), fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterPage()));
                              },
                            text: "Sign up for a new account",
                            style: const TextStyle(
                                color: Color(0xff3277D8), fontSize: 20))
                      ]),
                ),
              ),
              _googleButton(),
            ],
          ),
        ),
      ),
    );
  }
}
