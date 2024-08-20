import 'dart:async';


class AuthBloc {

  final StreamController _nameController =  StreamController();
  final StreamController _emailController = StreamController();
  final StreamController _passController = StreamController();
  final StreamController _phoneController = StreamController();

  Stream get nameStream => _nameController.stream;
  Stream get emailStream => _emailController.stream;
  Stream get passStream => _passController.stream;
  Stream get phoneStream => _phoneController.stream;

  bool isValid(String? name, String? email, String? pass, String? phone) {
    if (name == null || name.isEmpty) {
      _nameController.sink.addError("Nhập tên");
      return false;
    }
    _nameController.sink.add("");

    if (phone == null || phone.isEmpty) {
      _phoneController.sink.addError("Nhập số điện thoại");
      return false;
    }
    _phoneController.sink.add("");

    if (email == null || email.isEmpty || !email.contains('@')) {
      _emailController.sink.addError("Nhập email");
      return false;
    }
    _emailController.sink.add("");

    return true;
  }

  

  void dispose() {
    _nameController.close();
    _emailController.close();
    _passController.close();
  }
}