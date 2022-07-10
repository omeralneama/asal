import 'package:asallah_fruits/inner_screens/prouducts_details.dart';
import 'package:asallah_fruits/models/product_model.dart';
import 'package:asallah_fruits/providers/cart_provider.dart';
import 'package:asallah_fruits/services/global_methods.dart';
import 'package:asallah_fruits/widgets/pricee_widget.dart';
import 'package:asallah_fruits/widgets/text_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../const/firebase_const.dart';
import '../providers/wishlist_provider.dart';
import '../services/utils.dart';
import 'heart_btn.dart';

class FeedsItemsWidget extends StatefulWidget {
  const FeedsItemsWidget({
  Key? key,
 }) : super(key: key);
  @override
  State<FeedsItemsWidget> createState() => _FeedsItemsWidgetState();
}

class _FeedsItemsWidgetState extends State<FeedsItemsWidget>
{
  final quantityTextController = TextEditingController();
  @override
  void initState()
  {
    quantityTextController.text='1';
    super.initState();
  }
  @override
  void dispose()
  {
    quantityTextController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context)
  {
    Size size = Utils(context).screenSize;
    final Color color = Utils(context).color;
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    bool? isInWishlist = wishlistProvider.getWishlistItems.containsKey(productModel.id);

    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: ()
        {
          Navigator.pushNamed(
            context, ProductDetails.routeName,
            arguments: productModel.id,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          child: Column(
            children:
            [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: FancyShimmerImage(
                  imageUrl: productModel.imageUrl,
                  height: size.width*0.23,
                  width: size.width*0.25,
                  boxFit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
                  [
                    Flexible(
                      flex: 3,
                      child: TextWidget(
                      text: productModel.title,
                      color: color,
                      textSize: 18,
                  maxLines: 1,
                  isTitle: true,
                ),
                    ),
                     Flexible(
                      flex: 1,
                        child: HeartBtn(
                          productId: productModel.id,
                          isInWishlist: isInWishlist,
                        )
                     ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
                  [
                     Flexible(
                       flex : 2,
                       child: PriceWidget(
                         isOnSale: productModel.isOnSale,
                         price: productModel.price,
                         salePrice: productModel.salePrice,
                         textPrice: quantityTextController.text,
                       ),
                     ),
                    const SizedBox(width: 5,),
                    FittedBox(
                      child: TextWidget(
                        text: productModel.isPiece? '1 حبة' : '1 كيلو',
                        color: color,
                        textSize: 18,
                        isTitle: true,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: isInCart
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
                      productId: productModel.id,
                      quantity: int.parse(quantityTextController.text),
                      context: context,
                      isPiece: productModel.isPiece,
                      price: productModel.price,
                      imageUrl: productModel.imageUrl,
                      salePrice: productModel.salePrice,
                      isOnSale: productModel.isOnSale,
                      title: productModel.title,
                    );
                    await cartProvider.fetchCart();
                  },
                  child: TextWidget(
                      text: isInCart ? 'تم إضافته' : 'أضف الي السلة ',
                      color: color,
                      textSize: 18,
                    isTitle: true,
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Theme.of(context).cardColor,),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12.0),
                        bottomRight: Radius.circular(12.0),
                        ))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
