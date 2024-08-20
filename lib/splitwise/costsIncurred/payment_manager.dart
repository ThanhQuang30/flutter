// import 'dart:math';
//
// class Solution {
//   double minTransfers(List<List<int>> transactions) {
//     Map<int, int> score = {};
//
//     for (List<int> transaction in transactions) {
//       int from = transaction[0];
//       int to = transaction[1];
//       int amount = transaction[2];
//
//       score[from] = (score[from] ?? 0) - amount;
//       score[to] = (score[to] ?? 0) + amount;
//     }
//
//     List<int> positives = [];
//     List<int> negatives = [];
//
//     score.forEach((key, value) {
//       if (value > 0) {
//         positives.add(value);
//       } else if (value < 0) {
//         negatives.add(-value);
//       }
//     });
//
//     return recurse(positives, negatives);
//   }
//
//   double recurse(List<int> positives, List<int> negatives) {
//     if (positives.isEmpty) return 0;
//
//     int positive = positives[0];
//     List<int> newPositives = List.from(positives);
//     newPositives.removeAt(0);
//
//     double count = double.infinity;
//
//     for (int negative in negatives) {
//       List<int> newNegatives = List.from(negatives);
//       newNegatives.remove(negative);
//
//       if (positive == negative) {
//         count = min(count, 1 + recurse(newPositives, newNegatives));
//       } else if (positive > negative) {
//         newPositives.insert(0, positive - negative);
//         count = min(count, 1 + recurse(newPositives, newNegatives));
//       } else {
//         newNegatives.insert(0, negative - positive);
//         count = min(count, 1 + recurse(newPositives, newNegatives));
//       }
//     }
//
//     return count == double.infinity ? double.infinity : count;
//   }
//
//   List<List<int>> minimizeCashFlow(List<List<int>> transactions) {
//     List<int> netAmounts = List.filled(transactions.length, 0);
//
//     for (List<int> transaction in transactions) {
//       int from = transaction[0];
//       int to = transaction[1];
//       int amount = transaction[2];
//       netAmounts[from] -= amount;
//       netAmounts[to] += amount;
//     }
//
//     return minimizeCashFlowRecursive(netAmounts);
//   }
//
//   List<List<int>> minimizeCashFlowRecursive(List<int> netAmounts) {
//     int maxCreditIndex = netAmounts.indexWhere((e) => e == netAmounts.reduce(max));
//     int maxDebitIndex = netAmounts.indexWhere((e) => e == netAmounts.reduce(min));
//
//     if (netAmounts[maxCreditIndex] == 0 && netAmounts[maxDebitIndex] == 0) return [];
//
//     int minAmount = min(-netAmounts[maxDebitIndex], netAmounts[maxCreditIndex]);
//     netAmounts[maxCreditIndex] -= minAmount;
//     netAmounts[maxDebitIndex] += minAmount;
//
//     List<int> transaction = [maxCreditIndex, maxDebitIndex, minAmount]; // Đổi thứ tự
//     List<List<int>> transactions = minimizeCashFlowRecursive(netAmounts);
//     transactions.add(transaction);
//
//     return transactions;
//   }
// }

//----------------------------------------------------------------------
import 'dart:collection';

import 'package:intl/intl.dart';

class Edge {
  late int v;
  late int flow;
  late int capacity;
  late int rev;
  late bool back;

  Edge(this.v, this.flow, this.capacity, this.rev, this.back);
}

class Graph {
  late int V;
  late List<List<Edge>> adj;
  late List<String> names;
  late Map<String, int> mp;
  late List<int> level;

  Graph(int V) {
    this.V = V;
    adj = List.generate(V, (index) => []);
    level = List.generate(V, (index) => -1);
    names = [];
    mp = {};
  }

  void addEdge(String name1, String name2, int capacity) {
    int u = names.length;
    int v = names.length + 1;

    if (!mp.containsKey(name1)) {
      names.add(name1);
      mp[name1] = names.length - 1;
    }
    u = mp[name1]!;

    if (!mp.containsKey(name2)) {
      names.add(name2);
      mp[name2] = names.length - 1;
    }
    v = mp[name2]!;

    Edge a = Edge(v, 0, capacity, adj[v].length, false); // Forward edge
    Edge b = Edge(u, 0, 0, adj[u].length, true); // Back edge

    adj[u].add(a);
    adj[v].add(b); // Reverse edge
  }

  bool BFS(int s, int t) {
    for (int i = 0; i < V; i++) {
      level[i] = -1;
    }

    level[s] = 0;
    Queue<int> q = Queue();
    q.add(s);

    while (q.isNotEmpty) {
      int u = q.removeFirst();
      for (Edge e in adj[u]) {
        if (level[e.v] < 0 && e.flow < e.capacity) {
          level[e.v] = level[u] + 1;
          q.add(e.v);
        }
      }
    }
    return level[t] < 0 ? false : true;
  }

  int sendFlow(int u, int flow, int t, List<int> start) {
    if (u == t) return flow;

    for (; start[u] < adj[u].length; start[u]++) {
      Edge e = adj[u][start[u]];
      if (level[e.v] == level[u] + 1 && e.flow < e.capacity) {
        int currFlow = flow < e.capacity - e.flow ? flow : e.capacity - e.flow;
        int tempFlow = sendFlow(e.v, currFlow, t, start);

        if (tempFlow > 0) {
          e.flow += tempFlow;
          adj[e.v][e.rev].flow -= tempFlow;
          return tempFlow;
        }
      }
    }
    return 0;
  }

  int DinicMaxflow(int s, int t) {
    if (s == t) return -1;

    int total = 0;

    while (BFS(s, t)) {
      List<int> start = List.filled(V + 1, 0);
      int flow;
      while ((flow = sendFlow(s, 1000000000, t, start)) != 0) {
        total += flow;
      }
    }
    return total;
  }

  List<String> kernelFunction() {
    List<int> balances = List.filled(V, 0);

    // Tính toán số dư của từng thành viên
    for (int u = 0; u < V; u++) {
      for (Edge e in adj[u]) {
        if (!e.back) {
          int amount = e.capacity - e.flow;
          balances[u] -= amount;
          balances[e.v] += amount;
        }
      }
    }

    // Tạo danh sách các thành viên đã sắp xếp theo số dư tăng dần
    List<int> sortedIndices = List.generate(V, (index) => index);
    sortedIndices.sort((a, b) => balances[a].compareTo(balances[b]));

    List<String> payments = [];

    // Tối ưu số lượng giao dịch
    int i = 0;
    int j = V - 1;
    while (i < j) {
      if (balances[sortedIndices[i]] == 0) {
        i++;
        continue;
      }
      if (balances[sortedIndices[j]] == 0) {
        j--;
        continue;
      }

      int min = balances[sortedIndices[i]].abs() < balances[sortedIndices[j]].abs()
          ? balances[sortedIndices[i]].abs()
          : balances[sortedIndices[j]].abs();
      payments.add('${names[sortedIndices[i]]} pays to ${names[sortedIndices[j]]}: ${NumberFormat.decimalPattern().format(min)} VND');

      balances[sortedIndices[i]] += balances[sortedIndices[i]] > 0 ? -min : min;
      balances[sortedIndices[j]] += balances[sortedIndices[j]] > 0 ? -min : min;
    }

    return payments;
  }

}