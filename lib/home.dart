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
  TextEditingController itemController = TextEditingController();
  TextEditingController manufacturerController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getdata();
    update(id);
    datadelet(id);

    obj.datacreated(
        itemController.text,
        manufacturerController.text,
        descriptionController.text,
        priceController.text,
        quantityController.text);
  }

  List data = [];
  String? id;
  Future getdata() async {
    final responce =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/computer-items'));
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
    final responce = await http.delete(
        Uri.parse('http://127.0.0.1:8000/api/computer-items/delete/$id'));
    print(responce.statusCode);

    if (responce.statusCode == 200) {
      print('DELETE COMPLETE');
    } else {
      print('nOT dELET');
    }
  }

  Future update(id) async {
    final responce = await http
        .put(Uri.parse('http://127.0.0.1:8000/api/computer-items/edit/'),
            body: jsonEncode({
              "item": itemController.text,
              "manufacturer": manufacturerController.text,
              "description": descriptionController.text,
              "price": priceController.text,
              "quantity": quantityController.text,
            }),
            headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        });
    print(responce.statusCode);
    if (responce.statusCode == 200) {
      print('Data Update Successfully');
      itemController.clear();
      manufacturerController.clear();
      descriptionController.clear();
      priceController.clear();
      quantityController.clear();
    } else {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('COMPUTER MART'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            child: Column(
              children: [
                TextField(
                  controller: itemController,
                  decoration: InputDecoration(
                    hintText: 'Item',
                  ),
                ),
                TextField(
                  controller: manufacturerController,
                  decoration: InputDecoration(
                    hintText: 'Manufacturer',
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Description',
                  ),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    hintText: 'Price',
                  ),
                ),
                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(
                    hintText: 'Quantity',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            obj.datacreated(
                              itemController.text,
                              manufacturerController.text,
                              descriptionController.text,
                              priceController.text,
                              quantityController.text,
                            );
                          });
                        },
                        child: Text('Submit')),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(data[index]['item']),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(data[index]['manufacturer']),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(data[index]['description']),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(data[index]['price']),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(data[index]['quantity']),
                                  ],
                                ),
                                Container(
                                  width: 150,
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            itemController.text =
                                                data[index]['item'];

                                            manufacturerController.text =
                                                data[index]['manufacturer'];

                                            descriptionController.text =
                                                data[index]['description'];

                                            priceController.text =
                                                data[index]['price'];

                                            quantityController.text =
                                                data[index]['quantity'];
                                          },
                                          icon: Icon(Icons.edit)),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              datadelet(data[index]['id']);
                                            });
                                          },
                                          icon: Icon(Icons.delete)),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              update(data[index]['id']);
                                            });
                                          },
                                          icon: Icon(Icons.book)),
                                    ],
                                  ),
                                ),
                              ]),
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
