
import 'package:asallah_fruits/const/firebase_const.dart';
import 'package:asallah_fruits/models/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier
{
  Map<String, CartModel> cartItems = {};

  Map<String, CartModel> get getCartItems
  {
    return cartItems;
  }

  final userCollection = FirebaseFirestore.instance.collection('users');
  Future<void> fetchCart() async
  {
    final User? user = authInstance.currentUser;
    final DocumentSnapshot userDoc =
    await userCollection.doc(user!.uid).get();
    if(userDoc == null)
    {
      return;
    }else
      {
        final length = userDoc.get('userCart').length;
        for(int i = 0; i < length; i ++)
        {
          cartItems.putIfAbsent(
            userDoc.get('userCart')[i]['productId'],
                () => CartModel(
                  id: userDoc.get('userCart')[i]['cartId'],
                  productId: userDoc.get('userCart')[i]['productId'],
                  quantity: userDoc.get('userCart')[i]['quantity'],
                  salePrice: userDoc.get('userCart')[i]['salePrice'],
                  imageUrl: userDoc.get('userCart')[i]['imageUrl'],
                  title: userDoc.get('userCart')[i]['title'],
                  price: userDoc.get('userCart')[i]['price'],
                  isPiece: userDoc.get('userCart')[i]['isPiece'],
                  isOnSale: userDoc.get('userCart')[i]['isOnSale'],
                  phoneNumber: userDoc.get('phone'),
                  userName: userDoc.get('name'),
                  address: userDoc.get('address'),
                  userId: userDoc.get('id'),
                  emailAddress: userDoc.get('email'),
                ),);
        }
      }
    notifyListeners();
  }

  void reduceQuantityByOne(String productId)
  {
    cartItems.update(productId,
          (value) => CartModel(
      id : value.id,
      productId: productId,
      quantity: value.quantity - 1,
            price: value.price,
            imageUrl: value.imageUrl,
            salePrice:value.salePrice,
            isPiece: value.isPiece,
            title: value.title,
            isOnSale: value.isOnSale,
            address: value.address,
            phoneNumber: value.phoneNumber,
            userId: value.userId,
            emailAddress: value.emailAddress,
            userName: value.userName,
          ),
    );
    notifyListeners();
  }
  void increaseQuantityByOne(String productId)
  {
    cartItems.update(productId,
          (value) => CartModel(
        id : value.id,
        productId: productId,
        quantity: value.quantity + 1,
            price: value.price,
            imageUrl: value.imageUrl,
            salePrice:value.salePrice,
            isPiece: value.isPiece,
            title: value.title,
            isOnSale: value.isOnSale,
            address: value.address,
            phoneNumber: value.phoneNumber,
            userId: value.userId,
            emailAddress: value.emailAddress,
            userName: value.userName,
      ),
    );
    notifyListeners();
  }
  Future<void> removeOneItem({
    required String productId,
    required String cartId,
    required int quantity,
}) async
  {
    final User? user = authInstance.currentUser;
    await userCollection.doc(user!.uid).update(
      {
        'userCart' : FieldValue.arrayRemove(
          [
            {
          'cartId': cartId,
          'productId': productId,
          'quantity': quantity,
           }
      ])
      });
    cartItems.remove(productId,);
    await fetchCart();
    notifyListeners();
  }
  Future<void> clearOnlineCart() async
  {
    final User? user = authInstance.currentUser;
    await userCollection.doc(user!.uid).update(
        {
          'userCart' : [],
        });
    notifyListeners();
  }
  void clearLocalCart()
  {
    cartItems.clear();
    notifyListeners();
  }
}