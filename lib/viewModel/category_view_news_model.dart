import 'dart:convert';

import '../model/category_news_model.dart';
import 'package:http/http.dart'as http;

class CategoryViewNewsModel{

  Future<CategoryNewsModel> fetchCategoryNews(String category)async{
    String uri="https://newsapi.org/v2/everything?q=$category&apiKey=8a5ec37e26f845dcb4c2b78463734448";
    final response=await http.get(Uri.parse(uri));
    if(response.statusCode==200){
      final body=jsonDecode(response.body);
      return CategoryNewsModel.fromJson(body);
    }throw Exception("Error");

  }


}