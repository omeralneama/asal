import 'package:asallah_fruits/widgets/heart_btn.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../const/firebase_const.dart';
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';
import '../providers/viewed_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';
import '../widgets/text_widget.dart';

class ProductDetails extends StatefulWidget {
  static const routeName = '/ProductDetails';

  const ProductDetails({Key? key}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final _quantityTextController = TextEditingController(text: '1');

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).screenSize;
    final Color color = Utils(context).color;
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrentProduct = productProvider.findProductById(productId);

    double usedPrice = getCurrentProduct.isOnSale ? getCurrentProduct.salePrice : getCurrentProduct.price;
    double totalPrice = usedPrice * int.parse(_quantityTextController.text);
    bool? isInCart = cartProvider.getCartItems.containsKey(getCurrentProduct.id);
    bool? isInWishlist = wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);
    final viewedProductProvider = Provider.of<ViewedProductProvider>(context);

    return WillPopScope(
      onWillPop: () async
      {
        viewedProductProvider.addProductToHistory(productId: productId);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
            leading: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: ()
              {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: color,
                size: 24,
              ),
            ),
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor),
        body: Column(
            children:
        [
                Flexible(
                flex: 2,
                // الصورة
                child: FancyShimmerImage(
                  imageUrl: getCurrentProduct.imageUrl,
                  boxFit: BoxFit.scaleDown,
                  width: size.width,
                  // height: screenHeight * .4,
                ),
              ),
                Flexible(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                // العنوان
                                child: TextWidget(
                                  text: getCurrentProduct.title,
                                  color: color,
                                  textSize: 25,
                                  isTitle: true,
                                ),
                              ),
                              // اضف للمفضة
                              HeartBtn(
                                productId: getCurrentProduct.id,
                                isInWishlist: isInWishlist,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // السعر
                              TextWidget(
                                text: '${usedPrice.toStringAsFixed(2)}\ ريال',
                                color: Colors.green,
                                textSize: 18,
                                isTitle: true,
                              ),
                              // كيلو / حبة
                              TextWidget(
                                text: getCurrentProduct.isPiece ? '/حبة' : '/كيلو',
                                color: color,
                                textSize: 12,
                                isTitle: false,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              // التخفيض
                              Visibility(
                                visible: getCurrentProduct.isOnSale ? true : false,
                                child: Text(
                                  '${getCurrentProduct.price.toStringAsFixed(2)}\ ريال',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: color,
                                      decoration: TextDecoration.lineThrough),
                                ),
                              ),
                              const Spacer(),
                              // توصيل مجاني
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                    color: const Color.fromRGBO(63, 200, 101, 1),
                                    borderRadius: BorderRadius.circular(5)),
                                child: TextWidget(
                                  text: 'توصيل مجاني',
                                  color: Colors.white,
                                  textSize: 20,
                                  isTitle: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        // زايد و ناقص
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            quantityControl(
                              fct: () {
                                setState(() {
                                  _quantityTextController.text =
                                      (int.parse(_quantityTextController.text) + 1)
                                          .toString();
                                });
                              },
                              icon: CupertinoIcons.plus,
                              color: Colors.green,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              flex: 1,
                              child: TextField(
                                controller: _quantityTextController,
                                key: const ValueKey('quantity'),
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                ),
                                textAlign: TextAlign.center,
                                cursorColor: Colors.green,
                                enabled: true,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    if (value.isEmpty) {
                                      _quantityTextController.text = '1';
                                    } else {}
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            quantityControl(
                              fct: () {
                                if (_quantityTextController.text == '1') {
                                  return;
                                } else {
                                  setState(() {
                                    _quantityTextController.text =
                                        (int.parse(_quantityTextController.text) - 1)
                                            .toString();
                                  });
                                }
                              },
                              icon: CupertinoIcons.minus,
                              color: Colors.red,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          width: double.infinity,
                          padding:
                          const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // كلمة الاجمالي
                                    TextWidget(
                                      text: 'الاجمالي',
                                      color: Colors.red.shade300,
                                      textSize: 20,
                                      isTitle: true,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    FittedBox(
                                      child: Row(
                                        children: [
                                          // السعر الاجمالي
                                          TextWidget(
                                            text: '${totalPrice.toStringAsFixed(2)}\ ريال/',
                                            color: color,
                                            textSize: 18,
                                            isTitle: true,
                                          ),
                                          // حبة كيلو
                                          TextWidget(
                                            text: getCurrentProduct.isPiece ? '${_quantityTextController.text}حبة' : '${_quantityTextController.text}كيلو',
                                            color: color,
                                            textSize: 16,
                                            isTitle: false,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              // اضف الي السلة
                              Flexible(
                                child: Material(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10),
                                  child: InkWell(
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
                                        quantity: int.parse(_quantityTextController.text),
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
                                    borderRadius: BorderRadius.circular(10),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: TextWidget(
                                        text: isInCart ? 'تم إضافته الي السلة' : 'أضف الي السلة ',
                                        color: Colors.white,
                                        textSize: 18,
                                        isTitle: true,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ]
        ),
      ),
    );
  }

  // دالة العدد
  Widget quantityControl(
      {required Function fct, required IconData icon, required Color color}) {
    return Flexible(
      flex: 2,
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: color,
        child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              fct();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                color: Colors.white,
                size: 25,
              ),
            )),
      ),
    );
  }
}
