class GroupInfo {
  late final String groupId;
  final String groupName;
  // final double amount;
  final List<String> members;
  final String creator;

  GroupInfo({
    required this.groupId,
    required this.groupName,
    // required this.amount,
    required this.members,
    required this.creator,
  });

  factory GroupInfo.fromMap(Map<String, dynamic> map) {
    return GroupInfo(
      groupId: map['groupId'],
      groupName: map['groupName'],
      // amount: map['amount'],
      members: List<String>.from(map['members']),
      creator: map['creator'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      // 'amount': amount,
      'members': members,
      'creator': creator,
    };
  }
}
