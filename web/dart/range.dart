import 'package:sqljocky5/sqljocky.dart';
import 'package:http/http.dart';
import '../../bin/main.dart';
import 'package:http/browser_client.dart';
import 'package:redstone/redstone.dart' as app;
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:sqljocky5/utils.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:html';

main() async
{
  querySelector('#avg').onClick.listen(makePostRequestAvg);
  querySelector('#middle').onClick.listen(makePostRequestMiddle);
  querySelector('#max').onClick.listen(makePostRequestMax);
}

Future makePostRequestAvg(Event e) async {

  var client = new BrowserClient();
  var url = 'http://0.0.0.0:8080/average';

  var response =
  await client.post(url,body: '{"courseName":"web01"}');

  if(response.statusCode == 200){
    Map responseData = JSON.decode(response.body);
    if(responseData["post"] == "true"){
      querySelector('#range1-grade').innerHtml = responseData["average"];
      querySelector('#range1-course').innerHtml = "web01";
    }
  }
}

Future makePostRequestMiddle(Event e) async {

  var client = new BrowserClient();
  var url = 'http://0.0.0.0:8080/middle';

  var response =
  await client.post(url,body: '{"courseName":"web01"}');

  if(response.statusCode == 200){
    Map responseData = JSON.decode(response.body);
    if(responseData["post"] == "true"){
      querySelector('#range1-grade').innerHtml = responseData["middle"];
      querySelector('#range1-course').innerHtml = "web01";
    }
  }
}

Future makePostRequestMax(Event e) async {

  var client = new BrowserClient();
  var url = 'http://0.0.0.0:8080/max';

  var response =
  await client.post(url,body: '{"courseName":"web01"}');

  if(response.statusCode == 200){
    Map responseData = JSON.decode(response.body);
    if(responseData["post"] == "true"){
      querySelector('#range1-grade').innerHtml = responseData["maxNum"];
      querySelector('#range1-name').innerHtml = responseData["maxName"];
      querySelector('#range1-course').innerHtml = "web01";
    }
  }
}