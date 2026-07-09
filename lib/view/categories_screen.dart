import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/category_news_model.dart';
import '../repository/news_repository.dart';

import 'news_data.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String name="general";
  NewsRepository newsRepository= NewsRepository();
  @override
  Widget build(BuildContext context) {
    final height =MediaQuery.sizeOf(context).height*1;
    final width =MediaQuery.sizeOf(context).width*1;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            height: height*.06,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: false,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      name="general";
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.cyan)),
                  child: Text(
                    "general",
                    style: GoogleFonts.badScript(color: Colors.white,
                    fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      name="business";
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.cyan)),
                  child: Text(
                    "business",
                    style: GoogleFonts.badScript(color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      name="entertainment";
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.cyan)),
                  child: Text(
                    "entertainment",
                    style: GoogleFonts.badScript(color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    setState(() {
                      name="health";
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.cyan)),
                  child: Text(
                    "health",
                    style: GoogleFonts.badScript(color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      name="science";
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.cyan)),
                  child: Text(
                    "science",
                    style: GoogleFonts.badScript(color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      name="sports";
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.cyan)),
                  child: Text(
                    "sports",
                    style: GoogleFonts.badScript(color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      name="technology";
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.cyan)),
                  child: Text(
                    "technology",
                    style: GoogleFonts.badScript(color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: height*.8,
            child: FutureBuilder<CategoryNewsModel>(future: newsRepository.fetchCategoryNews(name),
                builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting){
             return Center(
               child: SpinKitDoubleBounce(
                 color: Colors.cyan,
                 size: 50,
               ),
             );
              }
              else{
                return ListView.builder(
                    itemCount: snapshot.data?.articles?.length,
                    itemBuilder: (BuildContext context,index){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:  GestureDetector(
                          onTap: ()
                            {
                              var title = snapshot
                                  .data!.articles![index].title
                                  .toString();
                              var img = snapshot
                                  .data!.articles![index].urlToImage
                                  .toString();
                              var source = snapshot
                                  .data!.articles![index].author
                                  .toString();
                              var description = snapshot
                                  .data!.articles![index].description
                                  .toString();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewsDataScreen(
                                        description: description,
                                        title: title,
                                        source: source,
                                        img: img,
                                      )));

                          },
                          child: ListTile(
                             leading:
                            Container(
                              height: height*.1,
                              width: width*.2,
                              child: CachedNetworkImage(

                                imageUrl: snapshot.data!.
                                articles![index].urlToImage.toString(),
                                placeholder: (context,value){
                                  return SpinKitFoldingCube(
                                    color: Colors.cyan,
                                  );

                                },
                                errorWidget: (contex, value,error){
                                  return Icon(Icons.hourglass_empty,
                                  color: Colors.red,);
                                },
                              ),

                            ),
                              title:
                              Text(snapshot.data!.articles![index].title.toString()),
                            subtitle:Text(snapshot.data!.articles![index].author.toString()) ,

                          ),
                        ),
                      );
                    });
              }
                }),
          )
        ],
      ),
    );
  }
}
