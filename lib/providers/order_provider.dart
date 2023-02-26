import 'package:asallah_fruits/models/orders_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class OrdersProvider with ChangeNotifier
{
  static List<OrderModel> orders = [];
  List<OrderModel> get getOrders
  {
    return orders;
  }

  Future<void> fetchOrders () async
  {
    await FirebaseFirestore
        .instance
        .collection('orders')
        .get()
        .then((QuerySnapshot ordersSnapshot)
    {
      orders = [];
      ordersSnapshot.docs.forEach((element) {
        orders.insert(
          0,
          OrderModel(
            orderId: element.get('orderId'),
            totalPrice: element.get('totalPrice'),
            orderDate: element.get('orderDate'), 
            userId: element.get('userId'),
          ),
        );
      });
    });
    notifyListeners();
  }
  void clearLocalOrders()
  {
    orders = [];
    notifyListeners();
  }
}
