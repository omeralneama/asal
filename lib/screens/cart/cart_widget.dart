import 'package:asallah_fruits/models/cart_model.dart';
import 'package:asallah_fruits/providers/cart_provider.dart';
import 'package:asallah_fruits/providers/products_provider.dart';
import 'package:asallah_fruits/widgets/text_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../inner_screens/prouducts_details.dart';
import '../../providers/wishlist_provider.dart';
import '../../services/utils.dart';
import '../../widgets/heart_btn.dart';

class CartWidget extends StatefulWidget {
  const
  CartWidget({Key? key, required this.q}) : super(key: key);
final int q;
  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget>
{
  final quantityTextController = TextEditingController();
  @override
  void initState()
  {
    quantityTextController.text = widget.q.toString();
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
    final productProvider = Provider.of<ProductsProvider>(context);
    final cartModel = Provider.of<CartModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final getCurrentProduct = productProvider.findProductById(cartModel.productId);
    double usedPrice = getCurrentProduct.isOnSale ? getCurrentProduct.salePrice : getCurrentProduct.price;
    double totalPrice = usedPrice * int.parse(quantityTextController.text);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? isInWishlist = wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);
    return GestureDetector(
      onTap: ()
      {
        Navigator.pushNamed(
          context, ProductDetails.routeName,
          arguments: cartModel.productId,
        );
      },
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // الصورة
                  Container(
                    height: size.width*0.22,
                    width: size.width*0.22,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12,),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: FancyShimmerImage(
                        imageUrl: getCurrentProduct.imageUrl,
                        boxFit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    width: 170.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // العنوان
                        TextWidget(
                            text: getCurrentProduct.title,
                            color: color,
                            textSize: 18,
                          isTitle: true,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 10,),
                        // زايد و ناقص
                        SizedBox(
                          width: size.width*0.3,
                          child: Row(
                            children: [
                              quantityController(
                                color: Colors.green,
                                icon: CupertinoIcons.plus,
                                fct: ()
                                {
                                  cartProvider.increaseQuantityByOne(cartModel.productId);
                                  setState(()
                                  {
                                    quantityTextController.text = ( int.parse(
                                        quantityTextController.text) + 1).toString();
                                  });
                                },
                              ),
                              Flexible(
                                flex : 1,
                                child: TextField(
                                  controller: quantityTextController,
                                  keyboardType: TextInputType.number,
                                  maxLines: 1,
                                  decoration: const InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(),
                                      ),
                                  ),
                                  inputFormatters:
                                  [
                                    FilteringTextInputFormatter.allow(RegExp('[0-9.]')
                                    ),
                                  ],
                                  onChanged: (value)
                                  {
                                    setState(()
                                    {
                                      if(value.isEmpty)
                                        {
                                          quantityTextController.text = '1';
                                        }else
                                        {
                                          return;
                                        }
                                    });
                                  },
                                ),
                              ),
                              quantityController(
                                color: Colors.red,
                                icon: CupertinoIcons.minus,
                                fct: ()
                                {
                                  if(quantityTextController.text == '1')
                                    {
                                      return;
                                    } else
                                      {
                                        cartProvider.reduceQuantityByOne(cartModel.productId);
                                        setState(()
                                        {
                                          quantityTextController.text = ( int.parse(
                                              quantityTextController.text) - 1).toString();
                                        });
                                      }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // حذف
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: HeartBtn(
                            productId: getCurrentProduct.id,
                            isInWishlist: isInWishlist,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () async
                                {
                                  await cartProvider.removeOneItem(
                                      productId: cartModel.productId,
                                      quantity: cartModel.quantity,
                                      cartId: cartModel.id,
                                  );
                                  Fluttertoast.showToast(
                                      msg: "تم الحذف بنجاح",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.grey,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                },
                                child: const Icon(
                                    CupertinoIcons.cart_badge_minus,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 5,),
                              InkWell(
                                onTap: () async
                                {
                                  await cartProvider.removeOneItem(
                                    productId: cartModel.productId,
                                    quantity: cartModel.quantity,
                                    cartId: cartModel.id,
                                  );
                                  Fluttertoast.showToast(
                                      msg: "تم الحذف بنجاح",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.grey,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                },
                                child: const Text(
                                  'حذف',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // السعر
                        TextWidget(
                            text: '${totalPrice.toStringAsFixed(2)} \ريال',
                            color: color,
                            textSize: 15,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget quantityController({
    required Function fct,
    required IconData icon,
    required Color color,
  })
  {
    return Flexible(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: ()
            {
              fct();
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                icon,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
