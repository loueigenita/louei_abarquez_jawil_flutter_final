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
    getdata(id);
    datadelet(id);
    update(id);

    obj.datacreated(
        itemController.text,
        manufacturerController.text,
        descriptionController.text,
        priceController.text,
        quantityController.text);
  }

  List data = [];
  String? id;
  Future getdata(id) async {
    final responce =
        await http.get(Uri.parse('http://192.168.43.66:8000/api/computer'));
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
    final responce = await http
        .delete(Uri.parse('http://192.168.43.66:8000/api/computer/delete/$id'));
    print(responce.statusCode);

    if (responce.statusCode == 200) {
      print('DELETE COMPLETE');
    } else {
      print('NOT dELETED');
    }
  }

  Future update(id) async {
    final responce = await http
        .put(Uri.parse('http://192.168.43.66:8000/api/computer/edit/$id'),
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
    if (responce.statusCode == 201) {
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
          padding: const EdgeInsets.all(50),
          child: Container(
            child: Column(
              children: [
                TextField(
                  controller: itemController,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.teal)),
                    hintText: 'Item',
                  ),
                ),
                TextField(
                  controller: manufacturerController,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.teal)),
                    hintText: 'Manufacturer',
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.teal)),
                    hintText: 'Description',
                  ),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.teal)),
                    hintText: 'Price',
                  ),
                ),
                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.teal)),
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
                                      color: Colors.greenAccent,
                                      highlightColor: Colors.greenAccent,
                                      iconSize: 25,
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
                                      iconSize: 25,
                                      icon: Icon(Icons.delete)),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          update(data[index]['id']);
                                        });
                                      },
                                      color: Colors.redAccent,
                                      highlightColor: Colors.redAccent,
                                      iconSize: 25,
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
    );
  }
}
