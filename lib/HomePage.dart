import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedex_app/pokeInfo.dart';
import 'pokeData.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  PokeData pokeData;

  Future fetchData() async {
    var res = await http.get(
        "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json");
    var decodedJson = jsonDecode(res.body);
    pokeData = PokeData.fromJson(decodedJson);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pokedex"),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: pokeData == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.count(
              crossAxisCount: 2,
              children: pokeData.pokemon
                  .map(
                    (poke) => Padding(
                      padding: EdgeInsets.all(2.0),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PokeInfo(
                            pokeData: poke,
                          )));
                        },
                          child: Card(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(poke.img))),
                            ),
                            Text(
                              poke.name,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      )),
                    ),
                  )
                  .toList()),
    );
  }
}
