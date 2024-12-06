import 'package:http/http.dart' as http;
import 'dart:convert';

const url = "https://api.sampleapis.com/movies/animation";
const headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  "Access-Control-Allow-Origin": "*",
};

// postmethod({payload})async{
//   try {
//     Uri ul = Uri.parse(url);
//     final request = await http.post(ul,headers: headers,body: jsonEncode(payload));
//     if(request.statusCode>=200&&request.statusCode<300){
//       final extractresponse = json.decode(request.body);
//       return extractresponse;
//     }
//     else{
//       return null;
//     }
//   } catch (e) {
//     return null;
//   }
// }

getmethod()async{
  try {
    Uri ul = Uri.parse(url);
    final request = await http.get(ul,headers: headers,);
    if(request.statusCode>=200&&request.statusCode<300){
      final extractresponse = json.decode(request.body);
      return extractresponse;
    }
    else{
      return null;
    }
  } catch (e) {
    return null;
  }
}