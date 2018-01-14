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

InputElement username;
InputElement password;
String usernameValue;
String passwordValue;

main() async
{
  querySelector('#btn-Login').onClick.listen(makePostRequest);
}

Future makePostRequest(Event e) async {

  var client = new BrowserClient();
  var url = 'http://0.0.0.0:8080/login';
  username = querySelector('#username');
  password = querySelector('#password');
  usernameValue = username.value;
  passwordValue = password.value;
  var response =
       await client.post(url,body: '{"Usrname":"' + usernameValue + '","Password":"' + passwordValue + '"}');

  if(response.statusCode == 200){
    Map responseData = JSON.decode(response.body);
    if(responseData["post"] == "true"){
      window.open("register.html","");
    }
    else{
      window.alert("用户名或密码错误！");
    }
  }

  else{
    window.alert("无法连接服务器！");
  }
}

