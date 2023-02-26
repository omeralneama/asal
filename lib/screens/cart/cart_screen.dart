import 'package:asallah_fruits/providers/order_provider.dart';
import 'package:asallah_fruits/screens/cart/cart_widget.dart';
import 'package:asallah_fruits/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../providers/cart_provider.dart';
import '../../providers/products_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/empty_screen.dart';

class CartScreen extends StatefulWidget
{
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int groupValue = 1;
  bool? isCashPayment = true;
  @override
  Widget build(BuildContext context)
  {
    final Color color = Utils(context).color;
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemsList = cartProvider.getCartItems.values.toList().reversed.toList();
   return cartItemsList.isEmpty
    ? const EmptyScreen(
        imagePath: 'assets/cat/empty cart.png',
        buttonText: 'تسوق الآن',
        title: 'سلة المشتريات فارغة',
      )
      : Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: TextWidget(
            text: 'سلة المشتريات (${cartItemsList.length})',
            color: color,
            textSize: 20,
            isTitle: true,
          ),
          actions: [
            IconButton(
              onPressed: ()
              {
                GlobalMethods.warningDialog(
                  title: 'مسح سلة المشتريات',
                  subtitle: 'هل أنت متأكد ؟',
                  fct: () async
                  {
                    await cartProvider.clearOnlineCart();
                    cartProvider.clearLocalCart();
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

                  context: context,
                );
              },
              icon: const Icon(IconlyBold.delete,),
              color: color,
              alignment: Alignment.topLeft,
            ),
          ],
        ),
        body:  Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // طلب الان
              checkOut(ctx: context),
              // قايمة بالاشياء المطلوبة
              Expanded(
                child: ListView.builder(
                    itemCount: cartItemsList.length,
                    itemBuilder: (ctx, index)
                    {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ChangeNotifierProvider.value(
                          value: cartItemsList[index],
                            child: CartWidget(
                              q: cartItemsList[index].quantity,
                            )),
                      );
                    }
                ),
              ),
            ],
          ),
        ),
      );
  }

// طلب الان
  Widget checkOut({required BuildContext ctx})
  {
    final Color color = Utils(ctx).color;
    Size size = Utils(ctx).screenSize;
    final cartProvider = Provider.of<CartProvider>(ctx);
    final productProvider = Provider.of<ProductsProvider>(ctx);
    final ordersProvider = Provider.of<OrdersProvider>(ctx);
    double total = 0.0;
    TimeOfDay now = TimeOfDay.now(); // or DateTime object
    TimeOfDay openingTime = TimeOfDay(hour: 8, minute:1,); // or leave as DateTime object
    TimeOfDay closingTime = TimeOfDay(hour: 23, minute:1); // or leave as DateTime object

    int shopOpenTimeInSeconds = openingTime.hour * 60 + openingTime.minute;
    int shopCloseTimeInSeconds = closingTime.hour * 60 + closingTime.minute;
    int timeNowInSeconds = now.hour * 60 + now.minute;

    cartProvider.getCartItems.forEach((key, value)
    {
      final getCurrentProduct = productProvider.findProductById(value.productId);
      total += (getCurrentProduct.isOnSale
          ? getCurrentProduct.salePrice
          : getCurrentProduct.price)*value.quantity;
    });
    return SizedBox(
      width: double.infinity,
      height: size.height*0.1,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          child: Row(
            children: [
              // الاجمالي
              FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextWidget(
                    text: 'إجمالي: ${total.toString()}\ ريال',
                    color: color,
                    textSize: 15,
                    isTitle: true,
                  ),
                ),
              ),
              // طريقة الدفع
              Column(
                children:
                [
                  TextWidget(
                    text: 'طريقة الدفع',
                    color: color,
                    textSize: 16,
                  ),
                  // طريقة الدفع
                  Expanded(
                    child: Container(
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        children: [
                          Radio(
                            value: 1,
                            groupValue: groupValue,
                            onChanged: (value)
                            {

                              setState(()
                              {
                                isCashPayment = true;
                                groupValue = 1;
                              });
                            },
                            activeColor: Colors.green,
                          ),
                          TextWidget(
                            text: 'نقداً', color: color, textSize: 13,),
                          Radio(
                            value: 2,
                            groupValue: groupValue,
                            onChanged: (value)
                            {

                              setState(()
                              {
                                isCashPayment = false;
                                groupValue = 2;
                              });
                            },
                            activeColor: Colors.green,
                          ),
                          TextWidget(
                            text: 'شبكة', color: color, textSize: 13,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10,),
              // زرار طلب الان
              Material(
                color : Colors.green,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () async
                  {
                    if(shopOpenTimeInSeconds <= timeNowInSeconds &&
                        timeNowInSeconds <= shopCloseTimeInSeconds )
                    {
                      final orderId = const Uuid().v4();
                      // الدفع
                      // await initPayment(
                      //   amount: total,
                      //   email: user!.email ?? '',
                      //   context: ctx,
                      // );
                      cartProvider.getCartItems.forEach((key, value) async
                      {
                        try {
                          await FirebaseFirestore.instance
                              .collection('orders')
                              .doc(orderId).set({
                            'orderId': orderId,
                            'totalPrice': total,
                            'isCashPayment': isCashPayment,
                            'orderDate': Timestamp.now(),
                            'address' : value.address,
                            'emailAddress': value.emailAddress,
                            'phoneNumber': value.phoneNumber,
                            'userName':value.userName,
                            'userId':value.userId,
                          });
                          await FirebaseFirestore.instance
                              .collection('orders').doc(orderId)
                              .collection('products').doc().set(
                              {
                                'orderId': orderId,
                                'price': (value.isOnSale
                                    ? value.salePrice
                                    : value.price) * value.quantity,
                                'singlePrice': value.price,
                                'singleSalePrice': value.salePrice,
                                'quantity': value.quantity,
                                'title': value.title,
                                'isPiece': value.isPiece,
                              });
                          await cartProvider.clearOnlineCart();
                          cartProvider.clearLocalCart();
                          ordersProvider.fetchOrders();
                          await Fluttertoast.showToast(
                              msg: "عميلنا العزيز تم ارسال طلبك بنجاح و سوف يقوم مندوبنا بالتوصل معك خلال لحظات",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        } catch (error) {
                          GlobalMethods.errorDialog(
                            subtitle: error.toString(),
                            context: ctx,
                          );
                        } finally {
                        }
                      });

                          }else
                          {
                            await Fluttertoast.showToast(
                              msg: "المتجر مغلق حاليا",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                              fontSize: 25.0,);
                          }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextWidget(
                      text: 'طلب الآن',
                      color: Colors.white,
                      textSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // بوبة الدفع الالكتروني
  // Future<void> initPayment({
  //   required String email,
  //   required double amount,
  //   required BuildContext context,
  // }) async
  // {
  //   try
  //   {
  //     // 1 . create payment intent on the server
  //     final response =
  //     await http.post(Uri
  //         .parse('https://us-central1-asallah-fruits.cloudfunctions.net/stripePaymentIntentRequest'),
  //         body: {
  //           'email' : email,
  //           'amount' : amount.toString(),
  //         });
  //     final jsonResponse = jsonDecode(response.body);
  //     log(jsonResponse.toString());
  //     if(jsonResponse['success'] == false)
  //       {
  //         GlobalMethods.errorDialog(subtitle: jsonResponse['حدث خطأ'], context: context);
  //       }
  //     // 2 . initialize the payment sheet
  //     await Stripe.instance
  //         .initPaymentSheet(
  //         paymentSheetParameters : SetupPaymentSheetParameters(
  //           paymentIntentClientSecret: jsonResponse['paymentIntent'],
  //           merchantDisplayName: 'أصالة الثمار',
  //           customerId: jsonResponse['customer'],
  //           customerEphemeralKeySecret: jsonResponse['aphemeralkey'],
  //           testEnv: true,
  //           merchantCountryCode: 'SA.',
  //         ));
  //     await Stripe.instance.presentPaymentSheet();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('عملية الدفع تمت بنجاح'),),);
  //   }catch (error)
  //   {
  //     if(error is StripeException)
  //     {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('حدث خطاء ${error.error.localizedMessage}'),),);
  //     } else
  //     {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('حدث خطاء $error'),
  //         ),
  //       );
  //     }
  //   }
  // }
}
