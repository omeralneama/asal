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
          id: element.data().toString().contains('id') ? element.get('id') : '',
          title: element.data().toString().contains('title') ? element.get('title') : '',
          imageUrl: element.data().toString().contains('imageUrl') ? element.get('imageUrl') : '',
          productCategoryName: element.data().toString().contains('productCategoryName') ? element.get('productCategoryName') : '',
          price: element.data().toString().contains('price') ? double.parse(element.get('price').toString(),) : 0.0,
          salePrice: element.data().toString().contains('salePrice') ? double.parse(element.get('salePrice').toString(),) : 0.0,
          isOnSale: element.data().toString().contains('isOnSale') ? element.get('isOnSale') : false,
          isPiece: element.data().toString().contains('isPiece') ? element.get('isPiece') : false,

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

}