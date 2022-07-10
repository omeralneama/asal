import 'package:asallah_fruits/inner_screens/prouducts_details.dart';
import 'package:asallah_fruits/services/global_methods.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../const/firebase_const.dart';
import '../../models/wishlist_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/products_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../services/utils.dart';
import '../../widgets/heart_btn.dart';
import '../../widgets/text_widget.dart';
class WishlistWidget extends StatelessWidget {
  const WishlistWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    final Color color = Utils(context).color;
    Size size = Utils(context).screenSize;
    final productProvider = Provider.of<ProductsProvider>(context);
    final wishlistModel = Provider.of<WishlistModel>(context);
    final getCurrentProduct = productProvider.findProductById(wishlistModel.productId);
    double usedPrice = getCurrentProduct.isOnSale ? getCurrentProduct.salePrice : getCurrentProduct.price;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? isInWishlist = wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);
    final cartProvider = Provider.of<CartProvider>(context);
    bool? isInCart = cartProvider.getCartItems.containsKey(getCurrentProduct.id);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: ()
        {
          Navigator.pushNamed(context, ProductDetails.routeName,
            arguments: wishlistModel.productId,
          );
        },
          child: Container(
            height: size.height*0.20,
            width: size.width*0.20,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    height: size.width * 0.2,
                    width: size.width * 0.2,
                    child: FancyShimmerImage(
                      imageUrl: getCurrentProduct.imageUrl,
                      boxFit: BoxFit.fill,
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: isInCart
                              ? null
                              :  () async {
                                final User? user = authInstance.currentUser;
                              if(user == null)
                              {
                              GlobalMethods.errorDialog(
                               login: 'تسجيل الدخول',
                               subtitle: 'الرجاء تسجيل الدخول',
                               context: context,
                              );
                               return ;
                               }
                                await GlobalMethods.addToCart(
                                productId: getCurrentProduct.id,
                                quantity: 1,
                                context: context,
                                  isPiece: getCurrentProduct.isPiece,
                                  price: getCurrentProduct.price,
                                  imageUrl: getCurrentProduct.imageUrl,
                                  salePrice: getCurrentProduct.salePrice,
                                  isOnSale: getCurrentProduct.isOnSale,
                                  title: getCurrentProduct.title,
                                );
                                await cartProvider.fetchCart();
                                Fluttertoast.showToast(
                                    msg: "تم إضافة المنتج الي سلة المشتريات بنجاح",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                               },
                              icon: Icon(
                                isInCart ? IconlyBold.bag2 : IconlyLight.bag2,
                                size: 22,
                                color: isInCart ? Colors.green : color,
                              ),
                            ),
                            HeartBtn(
                              productId: getCurrentProduct.id,
                              isInWishlist: isInWishlist,
                            ),
                          ],
                        ),
                      ),
                      TextWidget(
                        text: getCurrentProduct.title,
                        color: color,
                        textSize: 18.0,
                        maxLines: 1,
                        isTitle: true,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextWidget(
                        text: '${usedPrice.toStringAsFixed(2)} \ ريال',
                        color: color,
                        textSize: 15.0,
                        maxLines: 1,
                        isTitle: true,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
      ),
    );
  }
}
