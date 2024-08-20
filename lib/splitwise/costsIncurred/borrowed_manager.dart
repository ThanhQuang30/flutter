import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> borrowAmount(String groupName, String borrower, String lender, int amount) async {
    try {
      final DocumentReference borrowerRef = _firestore.collection('borrows').doc(groupName).collection('members').doc(borrower);
      final DocumentReference lenderRef = borrowerRef.collection('borrowedFrom').doc(lender);

      final borrowerSnapshot = await borrowerRef.get();
      final lenderSnapshot = await lenderRef.get();

      int borrowerAmount = 0;
      if (borrowerSnapshot.exists) {
        borrowerAmount = (borrowerSnapshot.data() as Map<String, dynamic>?)?['amount'] ?? 0;
      }

      int lenderAmount = 0;
      if (lenderSnapshot.exists) {
        lenderAmount = (lenderSnapshot.data() as Map<String, dynamic>?)?['amount'] ?? 0;
      }

      await _firestore.runTransaction((transaction) async {
        transaction.set(borrowerRef, {'amount': borrowerAmount + amount}, SetOptions(merge: true));
        transaction.set(lenderRef, {'amount': lenderAmount + amount}, SetOptions(merge: true));
      });
    } catch (e) {
      throw Exception('Failed to borrow amount: $e');
    }
  }

  Future<Map<String, int>> getBorrowedAmounts(String groupName, String borrower) async {
    try {
      final borrowerRef = _firestore.collection('borrows').doc(groupName).collection('members').doc(borrower);
      final borrowerSnapshot = await borrowerRef.get();

      if (borrowerSnapshot.exists) {
        final borrowedFromRef = borrowerRef.collection('borrowedFrom');
        final borrowedFromSnapshot = await borrowedFromRef.get();

        final borrowedAmounts = <String, int>{};
        for (var doc in borrowedFromSnapshot.docs) {
          borrowedAmounts[doc.id] = doc.data()['amount'] as int;
        }

        return borrowedAmounts;
      } else {
        return {};
      }
    } catch (e) {
      throw Exception('Failed to get borrowed amounts: $e');
    }
  }
}
