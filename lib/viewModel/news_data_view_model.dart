import 'dart:convert';

import '../model/news_data_model.dart';
import 'package:http/http.dart' as http;

class NewsDataViewModel {
  String uri =
      "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=98dee3928461470d8f4fcbbfbc664f4a";

  Future<newsDataModel> fetchNewsData() async {
    final response = await http.get(
      Uri.parse(uri),
      headers: {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return newsDataModel.fromJson(body);
    }
    throw Exception("errror");
  }
}
