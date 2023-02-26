import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../const/theme_data.dart';
import '../../providers/order_provider.dart';
import '../../services/utils.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/empty_screen.dart';
import '../../widgets/text_widget.dart';
import 'order_widget.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/OrderScreen';

  const OrdersScreen({Key? key,}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final ordersList = ordersProvider.getOrders;

    return FutureBuilder(
      future: ordersProvider.fetchOrders(),
        builder: (context,snapshot)
    {
      return ordersList.isEmpty
          ? const EmptyScreen(
        imagePath: 'assets/cat/empty cart.png',
        buttonText: 'تسوق الآن',
        title: 'لا توجد لديك طلبات',
      )
          : Scaffold(
          appBar: AppBar(
            leading: const BackWidget(),
            elevation: 0,
            centerTitle: true,
            title: TextWidget(
              text: 'طلباتك (${ordersList.length})',
              color: color,
              textSize: 24.0,
              isTitle: true,
            ),
            backgroundColor: defaultColor,
          ),
          body: ListView.separated(
            itemCount: ordersList.length,
            itemBuilder: (ctx, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                child: ChangeNotifierProvider.value(
                    value: ordersList[index],
                    child: const OrderWidget()),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                color: color,thickness: 1,
              );
            },
          ));
    });
  }
}
