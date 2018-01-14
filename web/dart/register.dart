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
  querySelector('#insertBtn').onClick.listen(makePostRequest);
  querySelector('#rangeLabel').onClick.listen(openWindow);
}

Future makePostRequest(Event e) async {

  var client = new BrowserClient();
  var url = 'http://0.0.0.0:8080/addGrade';
  InputElement StudentName = querySelector('#name');
  InputElement CourseName = querySelector('#course');
  InputElement Grade = querySelector('#score');
  String StudentnameValue = StudentName.value;
  String CoursenameValue = CourseName.value;
  String GradeValue = Grade.value;

  var response =
      await client.post(url,body: '{"StudentName":"' + StudentnameValue + '","CourseName":"' + CoursenameValue + '","Grade":"' + GradeValue + '"}');

  if(response.statusCode == 200){
    Map responseData = JSON.decode(response.body);
    if(responseData["post"] == "true"){
      querySelector('#table-name').innerHtml = StudentnameValue;
      querySelector('#table-course').innerHtml = CoursenameValue;
      querySelector('#table-grade').innerHtml = GradeValue;
    }
  }

  else{
    window.alert("无法连接服务器！");
  }
}

openWindow(Event e){
  window.open('range.html', '');
}