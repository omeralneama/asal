import 'package:asallah_fruits/inner_screens/cat_screen.dart';
import 'package:asallah_fruits/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dark_theme_provider.dart';

class CategoriesWidget extends StatelessWidget
{
  const CategoriesWidget(
      {Key? key,
        required this.catText,
        required this.textText,
        required this.imgPath,
        required this.pastColor,

      }) : super(key: key);
  final String catText , imgPath, textText;
  final Color pastColor;

  @override
  Widget build(BuildContext context)
  {
    final themeState = Provider.of<DarkThemeProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    final color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return InkWell(
      onTap: ()
      {
        Navigator.pushNamed(
          context, CategoryScreen.routeName,
          arguments: catText,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: pastColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: pastColor.withOpacity(0.7),
            width: 3,
          ),
        ),
        child: Column(
          children:
          [
            Container(
              height: screenWidth *0.3,
              width: screenWidth *0.4,
              decoration:BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      imgPath,
                    ),
                    fit: BoxFit.fill,
                  ),
              ),
            ),
            TextWidget(
              text: textText,
              color: color,
              textSize: 20,
              isTitle: true,

            ),
            TextWidget(
                text: catText,
                color: color,
                textSize: 5,

            ),
          ],
        ),
      ),
    );
  }
}
