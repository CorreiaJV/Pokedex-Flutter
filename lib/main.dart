import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex_app/HomePage.dart';
import 'pokeData.dart';
import 'package:flutter/services.dart';

void main (){
  bool x = true;
  runApp(MaterialApp(
 home: HomePage(x),
  ));
}