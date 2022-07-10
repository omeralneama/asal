import 'package:asallah_fruits/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget({
    Key? key,
    required this.salePrice,
    required this.price,
    required this.textPrice,
    required this.isOnSale,
  }) : super(key: key);

  final double salePrice, price;
  final String textPrice;
  final bool isOnSale;
  @override

  Widget build(BuildContext context)
  {
    double userPrice = isOnSale? salePrice: price;
    return FittedBox(
      child: Row(
        children:
        [
          TextWidget(
              text: '${(userPrice * int.parse(textPrice)).toStringAsFixed(2)}\ ريال',
              color: Colors.green,
              textSize: 16,
          ),
          const SizedBox(width: 5,),
          Visibility(
            visible: isOnSale? true:false,
            child: Text(
              '${(price * int.parse(textPrice)).toStringAsFixed(2)}\ ريال',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
