import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() async {
  Map _data = await getJson();
  List _features = _data['features'];

  runApp(new MaterialApp(
    home: new Scaffold(
      appBar: new AppBar(
        title: new Text("Quake!"),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
      body: new Center(
        child: new ListView.builder(
          itemCount: _features.length,
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (BuildContext context, int position) {
            if (position.isOdd) return new Divider();

            final index = position ~/ 2;

            var format = new DateFormat('dd-MM-yyyy').add_jm();

            var date = format.format(new DateTime.fromMicrosecondsSinceEpoch(
              _features[index]['properties']['time'] * 1000,
              isUtc: false,
            ));

            return new ListTile(
              title: new Text(
                "$date",
                style: new TextStyle(
                  fontSize: 13.4,
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.w900,
                ),
              ),
              subtitle: new Text(
                "${_features[index]['properties']['place']}",
                style: new TextStyle(
                    fontSize: 12.4,
                    color: Colors.lightBlue,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500),
              ),
              leading: new CircleAvatar(
                backgroundColor: Colors.green,
                child: new Text(
                  "${_features[index]['properties']['mag']}",
                  style: new TextStyle(
                    fontSize: 18.4,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              onTap: () {
                _showOnTapMessage(
                    context, "${_features[index]['properties']['title']}");
              },
            );
          },
        ),
      ),
    ),
  ));
}

Future<Map> getJson() async {
  String apiUrl =
      'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson';

  http.Response response = await http.get(apiUrl);
  return json.decode(response.body);
}

void _showOnTapMessage(BuildContext context, String message) {
  var alert = new AlertDialog(
    title: new Text("Quake Alert!"),
    content: new Text(message),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: new Text("OK"),
      )
    ],
  );

  showDialog(context: context, builder: (context) => alert);
}
