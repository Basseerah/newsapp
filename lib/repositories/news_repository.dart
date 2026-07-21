import '../models/top_headlines_news_model.dart';
import '../view_models/category_view_news_model.dart';
import '../view_models/news_data_view_model.dart';
import '../view_models/news_view_model.dart';
import '../models/category_news_model.dart';
import '../models/news_data_model.dart';

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
