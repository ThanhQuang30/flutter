import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:split/splitwise/split/splitTotal.dart';
import 'package:split/splitwise/split/splitwise_info.dart';

class SplitwisePage extends StatefulWidget {
  final String groupName;
  final List<String> members;

  const SplitwisePage({Key? key, required this.groupName, required this.members}) : super(key: key);

  @override
  _SplitwisePageState createState() => _SplitwisePageState();
}

class _SplitwisePageState extends State<SplitwisePage> {
  late TextEditingController informationController;
  late TextEditingController amountController;
  late SplitwiseInfo splitwiseInfo;
  bool isAddingInformation = false;
  bool isInformationEmpty = true;

  @override
  void initState() {
    super.initState();
    informationController = TextEditingController();
    amountController = TextEditingController();
    splitwiseInfo = Provider.of<SplitwiseInfo>(context, listen: false);
    splitwiseInfo.loadInformation(widget.groupName);
  }

  @override
  void dispose() {
    informationController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GENERAL EXPENSES'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 50,
              color: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TOTAL MONEY:',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Consumer<SplitwiseInfo>(
                    builder: (context, splitwiseInfo, child) =>
                        Text(
                          '${splitwiseInfo.totalMoneyFormatted} VND',
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: isAddingInformation
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: informationController,
                    onChanged: (text) {
                      setState(() {
                        isInformationEmpty = text.isEmpty;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Enter information',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          final information = informationController.text;
                          final amount = int.tryParse(amountController.text) ??
                              0;
                          if (information.isNotEmpty) {
                            splitwiseInfo.addInformation(
                                information, widget.groupName);
                            splitwiseInfo.addAmount(
                                information, amount, widget.groupName);
                            setState(() {
                              isAddingInformation = false;
                              isInformationEmpty = true;
                              informationController.clear();
                              amountController.clear();
                            });
                          } else {
                            setState(() {
                              isInformationEmpty = false;
                            });
                          }
                        },
                        child: const Text('Save'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isAddingInformation = false;
                            isInformationEmpty = true;
                            informationController.clear();
                            amountController.clear();
                          });
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ],
              )
                  : TextButton(
                onPressed: () {
                  setState(() {
                    isAddingInformation = true;
                    isInformationEmpty = true;
                  });
                },
                child: const Text(
                  '+ Add information',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Consumer<SplitwiseInfo>(
              builder: (context, splitwiseInfo, child) =>
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: splitwiseInfo.informationList
                        .map(
                            (info) =>
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: TextButton(
                                onPressed: () {
                                  _showAmountDialog(info);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      '$info:',
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                    const Spacer(),
                                    Text(
                                      splitwiseInfo.getAmount(info) != null
                                          ? ' ${NumberFormat.decimalPattern()
                                          .format(
                                          splitwiseInfo.getAmount(info))} VND'
                                          : '',
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () {
                                        splitwiseInfo.removeInformation(info, widget.groupName);
                                      },
                                      child: const Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Tính số tiền trung bình mỗi thành viên nhận được
          double totalMoney = double.parse(splitwiseInfo.totalMoneyFormatted.replaceAll(RegExp(r'\D'), ''));
          double averageMoney = totalMoney / widget.members.length;
          // Chuyển hướng sang trang SplitResultPage và truyền thông tin cần thiết
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SplitResultPage(
                groupName: widget.groupName,
                members: widget.members,
                totalMoneyFormatted: splitwiseInfo.totalMoneyFormatted,
                averageMoney: averageMoney,
              ),
            ),
          );
        },
        label: const Text('Split',
          style: TextStyle(fontSize: 20),),
        //icon: const Icon(Icons.compare_arrows),
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showAmountDialog(String info) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Amount'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                child: TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Amount'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        int currentValue = int.tryParse(amountController.text) ?? 0;
                        int currentAmount = splitwiseInfo.getAmount(info) ?? 0;
                        int newAmount = currentValue + currentAmount;
                        splitwiseInfo.addAmount(info, newAmount, widget.groupName);
                        amountController.clear();
                        Navigator.of(context).pop();
                      });
                    },
                    child: const Text('+'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        int currentValue = int.tryParse(amountController.text) ?? 0;
                        int currentAmount = splitwiseInfo.getAmount(info) ?? 0;
                        int newAmount = currentAmount - currentValue;
                        splitwiseInfo.addAmount(info, newAmount, widget.groupName);
                        amountController.clear();
                        Navigator.of(context).pop();
                      });
                    },
                    child: const Text('-'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('X'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
