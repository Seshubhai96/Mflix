import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xflix/Model/moviemodel.dart';
import 'package:xflix/resources/apiresource.dart';

class Homecontroller extends ChangeNotifier {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  List<ConnectivityResult> get connectionStatus => _connectionStatus;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
 List<Moviemodel>? _movieslist;
 List<Moviemodel> _favlist =[];
  List<Moviemodel> get favlist => _favlist;
  List<Moviemodel>? get movieslist => _movieslist;
   List<Moviemodel>? _orinalmovieslist;
  bool movieloading = false;
  TextEditingController searchcontroller = TextEditingController();
  /// Fetch Movies from api and assign to listmodel.
  fetchmovies() async {
    try {
      _movieslist?.clear();
      _orinalmovieslist?.clear();
      movieloading = true;
      notifyListeners();
      final response = await getmethod();
      if (response != null) {
        final List mlist = response ?? [];
        _orinalmovieslist  = mlist.map((r) => Moviemodel.fromJson(r)).toList();
        _movieslist = _orinalmovieslist;
        notifyListeners();
      }
      movieloading = false;
      notifyListeners();
    } catch (e) {
      movieloading = false;
      notifyListeners();
    }
  }

  initlize(){
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }
   disposeafteruser() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
      _connectionStatus = result;
      notifyListeners();
       changefilter(_connectionStatus.contains(ConnectivityResult.none)?"Fav":"All");
      if(!_connectionStatus.contains(ConnectivityResult.none)){
        fetchmovies();
      }
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
  }
  /// Search
  searchmovies(String val){
    if(val.isEmpty){
       _movieslist = filter=="Fav"?_favlist:_orinalmovieslist;
      notifyListeners();
    }
    else{
      _movieslist = filter=="Fav"?_favlist.where((el){
        final input = val.trim().replaceAll(" ", "").toLowerCase();
        final mtitle = el.title?.toString().replaceAll(" ", "").trim().toLowerCase();
        //log(mtitle??"-");
        return mtitle!.contains(input);
      }).toList(): _orinalmovieslist?.where((el){
        final input = val.trim().replaceAll(" ", "").toLowerCase();
        final mtitle = el.title?.toString().replaceAll(" ", "").trim().toLowerCase();
        //log(mtitle??"-");
        return mtitle!.contains(input);
      }).toList();
      notifyListeners();
    }
  }
  /// Fetch movies from localstorage
  fetchfavfromloaclstorage()async{
    _favlist.clear();
    notifyListeners();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   var favlist = sharedPreferences.getString("fav");
   if(favlist!=null){
    List decodedlist = json.decode(favlist);
    //log("Fav from Local Storage ${decodedlist.toString()}");
    _favlist = decodedlist.map((e)=>Moviemodel.fromJson(e)).toList();
    changefilter(filter);
    notifyListeners();
   }
   else{
    _favlist=[];
    notifyListeners();
   }
  
  }
  /// Add/Remove movies from favlist
  addfavriotes(Moviemodel moviemodel)async{
   try {
    //log(moviemodel.toJson().toString());
   var data = _favlist.where((ele)=>ele.id==moviemodel.id).isNotEmpty;
   if(data){
    //log("hvh");
    var index = _favlist.indexWhere((t)=>t.id==moviemodel.id);
   _favlist.removeAt(index);
    notifyListeners();
     addfavlocalstorage().whenComplete((){
      fetchfavfromloaclstorage();
    });
   }
   else{
    //log(data.toJson().toString());
    _favlist.add(moviemodel);
    notifyListeners();
    addfavlocalstorage().whenComplete((){
      fetchfavfromloaclstorage();
    });
   }
   } catch (e) {
     log(e.toString());
   }
  }
  /// Add movies after filter to localstorage
 Future<void> addfavlocalstorage()async{
  final seen = <int>{};
    final unique = _favlist.where((str) => seen.add(str.id!)).toList();
    var encodedata = jsonEncode(unique.map((e)=>e.toJson()).toList());
   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   //log("Encoded data ${encodedata.toString()}");
  sharedPreferences.setString("fav", encodedata);
  //sharedPreferences.clear();
}
dynamic filter = "All";
changefilter(val){
  filter = val;
  if(val=="Fav"){
    _movieslist = _favlist;
  }
  else{
    _movieslist = _orinalmovieslist;
  }
  notifyListeners();
}
showfilter(context){
  showModalBottomSheet(context: context, builder: (val){
    return Container(
      height: 150,
      padding:const  EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),
      child: Column(children: [
        RadioListTile.adaptive(title: const Text("All",),value: "All", groupValue: filter, onChanged: (val){
           changefilter(val);
           Navigator.pop(context);
        }),
        RadioListTile.adaptive(title: const  Text("Favourite"),value: "Fav", groupValue: filter, onChanged: (val){
          changefilter(val);
          Navigator.pop(context);
        })
      ],),
    );
  });
}
}

