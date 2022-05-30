import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:project/screens/imagepage.dart';
import 'package:velocity_x/velocity_x.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Box? box;
  List data = [];

  Future openbox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('data');
    return;
  }

  Future<bool> getAllData() async {
    await openbox();

    String url =
        "https://raw.githubusercontent.com/NishchayShakya1/DeepKlarity/main/deepKlarity.json";

    try {
      var response = await http.get(Uri.parse(url));
      var jsonData = jsonDecode(response.body);
      var productsData = jsonData["products"];

      await putData(productsData);
    } catch (socketException) {
      if (kDebugMode) {
        print("No Internet");
      }
    }

    var mymap = box!.toMap().values.toList();
    if (mymap.isEmpty) {
      data.add('empty');
    } else {
      data = mymap;
    }

    return Future.value(true);
  }

  Future<void> updateData() async {
    String url =
        "https://raw.githubusercontent.com/NishchayShakya1/DeepKlarity/main/deepKlarity.json";
    try {
      var response = await http.get(Uri.parse(url));
      var jsonData = jsonDecode(response.body);
      var productsData = jsonData["products"];

      await putData(productsData);
      setState(() {});
    } catch (socketException) {
      Fluttertoast.showToast(
          msg: "No Internet",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future putData(data) async {
    await box!.clear();
    for (var d in data) {
      box!.add(d);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        body: SafeArea(
          child: Container(
            padding: Vx.m12,
            child: FutureBuilder(
              future: getAllData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (data.contains('empty')) {
                    return const Center(
                      child: Text('No data',
                          style: TextStyle(
                            fontSize: 24.0,
                          )),
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: RefreshIndicator(
                          onRefresh: updateData,
                          child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 0),
                              shrinkWrap: true,
                              itemCount: 1000,
                              itemBuilder: (context, index) {
                                // Contest user = list[index];
                                // final catalog = CatalogModel.getbyPosition(index);
                                return VxBox(
                                        child: Row(
                                  children: [
                                    CatalogImage(
                                      image: data[0]['productUrl'].toString(),
                                      key: null,
                                    ),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                            padding: EdgeInsets.all(9.0)),
                                        "${data[0]['productName']}"
                                            .text
                                            .lg
                                            .xl2
                                            .color(context.accentColor)
                                            .bold
                                            .make()
                                            .p2(),
                                        "${data[0]['productDescription']}"
                                            .text
                                            .textStyle(
                                              context.captionStyle,
                                            )
                                            .make()
                                            .p2(),
                                        "${data[0]['productRating']}"
                                            .text
                                            .textStyle(
                                              context.captionStyle,
                                            )
                                            .make()
                                            .p2(),
                                      ],
                                    ))
                                  ],
                                ))
                                    .color(context.cardColor)
                                    .roundedLg
                                    .square(150)
                                    .make()
                                    .py16()
                                    .px0();
                              }),
                        )),
                      ],
                    );
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ));
  }
}
