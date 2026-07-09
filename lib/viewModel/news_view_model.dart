import 'dart:convert';

import 'package:http/http.dart' as http;
import '../model/top_headlines_news_model.dart';

class NewsViewModel {


  Future<TopHeadlinesNewsModel> fetchNews(String channel) async {
    String uri =
        "https://newsapi.org/v2/top-headlines?sources=${channel}&apiKey=98dee3928461470d8f4fcbbfbc664f4a";

    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return TopHeadlinesNewsModel.fromJson(body);
    }
    throw Exception("Error");
  }


}
