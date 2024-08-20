import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';
import 'package:split/splitwise/database.dart';
import '../../splitwise/groups/group_info.dart';
import '../../splitwise/user.dart';

class CurrentUser extends ChangeNotifier {
  OurUser? _currentUser = OurUser(
    uid: 'default_uid',
    email: 'default_email',
    fullName: 'default_fullName',
    accountCreated: Timestamp.fromDate(DateTime.now()),
    groupId: '',
  );

  OurUser? get getCurrentUser => _currentUser;

  List<GroupInfo> _groups = [];

  List<GroupInfo> get groups => _groups;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _logger = Logger('onStartUp');

  Future<String> onStartUp() async {
    String retVal = "error";

    try {
      User? _firebaseUser = _auth.currentUser;
      if (_firebaseUser != null) {
        _currentUser = await OurDatabase().getUserInfo(_firebaseUser.uid);
        if (_currentUser != null) {
          retVal = "success";
        }
      }
    } catch (e) {
      _logger.severe('Error signing up user: $e');
    }
    return retVal;
  }

  Future<String> signOut() async {
    String retVal = "error";

    try {
      await _auth.signOut();
      _currentUser = OurUser(
        uid: 'default_uid',
        email: 'default_email',
        fullName: 'default_fullName',
        accountCreated: Timestamp.fromDate(DateTime.now()),
        groupId: '',
      );
      retVal = "success";
    } catch (e) {
      _logger.severe('Error signing up user: $e');
    }
    return retVal;
  }

  Future<String> signUpUser(String email, String password,
      String fullName) async {
    String retVal = "error";
    OurUser _user = OurUser(
      uid: 'default_uid',
      email: 'default_email',
      fullName: 'default_fullName',
      accountCreated: Timestamp.fromDate(DateTime.now()),
      groupId: '',
    );

    try {
      UserCredential _authResult =
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _user.uid = _authResult.user!.uid;
      _user.email = _authResult.user!.email!;
      _user.fullName = fullName;
      String _returnString = await OurDatabase().createUser(_user);
      if (_returnString == "success") {
        retVal = "success";
      }
    } on PlatformException catch (e) {
      retVal = e.toString();
    } catch (e) {
      retVal = e.toString();
    }

    return retVal;
  }

  Future<String> loginUserWithEmail(String email, String password) async {
    String retVal = "error";

    try {
      UserCredential _authResult =
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      _currentUser = await OurDatabase().getUserInfo(_authResult.user!.uid);
      if (_currentUser != null) {
        _groups = await OurDatabase().getGroupInfo(_currentUser!.uid);
        retVal = "success";
      }
    } catch (e) {
      retVal = e.toString();
    }

    return retVal;
  }

  Future<String> loginUserWithGoogle() async {
    String retVal = "error";
    const List<String> scopes = <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ];

    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: scopes,
    );
    OurUser _user = OurUser(
      uid: 'default_uid',
      email: 'default_email',
      fullName: 'default_fullName',
      accountCreated: Timestamp.fromDate(DateTime.now()),
      groupId: '',
    );

    try {
      GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication _googleAuth = await _googleUser!
          .authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);
      UserCredential _authResult = await _auth.signInWithCredential(credential);
      if (_authResult.additionalUserInfo!.isNewUser) {
        _user.uid = _authResult.user!.uid;
        _user.email = _authResult.user!.email!;
        _user.fullName = _authResult.user!.displayName!;
        OurDatabase().createUser(_user);
      }
      _currentUser = await OurDatabase().getUserInfo(_authResult.user!.uid);
      if (_currentUser != null) {
        _groups = await OurDatabase().getGroupInfo(_currentUser!.uid);
        retVal = "success";
      }
    } catch (e) {
      retVal = e.toString();
    }

    return retVal;
  }

  Future<void> getCurrentUserInfo() async {
    try {
      _currentUser = await OurDatabase().getUserInfo(_auth.currentUser!.uid);
      if (_currentUser != null) {
        _groups = await OurDatabase().getGroupInfo(_currentUser!.uid);
      }
      notifyListeners();
    } catch (e) {
      _logger.severe('Error signing up user: $e');
    }
  }

  // Thêm group vào danh sách và lưu vào SharedPreferences
  void addGroup(GroupInfo group) {
    _groups.add(group);
    notifyListeners();
  }
}

