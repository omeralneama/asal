import 'package:asallah_fruits/widgets/on_sale_widget.dart';
import 'package:asallah_fruits/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/products_provider.dart';
import '../services/utils.dart';
import '../widgets/back_widget.dart';
import '../widgets/empty_prod.dart';

class OnSaleScreen extends StatelessWidget {
  static const routeName = "/OnSaleScreen";
  const OnSaleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    final productsProvider = Provider.of<ProductsProvider>(context);
    List<ProductModel> productsOnSale = productsProvider.getOnSaleProduct;
    final Utils utils = Utils(context);
    final color = Utils(context).color;
    Size size = utils.screenSize;
    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Center(
          child: TextWidget(
              text: 'منتجات مخفضة',
              color: color, textSize: 20,
            isTitle: true,
          ),
        ),
      ),
      body: productsOnSale.isEmpty
          ? const EmptyProdWidget(
        text: 'لا توجد منتجات مخفضة',
      )
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.zero,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: size.width / (size.height *0.51),
          children:
          List.generate(productsOnSale.length, (index)
          {
            return  ChangeNotifierProvider.value(
                value: productsOnSale[index],
                child: const OnSaleWidget());
          }),
        ),
      ),
    );
  }
}
