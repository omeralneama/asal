import 'package:asallah_fruits/screens/wishlist/wishlist_widget.dart';
import 'package:asallah_fruits/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/empty_screen.dart';

class WishListScreen extends StatelessWidget
{
  static const routeName = "/WishListScreen";

  const WishListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistItemsList = wishlistProvider.getWishlistItems.values.toList().reversed.toList();

    return wishlistItemsList.isEmpty
        ? const EmptyScreen(
        imagePath: 'assets/cat/empty heart.png',
        buttonText: 'اضف الي المفضلة',
        title: 'المفضلة فارغة',
      )
     : Scaffold(
        appBar: AppBar(
          leading: const BackWidget(),
          automaticallyImplyLeading: false,
          elevation: 0,
          title: TextWidget(
            text: 'المفضلة (${wishlistItemsList.length}) ',
            color: color,
            textSize: 20,
            isTitle: true,
          ),
          actions: [
            IconButton(
              onPressed: ()
              {
                GlobalMethods.warningDialog(
                  title: 'مسح المفضلة',
                  subtitle: 'هل أنت متأكد ؟',
                  fct: () async
                  {
                    await wishlistProvider.clearOnlineWish();
                    wishlistProvider.clearLocalWishlist();
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
        body: MasonryGridView.count(
          itemCount: wishlistItemsList.length,
          crossAxisCount: 2,
          // mainAxisSpacing: 16,
          // crossAxisSpacing: 20,
          itemBuilder: (context, index) {
            return ChangeNotifierProvider.value(
              value: wishlistItemsList[index],
                child: const WishlistWidget());
          },
        ),
      );
  }
}