import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../const/firebase_const.dart';
import '../models/wishlist_model.dart';

class WishlistProvider with ChangeNotifier
{
  Map<String, WishlistModel> wishlistItems = {};

  Map<String, WishlistModel> get getWishlistItems
  {
    return wishlistItems;
  }
  final userCollection = FirebaseFirestore.instance.collection('users');
  Future<void> fetchWish() async
  {
    final User? user = authInstance.currentUser;
    final DocumentSnapshot userDoc =
    await userCollection.doc(user!.uid).get();
    if(userDoc == null)
    {
      return;
    }
    final leng = userDoc.get('userWish').length;
    for(int i = 0; i < leng; i ++)
    {
      wishlistItems.putIfAbsent(userDoc.get('userWish')[i]['productId'],
            () => WishlistModel(
          id: userDoc.get('userWish')[i]['wishlistId'],
          productId: userDoc.get('userWish')[i]['productId'],
        ),);
    }
    notifyListeners();
  }

  Future<void> removeOneItem({
    required String productId,
    required String wishlistId,
  }) async
  {
    final User? user = authInstance.currentUser;
    await userCollection.doc(user!.uid).update(
        {
          'userWish' : FieldValue.arrayRemove(
              [
                {
                  'wishlistId': wishlistId,
                  'productId': productId,
                }
              ])
        });
    wishlistItems.remove(productId,);
    Fluttertoast.showToast(
        msg: "تم حذف المنتج الي المفضلة بنجاح",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
    );
    await fetchWish();
    notifyListeners();
  }

  Future<void> clearOnlineWish() async
  {
    final User? user = authInstance.currentUser;
    await userCollection.doc(user!.uid).update(
        {
          'userWish' : [],
        });
    wishlistItems.clear();
    notifyListeners();
  }

  void clearLocalWishlist()
  {
    wishlistItems.clear();
    notifyListeners();
  }
}