import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

Map _data;
List _features;
void main(List<String> args) async {
  _data = await getQuakes();
  _features = _data['features'];
  print(_features);
  runApp(
    new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Quakes(),
    ),
  );
}

class Quakes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quakes'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext ctx, int position) {
          DateTime date = DateTime.fromMillisecondsSinceEpoch(
              _features[position]['properties']['time'],
              isUtc: false);
          String formetted = DateFormat.yMMMMd().format(date);
          return ListTile(
            title: Text(
              formetted,
              style: TextStyle(
                fontSize: 23.0,
                color: Colors.grey[700],
              ),
            ),
            subtitle: Text(
              _features[position]['properties']['place'],
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.grey,
              ),
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              radius: 35.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _features[position]['properties']['mag'].toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: _features.length,
      ),
    );
  }
}

Future<Map> getQuakes() async {
  String url =
      "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
  http.Response response = await http.get(url);
  return json.decode(response.body);
}
