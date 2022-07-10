import 'package:flutter/material.dart';

class OrderDetailsWidget extends StatefulWidget {
  const OrderDetailsWidget({Key? key,
    required this.isPiece,
    required this.price,
    required this.quantity,
    required this.singlePrice,
    required this.singleSalePrice,
    required this.title,
    required this.orderId,
  }) : super(key: key);
  final double price, singlePrice, singleSalePrice;
  final String title,orderId;
  final int quantity;
  final bool isPiece;

  @override
  State<OrderDetailsWidget> createState() => _OrderDetailsWidgetState();
}
late String orderDateToShow;
class _OrderDetailsWidgetState extends State<OrderDetailsWidget> {

  @override
  Widget build(BuildContext context) {
    return ListTile(
        subtitle: Text('اسم الصنف : ${widget.title} | الكمية : ${widget.quantity}${widget.isPiece? 'حبة' : 'كيلو'} | السعر : ${widget.singlePrice}ريال | المبلغ : ${widget.price}ريال'),
    );

  }
}
