// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xflix/Model/moviemodel.dart';
import 'package:xflix/controller/homecontroller.dart';

class Moviedetail extends StatelessWidget {
  Moviemodel? moviemodel;
  Moviedetail({super.key, required this.moviemodel});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<Homecontroller>(builder: (context, ctrl, child) {
      return Scaffold(
          body: Stack(
        children: [
          Hero(
            tag: "${moviemodel?.id}",
            child: SizedBox(
              height: size.height / 1.3,
              width: size.width,
              child: CachedNetworkImage(
               imageUrl:moviemodel!.posterURL!,
                fit: BoxFit.fill,
                errorWidget: (context, error, stackTrace) {
                  return Image.asset("assets/A.gif");
                },
              ),
            ),
          ),
          Positioned(
              left: 20,
              top: 30,
              child: Container(
                alignment: Alignment.center,
                //margin: const EdgeInsets.only(right: 10, top: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                height: 50,
                width: 50,
                child: Center(
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      )),
                ),
              )),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 300,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black45,
                          spreadRadius: 10,
                          blurRadius: 6)
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.amberAccent,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Text("IMDB"),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(moviemodel?.imdbId ?? "")
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            moviemodel?.title ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.w500, fontSize: 30),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Icon(
                            ctrl.favlist
                                        .firstWhere((r) => r.id == moviemodel?.id,
                                            orElse: () => Moviemodel())
                                        .id !=
                                    null
                                ? Icons.favorite
                                : Icons.favorite_outline_outlined,
                                size: 30,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Flexible(
                      child: Text(
                          """Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
                      """),
                    ),
                  ],
                ),
              ))
        ],
      ));
    });
  }
}
