import 'package:flutter/material.dart';

class CartModel with ChangeNotifier
{
 final String id, productId, imageUrl,title;
 final int quantity;
 final double price, salePrice;
 final bool isPiece, isOnSale;
 final String address, emailAddress, phoneNumber, userName,userId;
  CartModel({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.salePrice,
    required this.isPiece,
    required this.isOnSale,
    required this.address,
    required this.emailAddress,
    required this.phoneNumber,
    required this.userName,
    required this.userId,
  });
}