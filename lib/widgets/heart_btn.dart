import 'package:asallah_fruits/const/firebase_const.dart';
import 'package:asallah_fruits/providers/wishlist_provider.dart';
import 'package:asallah_fruits/services/global_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../services/utils.dart';

class HeartBtn extends StatefulWidget {
  const HeartBtn({
    Key? key,
    required this.productId,
     this.isInWishlist = false,
  }) : super(key: key);
final String productId;
final bool? isInWishlist;

  @override
  State<HeartBtn> createState() => _HeartBtnState();
}

class _HeartBtnState extends State<HeartBtn>
{
  bool loading = false;
  @override
  Widget build(BuildContext context)
  {
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrentProduct = productProvider.findProductById(widget.productId);
    final Color color = Utils(context).color;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return GestureDetector(
      onTap: () async
      {
        setState(()
        {
          loading = true;
        });
        try
        {
          final User? user = authInstance.currentUser;
          if(user == null)
            {
              GlobalMethods.errorDialog(
                  subtitle: 'الرجاء تسجيل الدخول',
                  context: context);
              return;
            }
          if(widget.isInWishlist == false && widget.isInWishlist != null)
            {
             await GlobalMethods.addToWishlist(
                  productId: widget.productId, context: context);
            } else
            {
              await wishlistProvider.removeOneItem(
                  productId: widget.productId,
                  wishlistId: wishlistProvider
                      .getWishlistItems[getCurrentProduct.id]!.id);
            }
          await wishlistProvider.fetchWish();
          setState(()
          {
            loading = false;
          });
        }catch (error)
        {
          GlobalMethods.errorDialog(
              subtitle: '$error',
            context: context,
          );
        }finally
        {
          setState(()
          {
            loading = false;
          });
        }
      },
      child: loading
          ? const Padding(
            padding:  EdgeInsets.all(8.0),
            child: SizedBox(
            height:18,
            width: 18,
            child: CircularProgressIndicator()),
          )
          : Icon(
        widget.isInWishlist !=null && widget.isInWishlist == true
            ? IconlyBold.heart
            : IconlyLight.heart,
        size: 22,
        color: widget.isInWishlist !=null && widget.isInWishlist == true
            ? Colors.red :
        color,
      ),
    );
  }
}
