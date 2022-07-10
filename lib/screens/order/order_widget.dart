import 'package:asallah_fruits/models/orders_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/utils.dart';
import '../../widgets/text_widget.dart';
import 'order_details_screen.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({Key? key}) : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}
late String orderDateToShow;
class _OrderWidgetState extends State<OrderWidget> {

  @override
  void didChangeDependencies()
  {
    final ordersModel = Provider.of<OrderModel>(context);
    var orderDate = ordersModel.orderDate.toDate();
    orderDateToShow = '${orderDate.year}/${orderDate.month}/${orderDate.day} . ${orderDate.minute} : ${orderDate.hour} ';
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final ordersModel = Provider.of<OrderModel>(context);
    return ListTile(
      subtitle: Text('المبلغ : ${ordersModel.totalPrice.toStringAsFixed(2)} \ريال'),
      trailing: TextWidget(text: orderDateToShow, color: color, textSize: 18),
      onTap: ()
      {
        Navigator.of(context).push(
          PageRouteBuilder(pageBuilder: (_,__,___)
          => OrdersListDetails(
            orderId: ordersModel.orderId,
          ),
          ),
        ) ;
      },
    );
  }
}
