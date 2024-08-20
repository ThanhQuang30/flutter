import 'package:cloud_firestore/cloud_firestore.dart';

import 'group_info.dart';

class GroupManager {
  final CollectionReference groupsCollection =
  FirebaseFirestore.instance.collection('groups');

  Future<String> addGroup(GroupInfo group) async {
    try {
      var docRef = await groupsCollection.add(group.toMap());
      return docRef.id;
    } catch (e) {
      print("Error adding group: $e");
      return '';
    }
  }

  Future<void> joinGroup(String groupId, String userId) async {
    try {
      await groupsCollection.doc(groupId).update({
        'members': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      print("Error joining group: $e");
    }
  }

  Future<void> addGroupMember(String groupId, String userId) async {
    try {
      final groupRef = groupsCollection.doc(groupId);
      final groupDoc = await groupRef.get();
      if (groupDoc.exists) {
        final Map<String, dynamic>? data = groupDoc.data() as Map<String, dynamic>?;
        if (data != null) {
          final List<String> members = List<String>.from(data['members']);
          members.add(userId);
          await groupRef.update({'members': members});
        } else {
          print('Group data is null');
        }
      } else {
        print('Group does not exist');
      }
    } catch (e) {
      print("Error adding group member: $e");
    }
  }

  Stream<List<GroupInfo>> getGroups(String fullName) {
    return groupsCollection
        .where('members', arrayContains: fullName)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      data['groupId'] = doc.id;
      return GroupInfo.fromMap(data);
    }).toList());
  }


  Future<void> deleteGroup(GroupInfo group, String currentUser) async {
    try {
      // Kiểm tra xem người dùng hiện tại có phải là người tạo nhóm hay không
      if (group.creator == currentUser) {
        // Nếu là người tạo nhóm, thì mới cho phép xóa nhóm
        await groupsCollection.doc(group.groupId).delete();
      } else {
        // Nếu không phải là người tạo nhóm, in ra thông báo
        print("Only the group creator can delete this group.");
      }
    } catch (e) {
      // In ra lỗi nếu xảy ra
      print("Error deleting group: $e");
    }
  }

}