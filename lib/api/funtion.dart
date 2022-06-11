import 'dart:convert';

import 'package:http/http.dart' as http;

class Createddata {
  Future datacreated(itemtext, manufacturertext, descriptiontext, pricetext,
      quantitytext) async {
    final response = await http
        .post(Uri.parse('http://127.0.0.1:8000/api/computer-items/store'),
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
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('Data Created Successfully');
      print(response.body);
    } else {
      print('error');
    }
  }
}
