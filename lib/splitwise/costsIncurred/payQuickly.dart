// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:split/splitwise/costsIncurred/payment_manager.dart';
//
//
// class PaymentPage extends StatelessWidget {
//   final List<String> members;
//   final List<Map<String, int>> borrowedAmountsList;
//
//   const PaymentPage({
//     Key? key,
//     required this.members,
//     required this.borrowedAmountsList,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     List<int> netAmounts = List<int>.filled(members.length, 0);
//
//     // Calculate net amounts
//     for (int i = 0; i < members.length; i++) {
//       for (int j = 0; j < members.length; j++) {
//         if (borrowedAmountsList[i].containsKey(members[j])) {
//           netAmounts[i] += borrowedAmountsList[i][members[j]]!;
//           netAmounts[j] -= borrowedAmountsList[i][members[j]]!;
//         }
//       }
//     }
//
//     Solution solution = Solution();
//     List<List<int>> transactions = solution.minimizeCashFlowRecursive(netAmounts);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Payment Details'),
//       ),
//       body: ListView.builder(
//         itemCount: transactions.length,
//         itemBuilder: (context, index) {
//           final transaction = transactions[index];
//           return ListTile(
//             title: Text(
//               '${members[transaction[0]]} pays ${members[transaction[1]]} ${NumberFormat.decimalPattern().format(transaction[2])} VND',
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

//---------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:split/splitwise/costsIncurred/borrowed_manager.dart';
import 'package:split/splitwise/costsIncurred/payment_manager.dart';

class PaymentPage extends StatelessWidget {
  final List<String> members;
  final String groupName;

  const PaymentPage({Key? key, required this.members, required this.groupName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Details'),
      ),
      body: PaymentDetails(groupName: groupName, members: members),
    );
  }
}

class PaymentDetails extends StatefulWidget {
  final List<String> members;
  final String groupName;

  const PaymentDetails({Key? key, required this.members, required this.groupName}) : super(key: key);

  @override
  _PaymentDetailsState createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  late Graph graph;
  late FirestoreService firestoreService;
  late List<String> payments;
  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();
    firestoreService = FirestoreService();
    graph = Graph(widget.members.length);
    payments = [];
    fetchBorrowedAmounts();
  }

  fetchBorrowedAmounts() async {
    for (int i = 0; i < widget.members.length; i++) {
      Map<String, int> borrowedAmounts = await firestoreService.getBorrowedAmounts(widget.groupName, widget.members[i]);
      for (int j = 0; j < widget.members.length; j++) {
        if (i != j) {
          if (borrowedAmounts.containsKey(widget.members[j])) {
            graph.addEdge(widget.members[i], widget.members[j], borrowedAmounts[widget.members[j]]!);
          } else {
            // Set the capacity to 0 if there is no borrowing amount
            graph.addEdge(widget.members[i], widget.members[j], 0);
          }
        }
      }
    }
    List<String> result = graph.kernelFunction();
    setState(() {
      payments = result;
      _dataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _dataLoaded
        ? ListView.builder(
      itemCount: payments.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(payments[index]),
        );
      },
    )
        : Center(child: CircularProgressIndicator());
  }
}


