import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';


class ProductsProvider with ChangeNotifier
{
  static List<ProductModel> productsList = [];
  List<ProductModel> get getProduct
  {
    return productsList;
  }
  List<ProductModel> get getOnSaleProduct
  {
    return productsList.where((element) => element.isOnSale).toList();
  }

  Future<void> fetchProduct () async
  {
    await FirebaseFirestore
        .instance
        .collection('products')
        .get()
        .then((QuerySnapshot productSnapshot)
    {
      productsList = [];
      productSnapshot.docs.forEach((element)
      {
        productsList.insert(0, ProductModel(
          id: element.get('id'),
          title: element.get('title'),
          imageUrl: element.get('imageUrl'),
          productCategoryName: element.get('productCategoryName'),
          price: double.parse(element.get('price'),),
          salePrice: element.get('salePrice'),
          isOnSale: element.get('isOnSale'),
          isPiece: element.get('isPiece'),
        ),
        );
      });
    });
    notifyListeners();
  }

  ProductModel findProductById(String productId)
  {
    return productsList.firstWhere((element) => element.id == productId);
  }

  List<ProductModel> findByCategory(String categoryName)
  {
    List<ProductModel> categoryList = productsList
        .where((element) => element.productCategoryName
        .toLowerCase()
        .contains(categoryName.toLowerCase()))
        .toList();
    return categoryList;
  }

  List<ProductModel> searchQuery(String searchText)
  {
    List<ProductModel> searchList = productsList
        .where((element) => element.title
        .toLowerCase()
        .contains(searchText.toLowerCase()))
        .toList();
    return searchList;
  }


  // // static final List<ProductModel> productsList = [
  // //   ProductModel(
  // //     id: 'Apricot',
  // //     title: 'مش مش',
  // //     price: 0.99,
  // //     salePrice: 0.49,
  // //     imageUrl: 'https://i.ibb.co/F0s3FHQ/Apricots.png',
  // //     productCategoryName: 'الفواكه',
  // //     isOnSale: true,
  // //     isPiece: false,
  // //   ),
  //   ProductModel(
  //     id: 'Avocado',
  //     title: 'افوكادو',
  //     price: 0.88,
  //     salePrice: 0.5,
  //     imageUrl: 'https://i.ibb.co/9VKXw5L/Avocat.png',
  //     productCategoryName: 'الفواكه',
  //     isOnSale: false,
  //     isPiece: true,
  //   ),
  //   ProductModel(
  //     id: 'Black grapes',
  //     title: 'عنب أسود',
  //     price: 1.22,
  //     salePrice: 0.7,
  //     imageUrl: 'https://i.ibb.co/c6w5zrC/Black-Grapes-PNG-Photos.png',
  //     productCategoryName: 'الفواكه',
  //     isOnSale: true,
  //     isPiece: false,
  //   ),
  //   ProductModel(
  //     id: 'Fresh_green_grape',
  //     title: 'عنب أخضر',
  //     price: 1.5,
  //     salePrice: 0.5,
  //     imageUrl: 'https://i.ibb.co/HKx2bsp/Fresh-green-grape.png',
  //     productCategoryName: 'الفواكه',
  //     isOnSale: true,
  //     isPiece: false,
  //   ),
  //   ProductModel(
  //     id: 'Green grape',
  //     title: 'عنب اخضر',
  //     price: 0.99,
  //     salePrice: 0.4,
  //     imageUrl: 'https://i.ibb.co/bHKtc33/grape-green.png',
  //     productCategoryName: 'الفواكه',
  //     isOnSale: false,
  //     isPiece: false,
  //   ),
  //   ProductModel(
  //     id: 'Red apple',
  //     title: 'تفاح أحمر',
  //     price: 0.6,
  //     salePrice: 0.2,
  //     imageUrl: 'https://i.ibb.co/crwwSG2/red-apple.png',
  //     productCategoryName: 'الفواكه',
  //     isOnSale: true,
  //     isPiece: false,
  //   ),
  //   // Vegi
  //   ProductModel(
  //     id: 'Carrots',
  //     title: 'جزر',
  //     price: 0.99,
  //     salePrice: 0.5,
  //     imageUrl: 'https://i.ibb.co/TRbNL3c/Carottes.png',
  //     productCategoryName: 'الخضار',
  //     isOnSale: true,
  //     isPiece: false,
  //   ),
  //   ProductModel(
  //     id: 'Cauliflower',
  //     title: 'زهرة',
  //     price: 1.99,
  //     salePrice: 0.99,
  //     imageUrl: 'https://i.ibb.co/xGWf2rH/Cauliflower.png',
  //     productCategoryName: 'الخضار',
  //     isOnSale: false,
  //     isPiece: true,
  //   ),
  //   ProductModel(
  //     id: 'Cucumber',
  //     title: 'خيار',
  //     price: 0.99,
  //     salePrice: 0.5,
  //     imageUrl: 'https://i.ibb.co/kDL5GKg/cucumbers.png',
  //     productCategoryName: 'الخضار',
  //     isOnSale: false,
  //     isPiece: false,
  //   ),
  //   ProductModel(
  //     id: 'Jalape',
  //     title: 'فلفل حار',
  //     price: 1.99,
  //     salePrice: 0.89,
  //     imageUrl: 'https://i.ibb.co/Dtk1YP8/Jalape-o.png',
  //     productCategoryName: 'الخضار',
  //     isOnSale: false,
  //     isPiece: false,
  //   ),
  //   ProductModel(
  //     id: 'Long yam',
  //     title: 'بطاطا حلوة',
  //     price: 2.99,
  //     salePrice: 1.59,
  //     imageUrl: 'https://i.ibb.co/V3MbcST/Long-yam.png',
  //     productCategoryName: 'الخضار',
  //     isOnSale: false,
  //     isPiece: false,
  //   ),
  //   ProductModel(
  //     id: 'Onions',
  //     title: 'بصل',
  //     price: 0.59,
  //     salePrice: 0.28,
  //     imageUrl: 'https://i.ibb.co/GFvm1Zd/Onions.png',
  //     productCategoryName: 'الخضار',
  //     isOnSale: false,
  //     isPiece: false,
  //   ),
  //   ProductModel(
  //     id: 'Potato',
  //     title: 'بطاطس',
  //     price: 0.99,
  //     salePrice: 0.59,
  //     imageUrl: 'https://i.ibb.co/wRgtW55/Potato.png',
  //     productCategoryName: 'الخضار',
  //     isOnSale: true,
  //     isPiece: false,
  //   ),
  //   ProductModel(
  //     id: 'Radish',
  //     title: 'فجل أحمر',
  //     price: 0.99,
  //     salePrice: 0.79,
  //     imageUrl: 'https://i.ibb.co/YcN4ZsD/Radish.png',
  //     productCategoryName: 'الخضار',
  //     isOnSale: false,
  //     isPiece: false,
  //   ),
  //   ProductModel(
  //     id: 'Red peppers',
  //     title: 'فلفل أحمر',
  //     price: 0.99,
  //     salePrice: 0.57,
  //     imageUrl: 'https://i.ibb.co/JthGdkh/Red-peppers.png',
  //     productCategoryName: 'الخضار',
  //     isOnSale: false,
  //     isPiece: false,
  //   ),
  //   ProductModel(
  //     id: 'Squash',
  //     title: 'قرع',
  //     price: 3.99,
  //     salePrice: 2.99,
  //     imageUrl: 'https://i.ibb.co/p1V8sq9/Squash.png',
  //     productCategoryName: 'الخضار',
  //     isOnSale: true,
  //     isPiece: true,
  //   ),
  //   ProductModel(
  //     id: 'Tomatoes',
  //     title: 'طماطم',
  //     price: 0.99,
  //     salePrice: 0.39,
  //     imageUrl: 'https://i.ibb.co/PcP9xfK/Tomatoes.png',
  //     productCategoryName: 'الخضار',
  //     isOnSale: true,
  //     isPiece: false,
  //   ),
  //   ProductModel(
  //     id: 'Corn-cobs',
  //     title: 'زرة',
  //     price: 0.29,
  //     salePrice: 0.19,
  //     imageUrl: 'https://i.ibb.co/8PhwVYZ/corn-cobs.png',
  //     productCategoryName: 'الخضار',
  //     isOnSale: false,
  //     isPiece: true,
  //   ),
  //   ProductModel(
  //     id: 'Peas',
  //     title: 'فاصوليا',
  //     price: 0.99,
  //     salePrice: 0.49,
  //     imageUrl: 'https://i.ibb.co/7GHM7Dp/peas.png',
  //     productCategoryName: 'الخضار',
  //     isOnSale: false,
  //     isPiece: false,
  //   ),
  //   // Herbs
  //   ProductModel(
  //     id: 'Brokoli',
  //     title: 'بروكلي',
  //     price: 0.99,
  //     salePrice: 0.89,
  //     imageUrl: 'https://i.ibb.co/KXTtrYB/Brokoli.png',
  //     productCategoryName: 'الورقيات',
  //     isOnSale: true,
  //     isPiece: true,
  //   ),
  //   ProductModel(
  //     id: 'Chinese-cabbage-wombok',
  //     title: 'خس',
  //     price: 0.99,
  //     salePrice: 0.5,
  //     imageUrl: 'https://i.ibb.co/7yzjHVy/Chinese-cabbage-wombok.png',
  //     productCategoryName: 'الورقيات',
  //     isOnSale: false,
  //     isPiece: true,
  //   ),
  //   ProductModel(
  //     id: 'Kangkong',
  //     title: 'نعناع',
  //     price: 0.99,
  //     salePrice: 0.5,
  //     imageUrl: 'https://i.ibb.co/HDSrR2Y/Kangkong.png',
  //     productCategoryName: 'الورقيات',
  //     isOnSale: false,
  //     isPiece: true,
  //   ),
  //   ProductModel(
  //     id: 'Leek',
  //     title: 'كراث',
  //     price: 0.99,
  //     salePrice: 0.5,
  //     imageUrl: 'https://i.ibb.co/Pwhqkh6/Leek.png',
  //     productCategoryName: 'الورقيات',
  //     isOnSale: false,
  //     isPiece: true,
  //   ),
  //   ProductModel(
  //     id: 'Spinach',
  //     title: 'سبانخ',
  //     price: 0.89,
  //     salePrice: 0.59,
  //     imageUrl: 'https://i.ibb.co/bbjvgcD/Spinach.png',
  //     productCategoryName: 'الورقيات',
  //     isOnSale: true,
  //     isPiece: true,
  //   ),
  // ];
}