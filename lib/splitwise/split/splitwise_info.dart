import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SplitwiseInfo extends ChangeNotifier {
  late List<String> _informationList;
  late Map<String, int> _amountMap;
  late int _totalMoney;
  late CollectionReference _informationCollection;

  SplitwiseInfo() {
    _informationList = [];
    _amountMap = {};
    _totalMoney = 0;
    _informationCollection = FirebaseFirestore.instance.collection('splitwise_info');
  }

  List<String> get informationList => _informationList;
  String get totalMoneyFormatted => NumberFormat.decimalPattern().format(_totalMoney);

  Future<void> loadInformation(String groupName) async {
    try {
      QuerySnapshot querySnapshot = await _informationCollection.doc(groupName).collection('information').get();
      _informationList = querySnapshot.docs.map((doc) => doc['information'] as String).toList();
      await _loadAmounts(groupName);
      _updateTotalMoney();
      notifyListeners();
    } catch (e) {
      print('Error loading information: $e');
    }
  }

  Future<void> _loadAmounts(String groupName) async {
    try {
      QuerySnapshot querySnapshot = await _informationCollection.doc(groupName).collection('amounts').get();
      _amountMap = Map.fromEntries(querySnapshot.docs.map((doc) => MapEntry(doc['information'], doc['amount'])));
    } catch (e) {
      print('Error loading amounts: $e');
    }
  }

  Future<void> addInformation(String information, String groupName) async {
    try {
      await _informationCollection.doc(groupName).collection('information').add({'information': information});
      await loadInformation(groupName);
    } catch (e) {
      print('Error adding information: $e');
    }
  }

  Future<void> addAmount(String information, int amount, String groupName) async {
    try {
      _amountMap[information] = amount;
      await _informationCollection.doc(groupName).collection('amounts').doc(information).set({'information': information, 'amount': amount});
      _updateTotalMoney();
      notifyListeners();
    } catch (e) {
      print('Error adding amount: $e');
    }
  }

  int? getAmount(String information) {
    return _amountMap[information];
  }

  void _updateTotalMoney() {
    _totalMoney = _amountMap.values.fold(0, (prev, amount) => prev + amount);
  }

  void removeInformation(String informationText, String groupName) async {
    try {
      // Xóa thông tin khỏi danh sách thông tin
      _informationList.remove(informationText);
      // Xóa số tiền tương ứng
      _amountMap.remove(informationText);
      // Cập nhật lại tổng số tiền
      _updateTotalMoney();
      // Xóa thông tin và số tiền tương ứng từ Firestore
      await _informationCollection.doc(groupName).collection('information').where('information', isEqualTo: informationText).get().then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
      await _informationCollection.doc(groupName).collection('amounts').doc(informationText).delete();
      notifyListeners();
    } catch (e) {
      print('Error removing information: $e');
    }
  }

}
