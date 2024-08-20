// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:split/splitwise/costsIncurred/payQuickly.dart';
// import 'package:split/splitwise/costsIncurred/payment_manager.dart';
// import '../../src/fire_base/fire_base.dart';
// import 'borrowed_manager.dart';
//
// class CostsIncurredPage extends StatefulWidget {
//   final List<String> members;
//   final String groupName;
//
//   const CostsIncurredPage({
//     Key? key,
//     required this.members,
//     required this.groupName,
//   }) : super(key: key);
//
//   @override
//   _CostsIncurredPageState createState() => _CostsIncurredPageState();
// }
//
// class _CostsIncurredPageState extends State<CostsIncurredPage> {
//   late FirestoreService firestoreService;
//   Solution solution = Solution();
//
//   @override
//   void initState() {
//     super.initState();
//     firestoreService = FirestoreService();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final currentUserFullName = Provider.of<CurrentUser>(context).getCurrentUser!.fullName;
//     final sortedMembers = List<String>.from(widget.members);
//     sortedMembers.remove(currentUserFullName);
//     sortedMembers.insert(0, currentUserFullName);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('COSTS INCURRED'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Members:',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: sortedMembers.length,
//                 itemBuilder: (context, index) {
//                   final member = sortedMembers[index];
//                   final isCurrentUser = member == currentUserFullName;
//
//                   return Container(
//                     margin: const EdgeInsets.only(bottom: 8),
//                     child: Card(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: ExpansionTile(
//                         title: Row(
//                           children: [
//                             Text(
//                               member,
//                               style: TextStyle(
//                                 fontSize: 22,
//                                 color: isCurrentUser ? Colors.red : null,
//                               ),
//                             ),
//                           ],
//                         ),
//                         childrenPadding: EdgeInsets.zero,
//                         children: [
//                           FutureBuilder(
//                             future: firestoreService.getBorrowedAmounts(widget.groupName, member),
//                             builder: (context, AsyncSnapshot<Map<String, int>> snapshot) {
//                               if (snapshot.connectionState == ConnectionState.waiting) {
//                                 return const CircularProgressIndicator();
//                               } else {
//                                 if (snapshot.hasError) {
//                                   return Text('Error: ${snapshot.error}');
//                                 } else {
//                                   final borrowedAmounts = snapshot.data!;
//                                   return Container(
//                                     padding: const EdgeInsets.all(16),
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         for (final remainingMember in sortedMembers)
//                                           if (remainingMember != member)
//                                             Padding(
//                                               padding: const EdgeInsets.only(bottom: 8),
//                                               child: Row(
//                                                 children: [
//                                                   Expanded(
//                                                     child: Text(
//                                                       remainingMember,
//                                                       style: const TextStyle(fontSize: 18, color: Colors.black),
//                                                     ),
//                                                   ),
//                                                   Text(
//                                                     borrowedAmounts.containsKey(remainingMember)
//                                                         ? '${NumberFormat.decimalPattern().format(borrowedAmounts[remainingMember])} VND'
//                                                         : '0 VND',
//                                                     style: const TextStyle(fontSize: 18, color: Colors.black),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                         if (isCurrentUser)
//                                           Row(
//                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               ElevatedButton(
//                                                 onPressed: () {
//                                                   _showBorrowDialog(context, sortedMembers, member);
//                                                 },
//                                                 style: ButtonStyle(
//                                                   backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
//                                                 ),
//                                                 child: const Text('Borrow', style: TextStyle(color: Colors.white)),
//                                               ),
//                                             ],
//                                           ),
//                                       ],
//                                     ),
//                                   );
//                                 }
//                               }
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 ElevatedButton(
//                   onPressed: () async {
//                     final List<Map<String, int>> borrowedAmountsList = [];
//                     for (final member in sortedMembers) {
//                       final borrowedAmounts = await firestoreService.getBorrowedAmounts(widget.groupName, member);
//                       borrowedAmountsList.add(borrowedAmounts);
//                     }
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => PaymentPage(
//                           members: sortedMembers,
//                           borrowedAmountsList: borrowedAmountsList,
//                         ),
//                       ),
//                     );
//                   },
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
//                   ),
//                   child: const Text('Pay quickly', style: TextStyle(fontSize: 20, color: Colors.white)),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showBorrowDialog(BuildContext context, List<String> members, String borrower) {
//     String? selectedMember;
//     int amount = 0;
//     List<String> otherMembers = List.from(members);
//     otherMembers.remove(Provider.of<CurrentUser>(context, listen: false).getCurrentUser!.fullName);
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Borrow'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               DropdownButtonFormField<String>(
//                 value: selectedMember,
//                 onChanged: (value) {
//                   selectedMember = value!;
//                 },
//                 items: otherMembers.map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//               ),
//               TextField(
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) {
//                   amount = int.tryParse(value) ?? 0;
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'Amount',
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   await firestoreService.borrowAmount(widget.groupName, borrower, selectedMember!, amount);
//                   setState(() {});
//                   print('Borrow $amount from $selectedMember');
//                   Navigator.of(context).pop();
//                 } catch (e) {
//                   print('Error borrowing amount: $e');
//                 }
//               },
//               style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
//               ),
//               child: const Text('Borrow', style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

//---------------------------------------------
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:split/splitwise/costsIncurred/payQuickly.dart';
import '../../src/fire_base/fire_base.dart';
import 'borrowed_manager.dart';

class CostsIncurredPage extends StatefulWidget {
  final List<String> members;
  final String groupName;

  const CostsIncurredPage({
    Key? key,
    required this.members,
    required this.groupName,
  }) : super(key: key);

  @override
  _CostsIncurredPageState createState() => _CostsIncurredPageState();
}

class _CostsIncurredPageState extends State<CostsIncurredPage> {
  late FirestoreService firestoreService;

  @override
  void initState() {
    super.initState();
    firestoreService = FirestoreService();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserFullName = Provider.of<CurrentUser>(context).getCurrentUser!.fullName;
    final sortedMembers = List<String>.from(widget.members);
    sortedMembers.remove(currentUserFullName);
    sortedMembers.insert(0, currentUserFullName);

    return Scaffold(
      appBar: AppBar(
        title: const Text('COSTS INCURRED'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Members:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: sortedMembers.length,
                itemBuilder: (context, index) {
                  final member = sortedMembers[index];
                  final isCurrentUser = member == currentUserFullName;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ExpansionTile(
                        title: Row(
                          children: [
                            Text(
                              member,
                              style: TextStyle(
                                fontSize: 22,
                                color: isCurrentUser ? Colors.red : null,
                              ),
                            ),
                          ],
                        ),
                        childrenPadding: EdgeInsets.zero,
                        children: [
                          FutureBuilder(
                            future: firestoreService.getBorrowedAmounts(widget.groupName, member),
                            builder: (context, AsyncSnapshot<Map<String, int>> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  final borrowedAmounts = snapshot.data!;
                                  return Container(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        for (final remainingMember in sortedMembers)
                                          if (remainingMember != member)
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      remainingMember,
                                                      style: const TextStyle(fontSize: 18, color: Colors.black),
                                                    ),
                                                  ),
                                                  Text(
                                                    borrowedAmounts.containsKey(remainingMember)
                                                        ? '${NumberFormat.decimalPattern().format(borrowedAmounts[remainingMember])} VND'
                                                        : '0 VND',
                                                    style: const TextStyle(fontSize: 18, color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        if (isCurrentUser)
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  _showBorrowDialog(context, sortedMembers, member);
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                                                ),
                                                child: const Text('Borrow', style: TextStyle(color: Colors.white)),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(members: widget.members, groupName: widget.groupName),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
                  ),
                  child: const Text('Pay quickly', style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBorrowDialog(BuildContext context, List<String> members, String borrower) {
    String? selectedMember;
    int amount = 0;
    List<String> otherMembers = List.from(members);
    otherMembers.remove(Provider.of<CurrentUser>(context, listen: false).getCurrentUser!.fullName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Borrow'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: selectedMember,
                onChanged: (value) {
                  selectedMember = value!;
                },
                items: otherMembers.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  amount = int.tryParse(value) ?? 0;
                },
                decoration: const InputDecoration(
                  labelText: 'Amount',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await firestoreService.borrowAmount(widget.groupName, borrower, selectedMember!, amount);
                  setState(() {
                    // No need to update borrowedAmounts here
                  });
                  print('Borrow $amount from $selectedMember');
                  Navigator.of(context).pop();
                } catch (e) {
                  print('Error borrowing amount: $e');
                }
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
              ),
              child: const Text('Borrow', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}