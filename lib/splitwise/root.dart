import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split/src/fire_base/fire_base.dart';
import 'package:split/src/resources/home.dart';
import 'package:split/src/resources/login.dart';

enum AuthStatus {
  notLoggedIn,
  loggedIn,
}

class OurRoot extends StatefulWidget {
  const OurRoot({super.key});

  @override
  _OurRootState createState() => _OurRootState();
}

class _OurRootState extends State<OurRoot> {
  AuthStatus _authStatus = AuthStatus.notLoggedIn;

  @override
  void didChangeDependencies() async {
    //
    super.didChangeDependencies();

    //
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _returnString = await _currentUser.onStartUp();
    if (_returnString == "success") {
      setState(() {
        _authStatus = AuthStatus.loggedIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget retVal = const SizedBox.shrink();

    switch (_authStatus) {
      case AuthStatus.notLoggedIn:
        retVal = LoginPage();
        break;
      case AuthStatus.loggedIn:
        retVal = const HomePage();
        break;
      default:
    }
    return retVal;
  }
}
