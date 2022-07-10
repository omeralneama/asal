import 'package:asallah_fruits/const/theme_data.dart';
import 'package:asallah_fruits/providers/viewed_provider.dart';
import 'package:asallah_fruits/screens/viewed_recently/viewed_recently_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/empty_screen.dart';
import '../../widgets/text_widget.dart';

class ViewedRecentlyScreen extends StatefulWidget {
  static const routeName = '/ViewedRecentlyScreen';

  const ViewedRecentlyScreen({Key? key}) : super(key: key);

  @override
  _ViewedRecentlyScreenState createState() => _ViewedRecentlyScreenState();
}

class _ViewedRecentlyScreenState extends State<ViewedRecentlyScreen> {
  bool check = true;
  @override
  Widget build(BuildContext context) {
    Color color = Utils(context).color;
    final viewedProductProvider = Provider.of<ViewedProductProvider>(context);
    final viewedProductItemsList = viewedProductProvider.getViewedProductItems.values.toList().reversed.toList();

    return viewedProductItemsList.isEmpty
     ? const EmptyScreen(
        imagePath: 'assets/cat/viewed calender.png',
        buttonText: 'تسوق الآن',
        title: 'السجل فارغ',
      )
     :  Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                GlobalMethods.warningDialog(
                    title: 'مسح السجل ؟',
                    subtitle: 'هل أنت متاكد ؟',
                    fct: ()
                    {
                      viewedProductProvider.clearHistory();
                    },
                    context: context);
              },
              icon: const Icon(IconlyBold.delete,),
              color: color,
              alignment: Alignment.topLeft,
            )
          ],
          leading: const BackWidget(),
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: true,
          title: TextWidget(
            text: 'السجل',
            color: color,
            textSize: 24.0,
          ),
          backgroundColor: defaultColor,
        ),
        body: ListView.builder(
            itemCount: viewedProductItemsList.length,
            itemBuilder: (ctx, index) {
              return  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                child: ChangeNotifierProvider.value(
                  value: viewedProductItemsList[index],
                    child: const ViewedRecentlyWidget()),
              );
            }),
      );

  }
}
