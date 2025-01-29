import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeCarousel extends StatelessWidget {
  final List<String> imgList;

  HomeCarousel({required this.imgList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 200,
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: MediaQuery.of(context).size.width / 200,
          autoPlayInterval: Duration(seconds: 3),
          viewportFraction: 1.0,
          enableInfiniteScroll: true,
          autoPlayCurve: Curves.easeInOut,
        ),
        items: imgList
            .map((item) => Container(
                  child: Center(
                    child: Image.network(
                      item,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image,
                                  size: 50, color: Colors.grey),
                              SizedBox(height: 5),
                              Text(
                                'Image failed to load',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
