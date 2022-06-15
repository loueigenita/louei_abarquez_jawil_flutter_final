import 'dart:convert';

import 'package:http/http.dart' as http;

class Createddata {
  Future datacreated(itemtext, manufacturertext, descriptiontext, pricetext,
      quantitytext) async {
    final responce = await http
        .post(Uri.parse('http://192.168.43.66:8000/api/computer/store'),
            body: jsonEncode({
              "item": itemtext,
              "manufacturer": manufacturertext,
              "description": descriptiontext,
              "price": pricetext,
              "quantity": quantitytext
            }),
            headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        });
    print(responce.statusCode);
    if (responce.statusCode == 200) {
      print('Data Created Successfully');
      print(responce.body);
    } else {
      print('error');
    }
  }
}
