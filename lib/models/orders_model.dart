import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderModel with ChangeNotifier
{
final String orderId, userId;
final Timestamp orderDate;
final double totalPrice;
    OrderModel(
      {
        required this.orderId,
          required this.totalPrice,
        required this.orderDate,
        required this.userId,
      });
}