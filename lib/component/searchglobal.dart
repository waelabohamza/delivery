import 'package:flutter/material.dart';


class DataSearch extends SearchDelegate<Future<Widget>> {
  List<dynamic> list;
  final type;
  final mdw;
  // for items to all categories
  final cat;
  // for items to all categories
  final resid;
  DataSearch({this.type, this.mdw, this.cat, this.resid});

  
  @override
  List<Widget> buildActions(BuildContext context) {
    // Action for AppBar
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icon Leading
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text("yes");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone searchers for something
    if (query.isEmpty) {
      return Center(
        child: Stack(
          children: [
            Positioned(
                left: mdw - 85 / 100 * mdw,
                top: mdw - 50 / 100 * mdw,
                child: Image.asset(
                  "images/search.png",
                  width: mdw,
                  height: mdw,
                ))
          ],
        ),
      );
    } else {
      // return FutureBuilder(
      //   future: type == "categories"
      //       ? crud.readDataWhere("searchcats", query.toString())
      //       : type == "itemscat"
      //           ? crud.writeData("searchitems",
      //               {"search": query.toString(), "catid": cat.toString()})
      //           : type == "itemsres"
      //               ? crud.writeData("searchitems",
      //                   {"search": query.toString(), "resid": resid.toString()})
      //               : type == "itemscatres"
      //                   ? crud.writeData("searchitems", {
      //                       "search": query.toString(),
      //                       "catid": cat.toString(),
      //                       "resid": resid
      //                     })
      //                   : type == "users"
      //                       ? crud.readDataWhere(
      //                           "searchusers", query.toString())
      //                       : type == "restuarants"
      //                           ? crud.readDataWhere(
      //                               "searchrestaurants", query.toString())
      //                           : "",
      //   builder: (BuildContext context, AsyncSnapshot snapshot) {
      //     if (snapshot.hasData) {
      //       if (snapshot.data[0] == "faild") {
      //         return Image.asset("images/notfounditem.jpg") ; 
      //       }
      //       return ListView.builder(
      //           itemCount: snapshot.data.length,
      //           itemBuilder: (context, i) {
      //             if (type == "categories") {
      //               return CategoriesListSearch(
      //                   crud: crud, categories: snapshot.data[i]);
      //             } else if (type == "itemscat") {
      //               return ItemsList(
      //                 crud: crud,
      //                 items: snapshot.data[i],
      //               );
      //             } else if (type == "itemsres") {
      //               return ItemsList(
      //                 crud: crud,
      //                 items: snapshot.data[i],
      //               );
      //             } else if (type == "itemscatres") {
      //               return ItemsList(
      //                 crud: crud,
      //                 items: snapshot.data[i],
      //               );
      //             } else if (type == "restuarants") {
      //               return RestaurantsApprove(resturantsapprove: snapshot.data);
      //             }
      //           });
      //     }
      //     return Center(child: CircularProgressIndicator());
      //   },
      // );
    }
  }
}
