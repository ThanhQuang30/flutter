import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SplitResultPage extends StatelessWidget {
  final String groupName;
  final List<String> members;
  final String totalMoneyFormatted;
  final double averageMoney;

  const SplitResultPage({Key? key, required this.groupName, required this.members, required this.totalMoneyFormatted, required this.averageMoney}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Split Result - $groupName'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Money: $totalMoneyFormatted VND',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Members:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              members[index],
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                          Text(
                            '${NumberFormat.decimalPattern().format(averageMoney)} VND',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
