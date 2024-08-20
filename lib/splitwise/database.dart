import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import 'package:split/splitwise/user.dart';

import 'groups/group_info.dart';

class OurDatabase{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _logger = Logger('createUser');

  Future<String> createUser(OurUser user) async {
    String retVal = "error";

    try {
      await _firestore.collection("users").doc(user.uid).set({
        'fullName': user.fullName,
        'email': user.email,
        'accountCreated': Timestamp.now(),
      });
      retVal = "success";
    } catch (e) {
      _logger.severe('Error signing up user: $e');
    }

    return retVal;
  }

  Future<OurUser> getUserInfo(String uid) async {
    OurUser retVal = OurUser(
      uid: 'default_uid',
      email: 'default_email',
      fullName: 'default_fullName',
      accountCreated: Timestamp.fromDate(DateTime.now()),
      groupId: '',
    );

    try {
      DocumentSnapshot _docSnapshot = await _firestore.collection("users").doc(uid).get();
      Map<String, dynamic> data = _docSnapshot.data() as Map<String, dynamic>;
    retVal.uid = uid;
    retVal.fullName = data["fullName"];
    retVal.email = data["email"];
    retVal.accountCreated = data["accountCreated"];
    retVal.groupId = data["groupId"];
    } catch (e) {
      _logger.severe('Error signing up user: $e');
    }

    return retVal;
  }

  Future<List<GroupInfo>> getGroupInfo(String uid) async {
    List<GroupInfo> groups = [];

    try {
      QuerySnapshot querySnapshot = await _firestore.collection("users").doc(uid).collection("groups").get();
      for (var doc in querySnapshot.docs) {
        groups.add(GroupInfo.fromMap(doc.data() as Map<String, dynamic>));
      }
    } catch (e) {
      _logger.severe('Error getting group info: $e');
    }

    return groups;
  }

  Future<String> addGroup(GroupInfo group, String uid) async {
    String retVal = "error";

    try {
      await _firestore.collection("users").doc(uid).collection("groups").doc(group.groupId).set(group.toMap());
      retVal = "success";
    } catch (e) {
      _logger.severe('Error adding group: $e');
    }

    return retVal;
  }
}
