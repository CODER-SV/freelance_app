import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DataProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> sectionsWithItems = [];
  bool isLoading = true;
  List<Map<String, dynamic>> _recentOrders = [];
  List<Map<String, dynamic>> get recentOrders => _recentOrders;

  Future<void> fetchOrders() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      final snapshot =
          await _firestore
              .collection('orders')
              .where('user_id', isEqualTo: userId)
              .orderBy('order_date', descending: true)
              .get();

      _recentOrders =
          snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
      notifyListeners();
    } catch (e) {
      print("❌ Error fetching orders: $e");
    }
  }

  Future<void> fetchMenuData() async {
    try {
      isLoading = true;
      notifyListeners();

      final sectionsSnapshot = await _firestore.collection('sections').get();

      List<Map<String, dynamic>> tempList = [];

      // Use Future.wait to fetch sections and items concurrently
      final fetchItemFutures = sectionsSnapshot.docs.map((sectionDoc) async {
        final itemsSnapshot =
            await _firestore
                .collection('sections')
                .doc(sectionDoc.id)
                .collection('item')
                .get();

        return {
          'sectionId': sectionDoc.id,
          'items':
              itemsSnapshot.docs
                  .map((itemDoc) => {'id': itemDoc.id, ...itemDoc.data()})
                  .toList(),
        };
      });

      tempList = await Future.wait(fetchItemFutures);

      sectionsWithItems = tempList;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print("❌ Error fetching menu data: $e");
      isLoading = false;
      notifyListeners();
    }
  }
}

// int findSectionIndexByItem(String itemName) {
//   final sections = sectionsWithItems;
//   for (int i = 0; i < sections.length; i++) {
//     final items = sections[i]['items'] as List<dynamic>;
//     if (items.any((item) => item['name'] == itemName)) {
//       return i;
//     }
//   }
//
//   return -1;
// }
