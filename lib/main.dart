import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

Map _data;
List _features;
void main(List<String> args) async {
  _data = await getQuakes();
  _features = _data['features'];
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
        leading: Icon(Icons.menu),
        title: Text(
          'Quakes',
          style:
              GoogleFonts.roboto(fontSize: 20.0, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15.0),
        itemBuilder: (BuildContext ctx, int position) {
          if (position.isOdd) return Divider();

          int index = position ~/ 2;
          DateTime date = DateTime.fromMillisecondsSinceEpoch(
              _features[index]['properties']['time'],
              isUtc: false);
          String formetted = DateFormat.yMMMd().format(date);
          return ListTile(
            title: Text(
              formetted,
              style: GoogleFonts.roboto(fontSize: 19.5),
            ),
            subtitle: Text(_features[index]['properties']['place'],
                style: GoogleFonts.roboto(
                  fontSize: 14.5,
                )),
            leading: CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.red,
              child: Text(
                _features[index]['properties']['mag'].toStringAsFixed(2),
                style: GoogleFonts.roboto(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            onTap: () {
              _showAlertDialog(context,
                  " Earthquake of ${_features[index]['properties']['mag']} Magnitude");
            },
          );
        },
        itemCount: _features.length,
      ),
    );
  }

  void _showAlertDialog(BuildContext context, featur) {
    AlertDialog alert = AlertDialog(
      title: Text('Quakes'),
      content: Text(featur),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Ok'),
        ),
      ],
    );
    showDialog(context: context, child: alert);
  }
}

Future<Map> getQuakes() async {
  String url =
      "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
  http.Response response = await http.get(url);
  return json.decode(response.body);
}
