import 'package:flutter/cupertino.dart';

import 'group_info.dart';
//import 'group_manager.dart';

class GroupList extends ChangeNotifier {
  List<GroupInfo> _groups = [];

  List<GroupInfo> get groups => _groups;


  void setGroups(List<GroupInfo> groups) {
    _groups = groups;
    notifyListeners();
  }

  void addGroup(GroupInfo group) {
    _groups.add(group);
    notifyListeners();
  }

  void deleteGroup(GroupInfo group) {
    _groups.remove(group);
    notifyListeners();
  }

  Future<List<GroupInfo>> getGroupsForMember(String userId) async {
    // Replace this with your logic to filter groups based on userId
    return _groups.where((group) => group.members.contains(userId)).toList();
  }

}
