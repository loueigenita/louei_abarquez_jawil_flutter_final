// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_10/api/funtion.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Createddata obj = Createddata();
  TextEditingController itemtext = TextEditingController();
  TextEditingController manufacturertext = TextEditingController();
  TextEditingController descriptiontext = TextEditingController();
  TextEditingController pricetext = TextEditingController();
  TextEditingController quantitytext = TextEditingController();

  @override
  void initState() {
    super.initState();
    getdata(id);
    datadelet(id);
    update(id);
    //obj.dataCreate( itemtext, manufacturertext, descriptiontext, pricetext, quantitytext);
    dataCreate();
  }

  List data = [];
  String? id;
  String base_url = 'http://192.168.43.66:8000';

  Future dataCreate() async {
    final responce = await http.post(Uri.parse('$base_url/api/computer/store'),
        body: jsonEncode({
          "item": itemtext.text,
          "manufacturer": manufacturertext.text,
          "description": descriptiontext.text,
          "price": pricetext.text,
          "quantity": quantitytext.text,
        }),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        });

    print(responce.statusCode);
    if (responce.statusCode == 200) {
      print('Data Created Successfully');
      print(responce.body);
      itemtext.clear();
      manufacturertext.clear();
      descriptiontext.clear();
      pricetext.clear();
      quantitytext.clear();
    } else {
      print('error from create');
    }
  }

  Future getdata(id) async {
    final responce = await http.get(Uri.parse('$base_url/api/computer'));
    if (responce.statusCode == 200) {
      setState(() {
        data = jsonDecode(responce.body);
      });
      print('Add data$data');
    } else {
      print('error');
    }
  }

  Future datadelet(id) async {
    final responce =
        await http.delete(Uri.parse('$base_url/api/computer/delete/$id'));
    print(responce.statusCode);

    if (responce.statusCode == 200) {
      print('DELETE COMPLETE');
    } else {
      print('NOT dELETED');
    }
  }

  Future update(id) async {
    final responce =
        await http.put(Uri.parse('$base_url/api/computer/edit/$id'),
            body: jsonEncode({
              "item": itemtext.text,
              "manufacturer": manufacturertext.text,
              "description": descriptiontext.text,
              "price": pricetext.text,
              "quantity": quantitytext.text,
            }),
            headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        });
    print(responce.statusCode);
    if (responce.statusCode == 200) {
      print('Data Update Successfully');
      print(responce.body);
      itemtext.clear();
      manufacturertext.clear();
      descriptiontext.clear();
      pricetext.clear();
      quantitytext.clear();
    } else {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 2));
        getdata(id);
        dataCreate();
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            child: Column(
              children: [
                TextField(
                  controller: itemtext,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.shopping_bag),
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.blue)),
                    hintText: 'Item',
                  ),
                ),
                TextField(
                  controller: manufacturertext,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.home),
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.blue)),
                    hintText: 'Manufacturer',
                  ),
                ),
                TextField(
                  controller: descriptiontext,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.telegram),
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.blue)),
                    hintText: 'Description',
                  ),
                ),
                TextField(
                  controller: pricetext,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.price_change),
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.blue)),
                    hintText: 'Price',
                  ),
                ),
                TextField(
                  controller: quantitytext,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.production_quantity_limits),
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.blue)),
                    hintText: 'Quantity',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            dataCreate();
                            print('Create is Pressed');
                          });
                        },
                        child: Text('Create')),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: ListTile(
                            title: Text(data[index]['item']),
                            subtitle: Text(data[index]['manufacturer']),
                            trailing: Container(
                              width: 150,
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        itemtext.text = data[index]['item'];
                                        manufacturertext.text =
                                            data[index]['manufacturer'];
                                        descriptiontext.text =
                                            data[index]['description'];
                                        pricetext.text = data[index]['price'];
                                        quantitytext.text =
                                            data[index]['quantity'];
                                      },
                                      color: Colors.greenAccent,
                                      highlightColor: Colors.greenAccent,
                                      iconSize: 20,
                                      icon: Icon(Icons.edit)),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          datadelet(data[index]['id']);
                                        });
                                      },
                                      color: Colors.blueAccent,
                                      highlightColor:
                                          Color.fromARGB(255, 68, 81, 255),
                                      iconSize: 20,
                                      icon: Icon(Icons.delete)),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          update(data[index]['id']);
                                        });
                                      },
                                      color: Colors.redAccent,
                                      highlightColor: Colors.redAccent,
                                      iconSize: 20,
                                      icon: Icon(Icons.update)),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
