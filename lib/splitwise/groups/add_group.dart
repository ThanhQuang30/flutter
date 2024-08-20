import 'package:flutter/material.dart';

class AddGroupScreen extends StatefulWidget {
  final String creator; // Thêm trường thông tin người tạo nhóm
  const AddGroupScreen({Key? key, required this.creator}) : super(key: key);

  @override
  _AddGroupScreenState createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  //final TextEditingController _amountController = TextEditingController();
  List<String> _members = [];

  @override
  void initState() {
    super.initState();
    // Thêm người tạo nhóm vào danh sách thành viên
    _members.add(widget.creator);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Group'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Group Name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _groupNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter group name',
                ),
              ),
              // const SizedBox(height: 16),
              // const Text(
              //   'Amount',
              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              // ),
              // TextField(
              //   controller: _amountController,
              //   decoration: const InputDecoration(
              //     hintText: 'Enter amount',
              //     prefixText: '\$',
              //   ),
              // ),
              const SizedBox(height: 16),
              const Text(
                'Members',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _members.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_members[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle),
                      onPressed: () {
                        setState(() {
                          _members.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Hiển thị nút "Create Group"
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_groupNameController.text.isEmpty
                        //|| _amountController.text.isEmpty
                    ) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter Group Name and Amount')),
                      );
                    } else {
                      Navigator.pop(
                        context,
                        {
                          'groupName': _groupNameController.text,
                          //'amount': _amountController.text,
                          'members': _members.toList(), // Truyền danh sách thành viên về SplitwiseScreen
                        },
                      );
                    }
                  },
                  child: const Text('Create Group'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
