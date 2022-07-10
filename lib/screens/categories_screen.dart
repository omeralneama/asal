import 'package:flutter/material.dart';
import '../widgets/categories_widget.dart';

class CategoriesScreen extends StatelessWidget
{
   CategoriesScreen({Key? key}) : super(key: key);

   List<Color> catColor =
   [
     Colors.red,
     Colors.yellow,
     Colors.green,
     Colors.amber,
     Colors.blue,
   ];
  List<Map<String, dynamic>> catInfo =
  [
    {
      'imgPath' :'assets/cat/fruits.png',
      'catText':'Fruits',
    },
    {
      'imgPath' :'assets/cat/vegetable.png',
      'catText':'Vegetables',
    },
    {
      'imgPath' :'assets/cat/herbs.png',
      'catText':'Herbs',
    },
    {
      'imgPath' :'assets/cat/spices.png',
      'catText':'Spices',
    },
    {
      'imgPath' :'assets/cat/water.png',
      'catText':'Water',
    },
  ];
   List<Map<String, dynamic>> textInfo =
   [
     {
       'textText':'الفواكه',
     },
     {
       'textText':'الخضار',
     },
     {
       'textText':'الورقيات',
     },
     {
       'textText':'البقوليات',
     },
     {
       'textText':'المياه',
     },
   ];
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.count(
            crossAxisCount: 2,
          childAspectRatio: 280/260,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: List.generate(5, (index)
          {
            return CategoriesWidget(
              imgPath: catInfo[index]['imgPath'],
              catText: catInfo[index]['catText'],
              textText: textInfo[index]['textText'],
              pastColor: catColor[index],
            );
          }),
        ),
      ),
    );
  }
}
