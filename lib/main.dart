import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterapp/models/Imagenes.dart';
import 'package:http/http.dart' as http;

void main(List<String> args) {
  runApp(WebFlutter());
}

class WebFlutter extends StatefulWidget {

  @override
  State<WebFlutter> createState() => _WebFlutterState();
}

class _WebFlutterState extends State<WebFlutter> {
  late Future<List<Imagenes>> _listadoImagenes;

  Future<List<Imagenes>> _getImagenes() async{
    final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/photos"));

    String cuerpo;

    List<Imagenes> lista = [];

    if (response.statusCode == 200) {
      print(response.body);
      cuerpo = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(cuerpo);
      for (var item in jsonData) {
        lista.add(Imagenes(item["title"], item["thumbnailUrl"]));
      }
    } else {
      throw Exception("Falla en conexion estado 500");
    }
    return lista;
  }

  void initState(){
    super.initState();
    _listadoImagenes = _getImagenes();
  }

  @override
  Widget build(BuildContext context) {
    var futureBuilder = FutureBuilder(
      future: _listadoImagenes,
      builder: (context, snapshot){
        if (snapshot.hasData) {
          return ListView(
            children: _listadoImageness(snapshot.data),
          );
        } else {
          print(snapshot.error);
          return Text("Error");
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Consumo WebService',
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'API'
          ),
        ),
        body: futureBuilder
      ),
    );
  }
  List<Widget> _listadoImageness(data){
    List<Widget> imagen = [];

    for (var itempk in data) {
      imagen.add(
        Card(
          elevation: 2.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Text(itempk.num),
              Container(
                padding: EdgeInsets.all(2.0),
                height: 500,
                width: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(itempk.thumbnailUrl),
                    scale: 0.05,
                  )
                ),
              ),
              Text(itempk.title)
            ],
          ),
        )
      );
    }
    return imagen;
  }
}