import 'package:asallah_fruits/const/firebase_const.dart';
import 'package:asallah_fruits/providers/cart_provider.dart';
import 'package:asallah_fruits/providers/order_provider.dart';
import 'package:asallah_fruits/providers/products_provider.dart';
import 'package:asallah_fruits/providers/wishlist_provider.dart';
import 'package:asallah_fruits/screens/btm_bar_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class FetchScreen extends StatefulWidget
{
  static const routeName = '/FetchScreen';
  const FetchScreen({Key? key}) : super(key: key);

  @override
  State<FetchScreen> createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen>
{
  @override
  void initState()
  {
    Future.delayed(const Duration(microseconds: 5,),
        ()async
        {
          final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
          final cartProvider = Provider.of<CartProvider>(context, listen: false);
          final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
          final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
          final User? user = authInstance.currentUser;
          if(user == null)
          {
            await productsProvider.fetchProduct();
            cartProvider.clearLocalCart();
            wishlistProvider.clearLocalWishlist();
            ordersProvider.clearLocalOrders();
          } else
            {
              await productsProvider.fetchProduct();
              await cartProvider.fetchCart();
              await wishlistProvider.fetchWish();
            }
          Navigator.pushReplacementNamed(context, BottomBarScreen.routeName,);
        });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children:
          [
            Image.asset(
                'assets/cat/home2.png',
              fit: BoxFit.cover,
              height: double.infinity,
            ),
            Container(
              color: Colors.black.withOpacity(0.7),
                ),
           const Center(
             child: SpinKitFadingFour(
            color: Colors.white,
             ),
           )
          ],
        ),
    );
  }
}
