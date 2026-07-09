import 'package:http/http.dart';
import '../model/top_headlines_news_model.dart';
import '../viewModel/category_view_news_model.dart';
import '../viewModel/news_data_view_model.dart';
import '../viewModel/news_view_model.dart';

import '../model/category_news_model.dart';
import '../model/news_data_model.dart';

class NewsRepository {
  final _rep = NewsViewModel();
  Future<TopHeadlinesNewsModel> fetchNews(String channel) async {
    final response = await _rep.fetchNews(channel);
    return response;
  }

  Future<newsDataModel> fetchNewsData()async{
    final response=NewsDataViewModel().fetchNewsData();
    return response;
  }

  Future<CategoryNewsModel> fetchCategoryNews(String category)async{
    final response=CategoryViewNewsModel().fetchCategoryNews(category);
    return response;
  }
}
