import 'package:flutter/material.dart';

class AddToCart with ChangeNotifier {
  List _items = [];
  List _itemsnoreapt = [];
  double _price = 0;
  Map quantity = {};
  Map active = {}; // Change Color Button
  // for price delivey all resturants
  Map listpricedelivery = {}; //
  double _pricedelivery = 0;
  // Price for every resturants
  Map resprice =
      {}; // من اجل كل مطعم يكون له سعر خاص فيه من اجل ادراج في قواعد البيانات وخصم الحساب من كل مطعم على حذى

  void add(items, pricedelivery, resid) {
    // prdouble(items) ;
    active[items['item_id']] = 1; // Acive Button any Change color To Red
    _price += double.parse(items['item_price'].toString());
    if (quantity[items['item_id']] == null) {
      _itemsnoreapt.add(items);
      quantity[items['item_id']] = 1;
    } else if (quantity[items['item_id']] == 0) {
      _itemsnoreapt.add(items);
      quantity[items['item_id']] = 1;
    } else {
      quantity[items['item_id']] = quantity[items['item_id']] + 1;
    }
    // For Price Delivery Restaurants

    if (listpricedelivery[resid] != double.parse(items['res_id'].toString())) {
      listpricedelivery[resid] = double.parse(items['res_id'].toString());
      // prdouble(double.parse(listpricedelivery[resid].toString()) !=
      //     double.parse(items['res_id'].toString()));
      _pricedelivery += double.parse(pricedelivery.toString());
    }

    // Price for every resturants

    if (resprice[items['res_id']] == null) { // {2 : }
      resprice[items['res_id']] = 0;
    }

    resprice[items['res_id']] += double.parse(items['item_price']);

    // prdouble(resprice);

    notifyListeners();
  }

  void remove(items, pricedelivery, resid) {
    if (quantity[items['item_id']] != null) {
      if (quantity[items['item_id']] == 1) {
        _itemsnoreapt
            .removeWhere((item) => item['item_id'] == items['item_id']);
        active[items['item_id']] = 0;
      }
      if (quantity[items['item_id']] > 0) {
        _price -= double.parse(items['item_price'].toString());
      
        quantity[items['item_id']] = quantity[items['item_id']] - 1;

        // For Price Delivery Restaurants
        var value =
            _itemsnoreapt.where((element) => element['res_id'] == resid); 

        if (value.isEmpty) {
          listpricedelivery[resid] = 0; 
          _pricedelivery -= double.parse(pricedelivery.toString());
        }

        // Price for every resturants
        resprice[items['res_id']] -= double.parse(items['item_price']);
        // prdouble(resprice);
      }

      notifyListeners();
    }
  }

  void reset(items, pricedelivery, resid) {
    // Price for every resturants

    resprice[items['res_id']] -= (double.parse(items['item_price'])  * double.parse(quantity[items['item_id']].toString())   );
    // prdouble(resprice);
   // = =====================================
    _itemsnoreapt.removeWhere((item) => item['item_id'] == items['item_id']);
    _price = _price -
        (double.parse(quantity[items['item_id']].toString()) *
            double.parse(items['item_price'].toString()));
    quantity[items['item_id']] = 0;
    // ===============
    active[items['item_id']] = 0; // unAcive Button any Change color To black

    var value = _itemsnoreapt.where((element) => element['res_id'] == resid);

    if (value.isEmpty) {
      listpricedelivery[resid] = 0;
      _pricedelivery -= double.parse(pricedelivery.toString());
    }

    notifyListeners();
  }

  int get count {
    return _items.length;
  }

  double get totalprice {
    return _price;
  }

  List get basket {
    return _items;
  }

  List get basketnoreapt {
    return _itemsnoreapt;
  }

  double get totalpricedelivery {
    return _pricedelivery;
  }

  double get sumtotalprice {
    return _price + _pricedelivery;
  }

  Map get priceeveryres {
    return resprice;
  }

  // Color button change

}
