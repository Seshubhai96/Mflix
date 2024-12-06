// ignore_for_file: prefer_is_empty

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xflix/Model/moviemodel.dart';
import 'package:xflix/controller/homecontroller.dart';
import 'package:xflix/views/moviedetail.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((val) {
      final ctrl = Provider.of<Homecontroller>(context, listen: false);
      if (mounted) {
        ctrl.initConnectivity();
      }
      ctrl.fetchmovies();
      ctrl.fetchfavfromloaclstorage();
    });
    super.initState();
  }

  @override
  void dispose() {
    final ctrl = Provider.of<Homecontroller>(context, listen: false);
    ctrl.disposeafteruser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<Homecontroller>(builder: (context, ctrl, child) {
      return Scaffold(
        body: SafeArea(
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: ctrl.movieloading
                ? const Center(
                    child: CupertinoActivityIndicator(
                      color: Colors.deepOrangeAccent,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom:10 ),
                          child: Visibility(
                              visible: ctrl.connectionStatus
                                  .contains(ConnectivityResult.none),
                              child: Text(
                                  "It seems you're offline. Please reconnect to the internet.",style: Theme.of(context).textTheme.titleLarge,)),
                        ),

                        /// Search Field
                        Container(
                          height: 60,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.5)),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: ctrl.searchcontroller,
                                  onChanged: (val) {
                                    ctrl.searchmovies(val);
                                  },
                                  decoration: InputDecoration(
                                      suffixIcon: Visibility(
                                          visible: ctrl
                                              .searchcontroller.text.isNotEmpty,
                                          child: IconButton(
                                              onPressed: () {
                                                ctrl.searchcontroller.clear();
                                                ctrl.searchmovies("");
                                              },
                                              icon: const Icon(Icons.clear))),
                                      fillColor: Colors.white,
                                      contentPadding: const EdgeInsets.all(10),
                                      filled: true,
                                      hintText: "Search movies..",
                                      border: InputBorder.none),
                                ),
                              ),
                              Visibility(
                                visible: !ctrl.connectionStatus
                                    .contains(ConnectivityResult.none),
                                child: IconButton(
                                    onPressed: () {
                                      ctrl.showfilter(context);
                                    },
                                    icon: const Icon(Icons.filter_alt)),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        /// Movie Grid
                        Expanded(
                          child: ctrl.movieslist?.length == 0
                              ? const Center(
                                  child: Text("No Records"),
                                )
                              : GridView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 5,
                                          crossAxisSpacing: 5,
                                          childAspectRatio: 0.7),
                                  itemCount: ctrl.movieslist?.length,
                                  itemBuilder: (_, i) {
                                    final data = ctrl.movieslist?[i];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            PageRouteBuilder(
                                                pageBuilder: (_, a1, a2) {
                                          return SlideTransition(
                                            position: Tween<Offset>(
                                                    begin: const Offset(-1, 0),
                                                    end: Offset.zero)
                                                .animate(a1),
                                            child:
                                                Moviedetail(moviemodel: data),
                                          );
                                        }));
                                      },
                                      child: Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: GridTile(
                                            footer: Container(
                                                alignment: Alignment.center,
                                                height: 50,
                                                width: size.width,
                                                decoration: const BoxDecoration(
                                                    color: Colors.white),
                                                child: Text(
                                                  data?.title ?? "",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )),
                                            header: data?.posterURL != null
                                                ? Stack(
                                                    children: [
                                                      Hero(
                                                        tag: "${data?.id}",
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              data!.posterURL!,
                                                          fit: BoxFit.fill,
                                                          errorWidget: (context,
                                                              error,
                                                              stackTrace) {
                                                            return const Center(
                                                                child: Icon(Icons
                                                                    .image));
                                                          },
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 10,
                                                                    top: 10),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15)),
                                                            height: 50,
                                                            width: 50,
                                                            //color: Colors.white,
                                                            child: Center(
                                                                child:
                                                                    IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          ctrl.addfavriotes(
                                                                              data);
                                                                        },
                                                                        icon:
                                                                            Icon(
                                                                          ctrl.favlist.firstWhere((r) => r.id == data.id, orElse: () => Moviemodel()).id != null
                                                                              ? Icons.favorite
                                                                              : Icons.favorite_outline_outlined,
                                                                          color:
                                                                              Colors.red,
                                                                        )))),
                                                      ),
                                                    ],
                                                  )
                                                : Image.asset("assets/A.gif"),
                                            child: const SizedBox.shrink()),
                                      ),
                                    );
                                  }),
                        )
                      ],
                    ),
                  ),
          ),
        ),
      );
    });
  }
}
