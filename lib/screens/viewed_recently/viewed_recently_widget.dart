import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import '../../const/firebase_const.dart';
import '../../inner_screens/prouducts_details.dart';
import '../../models/viewed_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/products_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/text_widget.dart';

class ViewedRecentlyWidget extends StatefulWidget {
  const ViewedRecentlyWidget({Key? key}) : super(key: key);

  @override
  _ViewedRecentlyWidgetState createState() => _ViewedRecentlyWidgetState();
}

class _ViewedRecentlyWidgetState extends State<ViewedRecentlyWidget> {
  @override
  Widget build(BuildContext context) {
    Color color = Utils(context).color;
    Size size = Utils(context).screenSize;
    final productProvider = Provider.of<ProductsProvider>(context);
    final viewedProductModel = Provider.of<ViewedProductModel>(context);
    final getCurrentProduct = productProvider.findProductById(viewedProductModel.productId);
    double usedPrice = getCurrentProduct.isOnSale ? getCurrentProduct.salePrice : getCurrentProduct.price;
    final cartProvider = Provider.of<CartProvider>(context);
    bool? isInCart = cartProvider.getCartItems.containsKey(getCurrentProduct.id);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:  GestureDetector(
        onTap: ()
        {
          Navigator.pushNamed(context, ProductDetails.routeName,
            arguments: viewedProductModel.productId,
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // الصورة
            FancyShimmerImage(
              imageUrl: getCurrentProduct.imageUrl,
              boxFit: BoxFit.fill,
              height: size.width * 0.25,
              width: size.width * 0.27,
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              children: [
                // العنوان
                TextWidget(
                  text: getCurrentProduct.title,
                  color: color,
                  textSize: 24,
                  isTitle: true,
                ),
                const SizedBox(
                  height: 12,
                ),
                // السعر
                TextWidget(
                  text: '${usedPrice.toStringAsFixed(2)} \ ريال',
                  color: color,
                  textSize: 20,
                  isTitle: false,
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.green,
                    child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: isInCart
                          ? null
                              : () async {
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
                          },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          // زرار اضف للسلة
                          child: Icon(
                           isInCart
                           ? Icons.check
                               : IconlyBold.plus,
                            color: Colors.white,
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextWidget(
                    text: isInCart ? 'تم إضافته' : 'أضف الي السلة ',
                    color: color,
                    textSize: 18,
                    isTitle: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }
}
