import 'package:flutter/cupertino.dart';
import './weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(WeatherApp());

class WeatherApp extends StatelessWidget {
  WeatherApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.black),
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      home: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: Container(
              padding: EdgeInsets.all(5),
              height: 40.0,
              width: 40.0,
              child: Image.asset(
                'assets/weather.png',
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              'Weather',
              style: TextStyle(
                fontFamily: 'DancingScript',
                fontSize: 40.0,
                color: Colors.black87,
              ),
            ),
            backgroundColor: Colors.grey[200],
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/weather.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Search(),
            ),
          ),
        ),
      ),
    );
  }
}

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final input = TextEditingController();
  void initState() {
    super.initState();
    getAqi('mumbai', context).then((value) => setState(() {
          aqi = value.aqi;
          pm = value.pm25;
        }));
    getWeather('mumbai', context).then((value) => setState(() {
          rf = value.rf;
          temp = value.temp;
          humidity = value.humidity;
          pressure = value.pressure;
          icon = value.icon;
          wind = value.wind;
          des = value.des;
          country = value.country;
          city = value.city;
        }));
  }

  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: TextField(
                  autocorrect: true,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.send,
                  decoration: InputDecoration(
                    icon: Icon(Icons.location_city),
                    hintText: ' Search',
                  ),
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                  controller: input,
                  cursorColor: Colors.black87,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: RaisedButton(
                    splashColor: Colors.tealAccent,
                    color: Colors.green,
                    shape: StadiumBorder(),
                    child: Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            'Search',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Container(
                            child: Icon(
                              Icons.search,
                              color: Colors.yellow,
                            ),
                            padding: EdgeInsets.only(left: 5),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      await getAqi(input.text, context).then((value) {
                        setState(() {
                          aqi = value.aqi;
                          pm = value.pm25;
                        });
                      });
                      await getWeather(input.text, context).then((wdata) {
                        setState(() {
                          temp = wdata.temp;
                          humidity = wdata.humidity;
                          pressure = wdata.pressure;
                          icon = wdata.icon;
                          wind = wdata.wind;
                          des = wdata.des;
                          country = wdata.country;
                          city = wdata.city;
                          rf = wdata.rf;
                        });
                      });
                    }),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10, top: 40),
          child: Text(
            '$city, $country',
            style: TextStyle(fontFamily: 'Gotu',fontSize: 40, color: Colors.black87),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 60),
          padding: EdgeInsets.only(left: 10),
          child: Text(
            'Aqi',
            style: TextStyle(fontSize: 25),
          ),
        ),
        AqiData(),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text('Details', style: TextStyle(fontSize: 25,fontFamily: '')),
        ),
        Details(),
      ],
    );
  }
}

class Details extends StatefulWidget {
  @override
  _Detail createState() => _Detail();
}

class _Detail extends State<Details> {
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.black12,
        ),
        child: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            ListTile(
              leading: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/temperature.png'),
                  fit: BoxFit.cover,
                ),
                ),
              ),
              title: Text(
                'Temperature : $temp\u2103',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            ListTile(
              leading: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/humidity.webp'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                'Humidity : $humidity %',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            ListTile(
              leading: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/pressure.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                'Pressure : $pressure  millibar',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            ListTile(
              leading: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/weather.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                'Weather : $des ',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            ListTile(
              leading: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/wind.gif'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                'Wind : $wind mph',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}