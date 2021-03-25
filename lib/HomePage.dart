import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedex_app/pokeInfo.dart';
import 'pokeData.dart';
import 'DataSearch.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  bool isDark = false;

  @override
  HomePageState createState() => HomePageState();

  HomePage(this.isDark);
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  PokeData pokeData;
  DataSearch dataSearch;
  Color _cardColor, _textColor;

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
        backgroundColor: Color.fromRGBO(220, 20, 60, 1),
        appBar: AppBar(
          leading: Container(),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/camera.png",
                fit: BoxFit.cover,
                height: 50,
              ),
              Text("Pokedex"),
            ],
          ),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(220, 20, 60, 0.7),
          actions: [
            iconTheme(),
            IconButton(
                icon: Icon(
                  Icons.search,
                  size: 30,
                ),
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: DataSearch(
                          listPoke: pokeData, homeData: widget.isDark));
                })
          ],
        ),
        body: pokeData == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  Image.asset(
                    "assets/images/pokeBackground.jpeg",
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.height,
                  ),
                  GridView.count(
                      crossAxisCount: 2,
                      children: pokeData.pokemon
                          .map(
                            (poke) => Padding(
                              padding: EdgeInsets.all(2.0),
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PokeInfo(
                                                  pokeData: poke,
                                                  homeData: widget.isDark,
                                                )));
                                  },
                                  child: Card(
                                    color: _cardColor,
                                    shadowColor: Colors.white,
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image:
                                                      NetworkImage(poke.img))),
                                        ),
                                        Text(
                                          poke.name,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: _textColor),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          )
                          .toList()),
                ],
              ));
  }

  Widget iconTheme() {
    if (widget.isDark == true) {
      _cardColor = Color.fromRGBO(0, 0, 0, 0.8);
      _textColor = Colors.white;
      return IconButton(
          icon: Icon(
            Icons.nights_stay_outlined,
            size: 30,
          ),
          onPressed: () {
            setState(() {
              widget.isDark = false;
            });
          });
    } else {
      _cardColor = Color.fromRGBO(255, 255, 255, 0.8);
      _textColor = Colors.black;
      return IconButton(
          icon: Icon(
            Icons.wb_sunny_outlined,
            size: 30,
          ),
          onPressed: () {
            setState(() {
              widget.isDark = true;
            });
          });
    }
  }
}
