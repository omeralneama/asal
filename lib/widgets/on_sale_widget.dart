import 'package:asallah_fruits/widgets/pricee_widget.dart';
import 'package:asallah_fruits/widgets/text_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../const/firebase_const.dart';
import '../inner_screens/prouducts_details.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';
import 'heart_btn.dart';

class OnSaleWidget extends StatefulWidget {
  const OnSaleWidget({Key? key}) : super(key: key);

  @override
  State<OnSaleWidget> createState() => _OnSaleWidget();
}

class _OnSaleWidget extends State<OnSaleWidget>
{
  @override
  Widget build(BuildContext context)
  {
    final Color color = Utils(context).color;
    Size size = Utils(context).screenSize;
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    bool? isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? isInWishlist = wishlistProvider.getWishlistItems.containsKey(productModel.id);
    return Material(
      color: Theme.of(context).cardColor.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: ()
        {
          Navigator.pushNamed(
              context, ProductDetails.routeName,
              arguments: productModel.id,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children:
            [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                [
                  FancyShimmerImage(imageUrl: productModel.imageUrl,
                    height: size.width*0.20,
                    width: size.width*0.24,
                    boxFit: BoxFit.fill,
                  ),
                  Column(
                    children:
                    [
                      TextWidget
                        (
                        text: productModel.isPiece ? '1 حبة' : '1 كيلو',
                          color: color,
                          textSize: 16,
                        isTitle: true,
                      ),
                      GestureDetector(
                        onTap: isInCart
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
                              productId: productModel.id,
                              quantity: 1,
                              context: context,
                           isPiece: productModel.isPiece,
                           price: productModel.price,
                           imageUrl: productModel.imageUrl,
                           salePrice: productModel.salePrice,
                           isOnSale: productModel.isOnSale,
                           title: productModel.title,
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
                        child: Icon(
                            isInCart ? IconlyBold.bag2 : IconlyLight.bag2,
                          size: 22,
                          color: isInCart ? Colors.green : color,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      HeartBtn(
                        productId: productModel.id,
                        isInWishlist: isInWishlist,
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children:
                [
                   Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: PriceWidget(
                      isOnSale: true,
                      price: productModel.price,
                      salePrice: productModel.salePrice,
                      textPrice: '1',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: TextWidget(
                      maxLines: 2,
                        text: productModel.title,
                        color: color,
                        textSize: 18,
                      isTitle: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
