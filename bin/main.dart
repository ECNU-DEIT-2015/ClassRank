import 'package:redstone/redstone.dart' as app;
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'dart:convert' show JSON;
import 'package:sqljocky5/sqljocky.dart';
import 'package:sqljocky5/utils.dart';
import 'dart:async';
import 'package:shelf_cors/shelf_cors.dart' as shelf_cors;

@app.Route("/login", methods: const [app.POST])
login(@app.Body(app.TEXT) String userData) {
  Map data = JSON.decode(userData);
  var returnData = GetUsernameAndPassword(data['Usrname'],data['Password']);
  return returnData;
}

Future<String> GetUsernameAndPassword(String Usrname, String Password) async{
  var pool = new ConnectionPool(host: 'www.muedu.org',port: 3306, user: 'deit-2015', password: 'deit@2015!', db: 'project_2015_6', max: 5);
  var results = await pool.query('SELECT * from userInformation');
  var ReturnString;
  await results.forEach((row) {
       if(Usrname == row[0] && Password == row[1]){
         ReturnString = '{"post":"true"}';
       }
       else{
         ReturnString = '{"post":"false"}';
       }
});
  return ReturnString;
}


@app.Route("/addGrade",methods: const [app.POST])
addgrade(@app.Body(app.TEXT) String GradeData){
  Map gradedata = JSON.decode(GradeData);
  var returnData = addGradeData(gradedata["StudentName"], gradedata["CourseName"],gradedata["Grade"]);
  return returnData;
}

Future<String> addGradeData(String StudentName, String CourseName, String Grade) async{
  var pool = new ConnectionPool(host: 'www.muedu.org',port: 3306, user: 'deit-2015', password: 'deit@2015!', db: 'project_2015_6', max: 5);
  int maxnum = 0;
  var ReturnString;
  var result = await pool.query('SELECT * FROM Grades');
  await result.forEach((row){
    maxnum++;
  });
  await pool.query('INSERT INTO Grades (StudentId, StudentName, CourseName, GradeNum) VALUES ("' + (maxnum+1).toString() + '", "' + StudentName + '","' + CourseName + '","' + Grade + '")');
  ReturnString = '{"post":"true"}';
  return ReturnString;
}

@app.Route("/average",methods: const [app.POST])
getaver(@app.Body(app.TEXT) String CourseData){
  Map coursedata = JSON.decode(CourseData);
  var returnData = getAverage(coursedata["courseName"]);
  return returnData;
}

Future<String> getAverage(String courseName) async{
  var pool = new ConnectionPool(host: 'www.muedu.org',port: 3306, user: 'deit-2015', password: 'deit@2015!', db: 'project_2015_6', max: 5);
  int totalgrade = 0;
  int totalnum = 0;
  var ReturnString;
  var result = await pool.query('SELECT * FROM Grades WHERE CourseName="' + courseName + '"');
  await result.forEach((row){
      totalgrade = totalgrade + int.parse(row[3]);
      totalnum++;
  });
  ReturnString = '{"post":"true","average":"' + (totalgrade/totalnum).toString() + '"}';
  return ReturnString;
}

@app.Route("/middle",methods: const [app.POST])
getmiddle(@app.Body(app.TEXT) String CourseData){
  Map coursedata = JSON.decode(CourseData);
  var returnData = getMiddle(coursedata["courseName"]);
  return returnData;
}

Future<String> getMiddle(String courseName) async{
  var pool = new ConnectionPool(host: 'www.muedu.org',port: 3306, user: 'deit-2015', password: 'deit@2015!', db: 'project_2015_6', max: 5);
  List grade = [];
  List name = [];
  List course = [];
  int i = 0;
  int middle = 0;
  var ReturnString;
  var result = await pool.query('SELECT * FROM Grades WHERE CourseName="' + courseName + '"');
  await result.forEach((row){
    name.add(row[1]);
    course.add(row[2]);
    grade.add(int.parse(row[3]));
  });
  grade.sort();
  if(grade.length%2 == 0){
    middle = (grade[(grade.length + 1)~/2 - 1] + grade[(grade.length + 1)~/2])/2;
  }
  else{
    middle = grade[(grade.length + 1)~/2 - 1];
  }
  ReturnString = '{"post":"true","middle":"' + middle.toString() + '"}';
  return ReturnString;
}

@app.Route("/max",methods: const [app.POST])
getmax(@app.Body(app.TEXT) String CourseData){
  Map coursedata = JSON.decode(CourseData);
  var returnData = getMax(coursedata["courseName"]);
  return returnData;
}

Future<String> getMax(String courseName) async{
  var pool = new ConnectionPool(host: 'www.muedu.org',port: 3306, user: 'deit-2015', password: 'deit@2015!', db: 'project_2015_6', max: 5);
  int MaxGrade = 0;
  String MaxName;
  var ReturnString;
  var result = await pool.query('SELECT * FROM Grades WHERE CourseName="' + courseName + '"');
  await result.forEach((row){
    if(MaxGrade < int.parse(row[3])){
      MaxGrade = int.parse(row[3]);
      MaxName = row[1];
    }
  });
  ReturnString = '{"post":"true","maxNum":"' + MaxGrade.toString() + '","maxName":"' + MaxName.toString() + '"}';
  return ReturnString;
}

main()
{
  Map corsHeaders1 = {
    "Access-Control-Allow-Methods": "POST",
    "Access-Control-Allow-Origin": "*",
  };
  shelf.Middleware middleware = shelf_cors.createCorsHeadersMiddleware(corsHeaders: corsHeaders1);
  app.setupConsoleLog();
  app.addShelfMiddleware(middleware);
  app.start();
}

