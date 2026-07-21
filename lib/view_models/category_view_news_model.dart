import 'dart:convert';

import '../models/category_news_model.dart';
import 'package:http/http.dart'as http;

class CategoryViewNewsModel{

  Future<CategoryNewsModel> fetchCategoryNews(String category)async{
    String encodedCategory = Uri.encodeComponent(category);
    String uri="https://newsapi.org/v2/everything?q=$encodedCategory&apiKey=98dee3928461470d8f4fcbbfbc664f4a";
    final response = await http.get(
      Uri.parse(uri),
      headers: {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36',
      },
    );
    if(response.statusCode==200){
      final body=jsonDecode(response.body);
      return CategoryNewsModel.fromJson(body);
    }throw Exception("Error");

  }
}