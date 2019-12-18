import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'show_code.dart';
import 'dart:convert';

class Address {
  final String city;
  final List<String> streets;

  Address({
    this.city,
    this.streets
  });

  factory Address.fromJson(Map<String, dynamic> parsedJson) {
    var streetsFromJson  = parsedJson['streets'];
    //print(streetsFromJson.runtimeType);
    // List<String> streetsList = new List<String>.from(streetsFromJson);
    List<String> streetsList = streetsFromJson.cast<String>();

    return new Address(
      city: parsedJson['city'],
      streets: streetsList,
    );
  }

}

class TestHttp extends StatefulWidget {
  final String url;

  TestHttp({String url}) : url = url;

  @override
  State<StatefulWidget> createState() => TestHttpState();
} // TestHttp

class TestHttpState extends State<TestHttp> {
  String _url;
  Address _address;



  @override
  void initState() {
    _url = widget.url;
    super.initState();
  } //initState

  _sendRequestGet() {
    //update form data
    http.get(_url).then((response) {
      _address = Address.fromJson(json.decode(response.body));

      setState(() {}); //reBuildWidget
    }).catchError((error) {
      _address = Address(
        city: '',
        streets: [],
      );

      setState(() {}); //reBuildWidget
    });
  } //_sendRequestGet

  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                RaisedButton(
                    child: Text('Узнать адрес'), onPressed: _sendRequestGet),
                SizedBox(height: 20),
                Text('Город', style: TextStyle(fontSize: 20.0,color: Colors.green)),
                Text(_address == null ? '' : _address.city,
                   style: TextStyle(fontSize: 15, color: Colors.green)),
                SizedBox(height: 20),
                Text('Адреса:', style: TextStyle(fontSize: 20.0,color: Colors.blue)),
                Text(_address == null ? '' : _address.streets[0].toString(),
                    style: TextStyle(fontSize: 20, color: Colors.blue)),
                Text(_address == null ? '' : _address.streets[1].toString(),
                    style: TextStyle(fontSize: 20, color: Colors.blue)),
//                SizedBox(height: 20),
//                Text('Количество очков:', style: TextStyle(fontSize: 20.0,color: Colors.red)),
//                Text(_user == null ? '' : _user.score.toString(),
//                    style: TextStyle(fontSize: 25, color: Colors.red)),
              ],
            )));
  } //build
} //TestHttpState
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Адреса'),
          actions: <Widget>[IconButton(icon: Icon(Icons.code), tooltip: 'Code', onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CodeScreen()));
          })],
        ),
        body: TestHttp(url: 'https://raw.githubusercontent.com/PoojaB26/ParsingJSON-Flutter/master/assets/address.json')
    );
  }
}

void main() => runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp(),
    ),
);

