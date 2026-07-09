import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsDataScreen extends StatefulWidget {
  String title;
  String img;
  String source;
  String description;
  NewsDataScreen(
      {super.key,
      required this.img,
      required this.title,
      required this.source,
      required this.description});

  @override
  State<NewsDataScreen> createState() => _NewsDataScreenState();
}

class _NewsDataScreenState extends State<NewsDataScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                  height: height * .4,
                  width: width,
                  child: widget.img != null
                      ? CachedNetworkImage(
                          imageUrl: widget.img,
                          fit: BoxFit.fill,
                        )
                      : Image.asset(
                          "image/news-2.jpg",
                          fit: BoxFit.fill,
                        )),
              SizedBox(
                height: height * 0.04,
              ),
              Text(
                widget.title,
                style: GoogleFonts.abrilFatface(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Text(
                widget.source,
                style: GoogleFonts.labrada(fontSize: 20, color: Colors.black),
                textAlign: TextAlign.end,
              ),
              Text(
                widget.description,
                style: GoogleFonts.agbalumo(fontSize: 20, color: Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }
}
