import 'package:flutter/gestures.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:split/src/fire_base/fire_base.dart';
import 'package:split/src/resources/login.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final TextEditingController _fullNameController =  TextEditingController();
  final TextEditingController _emailController =  TextEditingController();
  final TextEditingController _passController =  TextEditingController();
  final TextEditingController _confirmpasswordController =  TextEditingController();

  final _logger = Logger('signUpUser');


  void _signUpUser(String email, String password, BuildContext context, String fullName) async{
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);

    try {
      String _returnString = await _currentUser.signUpUser(email, password, fullName);
      if (_returnString == "success") {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => LoginPage()
          ),
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
                padding: EdgeInsets.fromLTRB(0, 20, 0, 2),
                child: Text(
                  "Welcome Aboard!",
                  style: TextStyle(fontSize: 25, color: Color(0xff333333)),
                ),
              ),
              const Text(
                "Signup with iSplitMoney in simple steps",
                style: TextStyle(fontSize: 20, color: Color(0xff606470)),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: TextField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                        labelText: "Full Name",
                        prefixIcon:  Image.asset("assets/sp_user.png"),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffCED0D2), width: 1),
                            borderRadius:
                            BorderRadius.all(Radius.circular(6)))),
                  )),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: Image.asset("assets/sp_mail.png"),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffCED0D2), width: 1),
                            borderRadius:
                            BorderRadius.all(Radius.circular(6)))),
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: TextField(
                  controller: _passController,
                  decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon:Image.asset("assets/sp_lock.png"),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(0xffCED0D2), width: 1),
                          borderRadius:
                          BorderRadius.all(Radius.circular(6)))),
                          obscureText: true,
                ),
              ),
              TextField(
                controller: _confirmpasswordController,
                decoration: InputDecoration(
                    labelText: "Confirm PassWord",
                    prefixIcon: Image.asset("assets/sp_lock.png"),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xffCED0D2), width: 1),
                        borderRadius:
                        BorderRadius.all(Radius.circular(6)))),
                        obscureText: true,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      if(_passController.text == _confirmpasswordController.text){
                        _signUpUser(_emailController.text, _passController.text, context, _fullNameController.text);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Passwords do not match"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff3277D8),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: RichText(
                  text: TextSpan(
                      text: "Already a User? ",
                      style: const TextStyle(color: Color(0xff606470), fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              },
                            text: "Login now",
                            style: const TextStyle(
                                color: Color(0xff3277D8), fontSize: 20))
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}