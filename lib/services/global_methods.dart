
import 'package:asallah_fruits/const/firebase_const.dart';
import 'package:asallah_fruits/screens/auth/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import '../widgets/text_widget.dart';

class GlobalMethods
{
  static navigateTo({required BuildContext ctx, required String routeName})
  {
    Navigator.pushNamed(ctx, routeName);
  }

  static Future<void> warningDialog({
    required String title,
    required String subtitle,
    required Function fct,
    required BuildContext context,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
                children:
            [
              Image.asset(
                'assets/cat/warning.png',
                height: 25,
                width: 25,
                fit: BoxFit.fill,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(title),
            ]),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(subtitle),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: TextWidget(
                  color: Colors.cyan,
                  text: 'لا',
                  textSize: 22,
                ),
              ),
              TextButton(
                onPressed: () {
                  fct();
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: TextWidget(
                  color: Colors.red,
                  text: 'نعم',
                  textSize: 22,
                ),
              ),
            ],
          );
        });
  }


  static Future<void> errorDialog({
    required String subtitle,
    required BuildContext context,
    String login = '',
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children:
                [
                  Image.asset(
                    'assets/cat/warning.png',
                    height: 25,
                    width: 25,
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Text('حدث خطأ'),
                ]),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(child: Text(subtitle)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: TextWidget(
                  color: Colors.cyan,
                  text: 'حاول مرة اخرى',
                  textSize: 20,
                ),
              ),
              TextButton(
                onPressed: ()
                {
                  Navigator.pushReplacementNamed(context, LoginScreen.routeName,);
                },
                child: TextWidget(
                  color: Colors.cyan,
                  text: login,
                  textSize: 20,
                ),
              ),
            ],
          );
        });
  }
  static Future<void> addToCart (
  {
      required String productId,
      required int quantity,
      required BuildContext context,
    required String imageUrl,
    required String title,
    required double price,
    required double salePrice,
    required bool isPiece,
    required bool isOnSale,
  })
  async {
    final User? user = authInstance.currentUser;
    final uid = user!.uid;
    final cartId = const Uuid().v4();
    try
    {
      FirebaseFirestore
          .instance
          .collection('users')
          .doc(uid)
          .update(
          {
           'userCart' : FieldValue.arrayUnion(
               [
                 {
                   'cartId' : cartId,
                   'productId' : productId,
                   'quantity' : quantity,
                   'imageUrl' : imageUrl,
                   'title' : title,
                   'price' : price,
                   'salePrice' : salePrice,
                   'isPiece' : isPiece,
                   'isOnSale' : isOnSale,
                 }
                 ]
           ),
          });
      Fluttertoast.showToast(
          msg: "تم اضافة المنتج الي سلة المشتريات بنجاح",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }catch (error)
    {
      errorDialog(
          subtitle: error.toString(),
          context: context,
      );
    }
  }

  static Future<void> addToWishlist (
      {
        required String productId,
        required BuildContext context,
      }) async
  {
    final User? user = authInstance.currentUser;
    final uid = user!.uid;
    final wishlistId = const Uuid().v1();
    try
    {
      FirebaseFirestore
          .instance
          .collection('users')
          .doc(uid)
          .update(
          {
            'userWish' : FieldValue.arrayUnion([
              {
                'wishlistId' : wishlistId ,
                'productId' : productId,
              }]
            ),
          });
      Fluttertoast.showToast(
          msg: "تم اضافة المنتج الي المفضلة بنجاح",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }catch (error)
    {
      errorDialog(
        subtitle: error.toString(),
        context: context,
      );
    }
  }
}