import 'package:asallah_fruits/inner_screens/feed_screen.dart';
import 'package:asallah_fruits/inner_screens/on_sale_screen.dart';
import 'package:asallah_fruits/services/utils.dart';
import 'package:asallah_fruits/widgets/text_widget.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import '../const/const.dart';
import '../models/product_model.dart';
import '../providers/products_provider.dart';
import '../services/global_methods.dart';
import '../widgets/feed_items.dart';
import '../widgets/on_sale_widget.dart';

class HomeScreen extends StatefulWidget
{
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
{

  @override
  Widget build(BuildContext context)
  {
    final Utils utils = Utils(context);
    final color = Utils(context).color;
    Size size = utils.screenSize;
    final productsProvider = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts = productsProvider.getProduct;
    List<ProductModel> productsOnSale = productsProvider.getOnSaleProduct;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height *0.33,
              // الصور المتحركة
              child: Swiper(
                itemBuilder: (BuildContext context,int index){
                  return Image.asset(
                    Constss.offerImage[index],
                    fit: BoxFit.fill,
                  );
                },
                autoplay: true,
                itemCount: Constss.offerImage.length,
                pagination: const SwiperPagination(
                  alignment: Alignment.bottomCenter,
                  builder: DotSwiperPaginationBuilder(
                    color: Colors.white,
                    activeColor: Colors.blue,
                  ),
                ),
                control: const SwiperControl(),
              ),
            ),
            Container(
              decoration:  BoxDecoration(
                borderRadius:  const BorderRadius.all(Radius.circular(12)),
                color: Theme.of(context).cardColor,
              ),
              height: size.height*0.05,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                  [
                    // كلمة تخفيضات
                    const Icon(
                      Icons.phone_enabled,
                      color: Colors.black38,
                    ),
                    const SizedBox(width: 5,),
                    TextWidget(
                      text: 'هاتف الدعم : 0508839254',
                      color: Colors.black38,
                      textSize: 18,
                      isTitle: true,
                    ),
                  ],
                ),
              ),
            ),
            // عرض المزيد
            TextButton(
                onPressed: ()
                {
                  GlobalMethods.navigateTo(ctx: context, routeName: OnSaleScreen.routeName);
                },
                child: TextWidget(
                    text: 'عرض المزبد ..',
                    color: Colors.blue,
                    textSize: 18,
                  maxLines: 1,
                ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(12),topRight:  Radius.circular(12)),
                      color: Colors.red,
                    ),
                    height: size.height*0.25,
                    width: 60,
                    child: RotatedBox(
                      quarterTurns: -1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children:
                          [
                            // كلمة تخفيضات
                            TextWidget(
                                text: 'تخفيضات',
                                color: Colors.white,
                                textSize: 30,
                              isTitle: true,
                            ),
                            const SizedBox(width: 5,),
                            const Icon(
                                IconlyLight.discount,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: SizedBox(
                    height: size.height*0.25,
                    child: ListView.builder(
                      itemCount: productsOnSale.length < 10 ? productsOnSale.length : 10,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 5,),
                      itemBuilder: (ctx, index)
                      {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: ChangeNotifierProvider.value(
                              value: productsOnSale[index],
                              child: const OnSaleWidget()),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,),
              child: Row(
                children:
                [
                  TextWidget(
                      text: 'المنتجات',
                      color: color,
                      textSize: 18,
                    isTitle: true,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: ()
                    {
                      GlobalMethods.navigateTo(ctx: context, routeName: FeedScreen.routeName);
                    },
                    child: TextWidget(
                      text: 'تصفح الجميع',
                      color: Colors.blue,
                      textSize: 18,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 10,),
             child: GridView.count(
               physics: const NeverScrollableScrollPhysics(),
                 shrinkWrap: true,
                 crossAxisCount: 2,
               padding: EdgeInsets.zero,
               crossAxisSpacing: 10,
               mainAxisSpacing: 10,
               childAspectRatio: size.width / (size.height *0.7),
               children:
                 List.generate(
                     allProducts.length < 4 ? allProducts.length
                         : 4, (index)
                 {
                   return ChangeNotifierProvider.value(
                     value: allProducts[index],
                       child: const FeedsItemsWidget());
                 }),
             ),
           ),
          ],
        ),
      ),
    );
  }
}