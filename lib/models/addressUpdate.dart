import 'dart:convert';

import 'package:http/http.dart' as http;

class AddressUpdate {
  final description;

  AddressUpdate({
    required this.description,
  });

  static AddressUpdate fromJson(Map<String, dynamic> json) =>
      AddressUpdate(description: json['description']);
}

class AddressUpdateApi {
  static Future<List<AddressUpdate>> getAddressSuggestions(String query) async {
    final url = Uri.parse(
        'https://rsapi.goong.io/Place/AutoComplete?api_key=WOXLNGkieaqVH3DPxcDpJoInSLk7QQajAHdzmyhB&input=$query');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List address = json.decode(response.body)["predictions"];

      return address
          .map((json) => AddressUpdate.fromJson(json))
          .where((address) {
        final nameLower = address.description.toLowerCase();
        final queryLower = query.toLowerCase();
        return nameLower.contains(queryLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}
