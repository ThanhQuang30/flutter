import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../src/fire_base/fire_base.dart';
import 'groups/add_group.dart';
import 'groups/group_detail.dart';
import 'groups/group_info.dart';
import 'groups/group_manager.dart';
import 'groups/join_group.dart';

class SplitwiseScreen extends StatefulWidget {
  @override
  _SplitwiseScreenState createState() => _SplitwiseScreenState();
}

class _SplitwiseScreenState extends State<SplitwiseScreen> {
  late List<GroupInfo> _groups = [];
  late String _currentUserName = '';

  @override
  void initState() {
    super.initState();
    _currentUserName = Provider.of<CurrentUser>(context, listen: false).getCurrentUser!.fullName;
    _loadGroups();
  }

  void _loadGroups() {
    final groupManager = Provider.of<GroupManager>(context, listen: false);
    groupManager.getGroups(_currentUserName).listen((groups) {
      if (mounted) {
        setState(() {
          _groups = groups;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Splitwise', style: TextStyle(fontSize: 25)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Groups',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down, size: 40),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _groups.length,
              itemBuilder: (context, index) {
                final group = _groups[index];
                return ListTile(
                  title: Text(group.groupName, style: const TextStyle(fontSize: 25)),
                  //subtitle: Text('Amount: \$${group.amount.toStringAsFixed(2)}'),
                  onTap: () {
                    _showGroupDetail(group);
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteGroup(group);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.fromLTRB(33, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Provider.of<CurrentUser>(context, listen: false).getCurrentUserInfo().then((_) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddGroupScreen(
                        creator: Provider.of<CurrentUser>(context, listen: false).getCurrentUser!.fullName,
                      ),
                    ),
                  ).then((result) {
                    if (result != null) {
                      _addGroup(GroupInfo(
                        groupName: result['groupName'],
                        members: result['members'],
                        groupId: '',
                        creator: _currentUserName,
                      ));
                    }
                  });
                });
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.orange),
                foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 28.0),
                child: Text('Create', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(width: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const JoinGroup()),
                );
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.orange),
                foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
                child: Text('Join', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addGroup(GroupInfo newGroup) {
    final groupManager = Provider.of<GroupManager>(context, listen: false);
    groupManager.addGroup(newGroup);
  }

  void _showGroupDetail(GroupInfo group) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GroupInfoScreen(group: group)),
    );
  }

  void _deleteGroup(GroupInfo group) {
    final groupManager = Provider.of<GroupManager>(context, listen: false);
    final currentUser = FirebaseAuth.instance.currentUser;

    if(currentUser != null) {
      groupManager.deleteGroup(group, currentUser.uid).then((_) {
        _loadGroups();
      });
    } else {
      print("User is not authenticated.");
    }
  }
}
