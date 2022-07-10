import 'package:flutter/material.dart';
import '../models/viewed_model.dart';

class ViewedProductProvider with ChangeNotifier
{
  Map<String, ViewedProductModel> viewedProductItems = {};

  Map<String, ViewedProductModel> get getViewedProductItems
  {
    return viewedProductItems;
  }

  void addProductToHistory({
    required String productId,
  })
  {
        viewedProductItems.putIfAbsent(productId,
              () => ViewedProductModel(
            id : DateTime.now().toString(),
            productId: productId,
          ),
        );
    notifyListeners();
  }
  void clearHistory()
  {
    viewedProductItems.clear();
    notifyListeners();
  }
}