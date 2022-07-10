import 'package:asallah_fruits/const/theme_data.dart';
import 'package:asallah_fruits/models/product_model.dart';
import 'package:asallah_fruits/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/utils.dart';
import '../widgets/back_widget.dart';
import '../widgets/empty_prod.dart';
import '../widgets/feed_items.dart';
import '../widgets/text_widget.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);
  static const routeName = "/CategoryScreenState";
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
{
  final TextEditingController? searchTextController = TextEditingController();
  final FocusNode searchTextFocusNode = FocusNode();
  List<ProductModel> listProductSearch = [];
  @override
  void dispose()
  {
    searchTextController!.dispose();
    searchTextFocusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    final color = Utils(context).color;
    final productsProvider = Provider.of<ProductsProvider>(context);
    final catName = ModalRoute.of(context)!.settings.arguments as String;
    List<ProductModel> productByCat = productsProvider.findByCategory(catName);
    Size size = utils.screenSize;
    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Center(
          child: TextWidget(
            text: catName,
            color: color,
            textSize: 20,
            isTitle: true,
          ),
        ),
      ),
      body: productByCat.isEmpty
          ? const EmptyProdWidget(
        text: 'لا توجد منتجات',
      )
     : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: kBottomNavigationBarHeight,
                child: TextField(
                  focusNode: searchTextFocusNode,
                  controller: searchTextController,
                  onChanged: (value)
                  {
                    setState(()
                    {
                      listProductSearch =
                          productsProvider.searchQuery(value);
                    });
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 1,
                      ),
                    ),
                    hintText: 'ما الذي تبحث عنه',
                    prefixIcon: const Icon(Icons.search,),
                    suffix: IconButton(
                      onPressed: ()
                      {
                        searchTextController!.clear();
                        searchTextFocusNode.unfocus();
                      },
                      icon: Icon(Icons.close,
                        color: searchTextFocusNode.hasFocus ? Colors.red : defaultColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15,),
             searchTextController!.text.isNotEmpty
                 && listProductSearch.isEmpty
                  ? const EmptyProdWidget(text: 'لم يتم العثور على منتج')
              : GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                padding: EdgeInsets.zero,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: size.width / (size.height *0.67),
                children:
                List.generate(
                    searchTextController!.text.isNotEmpty
                        ? listProductSearch.length
                        : productByCat.length, (index)
                {
                  return ChangeNotifierProvider.value(
                      value: searchTextController!.text.isNotEmpty
                          ? listProductSearch[index]
                          : productByCat[index],
                      child: const FeedsItemsWidget());
                }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
