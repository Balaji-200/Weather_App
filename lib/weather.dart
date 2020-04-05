import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

String temp, humidity, pressure, icon, des, wind, city, country,rf;
int aqi=1;
String pm="";
const aqiKey = "fdc867ccd627e1365361262b0875d40ae9453031";
const opApiKey = "877057fae069a92c77cd2eeb169c6d46";
var opurl =
    "http://api.openweathermap.org/data/2.5/weather?units=metric&appid=";
var aqurl = "http://api.waqi.info/feed/";
Future<Weather> getWeather(String city,BuildContext context) async {
      final response = await http.get('$opurl$opApiKey&q=$city');
      try{
      return Weather.getWeather(city, json.decode(response.body));
    }on Error{
    return await  _connectError(context);
  }
}

Future<Aqi> getAqi(String city,BuildContext context) async {
  final response = await http.get('$aqurl$city/?token=$aqiKey');
  try{
    return Aqi.getAqi(city, json.decode(response.body));
  }on Error{
    return await _error(context);
  }
}

Future<Aqi>_error(BuildContext context)async{
  return showDialog<Aqi>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Oops!!'),
          content: SingleChildScrollView(
            child:ListBody(
              children:<Widget>[
                Text('1. Check the spelling of the city name.'),
                Text('2. Check your internet connection.')
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text('Ok'),)
          ],
        );
      }
    );
}

Future<Weather>_connectError(BuildContext context)async{
  return showDialog<Weather>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Oops!!'),
          content: SingleChildScrollView(
            child:ListBody(
              children:<Widget>[
                Text('1. Check your internet connection.')
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text('Ok'),)
          ],
        );
      }
    );
}

class Aqi {
  int aqi;
  String pm25;
  Aqi({this.aqi, this.pm25});
  factory Aqi.getAqi(city, Map<String, dynamic> json) {
    print(json['data']['aqi']);
    return Aqi(
      aqi: json['data']['aqi'],
      pm25: json['data']['iaqi']['pm25']['v'].toString(),
    );
  }
}

class Weather {
  String temp;
  String humidity;
  String des;
  String icon;
  String pressure;
  String wind;
  String city;
  String rf;
  String country;
  Weather({
    this.temp,
    this.humidity,
    this.des,
    this.icon,
    this.pressure,
    this.wind,
    this.city,
    this.country,
    this.rf
  });
  factory Weather.getWeather(city, Map<String, dynamic> json) {
    return Weather(
      temp: json['main']['temp'].toString(),
      humidity: json['main']['humidity'].toString(),
      des: json['weather'][0]['description'],
      pressure: json['main']['pressure'].toString(),
      icon: json['weather'][0]['icon'].toString(),
      wind: json['wind']['speed'].toString(),
      city: json['name'],
      country: json['sys']['country'],
      rf: json['main']['feels_like'].toString(),
    );
  }
}

class AqiData extends StatefulWidget {
  @override
  _AqiDataState createState() => _AqiDataState();
}

class _AqiDataState extends State<AqiData> {
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.black54),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(8),
      child: Table(
        border: TableBorder(
          verticalInside: BorderSide(
            color: Colors.white38,
          ),
        ),
        children: <TableRow>[
          TableRow(
            children: [
              Column(
                children: <Widget>[
                  Text(aqi.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 35, color: _color())),
                  _aqiDescription(),
                ],
              ),
              Table(
                border: TableBorder(
                  horizontalInside: BorderSide(
                    color: Colors.white38,
                  ),
                ),
                children: <TableRow>[
                  TableRow(
                    children: [
                      Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Real feel  $rf\u2103',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20,color: Colors.white),
                          )),
                    ],
                  ),
                  TableRow(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Center(
                            child: Text(
                          'PM\u2082.\u2085 -  $pm \u03bcg/m\u00b3',
                          style: TextStyle(fontSize: 20,color:Colors.white),
                        )),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

_color(){
    if (aqi >= 0 && aqi <= 50) {
      return Colors.green;
    } else if (aqi >= 51 && aqi <= 100) {
      return Colors.yellow;
    } else if (aqi >= 101 && aqi <= 150) {
      return Colors.orange;
    } else if (aqi >= 151 && aqi <= 200) {
      return Colors.red;
    } else if (aqi >= 201 && aqi <= 300) {
      return Colors.red[900];
    } else {
      return Colors.brown;
    }
    }
  _aqiDescription(){
    if (aqi >= 0 && aqi <= 50) {
      return Text(
        'Good',
        style: TextStyle(color: _color(), fontSize: 20),
      );
    } else if (aqi >= 51 && aqi <= 100) {
      return Text(
        'Moderate',
        style: TextStyle(color: _color(), fontSize: 20),
      );
    } else if (aqi >= 101 && aqi <= 150) {
      return Text(
        'Unhealthy for kids',
        style: TextStyle(color: _color(), fontSize: 20),
      );
    } else if (aqi >= 151 && aqi <= 200) {
      return Text(
        'Unhealthy',
        style: TextStyle(color: _color(), fontSize: 20),
      );
    } else if (aqi >= 201 && aqi <= 300) {
      return Text(
        'Very Unhealthy',
        style: TextStyle(color: _color(), fontSize: 20),
      );
    } else {
      return Text(
        'Hazardous',
        style: TextStyle(color: _color(), fontSize: 20),
      );
  }
}
}