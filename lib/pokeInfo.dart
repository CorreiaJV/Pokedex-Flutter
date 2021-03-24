import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pokedex_app/HomePage.dart';
import 'pokeData.dart';

// ignore: must_be_immutable
class PokeInfo extends StatefulWidget {
  Pokemon pokeData;
  bool homeData;

  PokeInfo({this.pokeData, this.homeData});

  @override
  _PokeInfoState createState() => _PokeInfoState();
}

class _PokeInfoState extends State<PokeInfo> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  PokeData pokelist;

  Future fetchData() async {
    var res = await http.get(
        "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json");
    var decodedJson = jsonDecode(res.body);
    pokelist = PokeData.fromJson(decodedJson);
    setState(() {});
  }

  Color _cardColor, _textColor;
  int id = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: cardColor(widget.pokeData.type.first),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.home_rounded,
            ),
            iconSize: 35,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(widget.homeData)));
            },
          ),
          title: Text(widget.pokeData.name),
          backgroundColor: cardColor(widget.pokeData.type.first),
          centerTitle: true,
          actions: [_theme()],
        ),
        body: pokelist == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  Positioned(
                      height: MediaQuery.of(context).size.height / 1.35,
                      width: MediaQuery.of(context).size.width - 20,
                      left: 10,
                      top: MediaQuery.of(context).size.height * 0.1,
                      child: GestureDetector(
                        onHorizontalDragEnd: (DragEndDetails details) =>
                            _onHorizontalDrag(details),
                        child: Card(
                          color: _cardColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 120,
                              ),
                              Text(
                                widget.pokeData.name,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                "Height: ${widget.pokeData.height}",
                                style: TextStyle(color: _textColor),
                              ),
                              Text(
                                "Weight: ${widget.pokeData.weight}",
                                style: TextStyle(color: _textColor),
                              ),
                              Text(
                                "Type",
                                style: TextStyle(color: _textColor),
                              ),
                              Row(
                                //Caixinhas com fundo bonitinho
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: widget.pokeData.type
                                    .map((type) => FilterChip(
                                          backgroundColor: cardColor(type),
                                          label: Text(
                                            type,
                                          ),
                                          onSelected: (b) {},
                                        ))
                                    .toList(),
                              ),
                              Text("Weakness",
                                  style: TextStyle(color: _textColor)),
                              Row (children: [Expanded(
                                  flex: 1,
                                  child:Wrap(
                                //Caixinhas com fundo bonitinho
                                alignment: WrapAlignment.spaceEvenly,
                                children: widget.pokeData.weaknesses
                                    .map((weaknesses) => FilterChip(
                                          backgroundColor:
                                              cardColor(weaknesses),
                                          label: Text(weaknesses),
                                          onSelected: (b) {},
                                        ))
                                    .toList(),
                              ))]
                              ),
                              _hasEvo(widget.pokeData),
                            ],
                          ),
                        ),
                      )),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Hero(
                      tag: widget.pokeData.img,
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(widget.pokeData.img))),
                      ),
                    ),
                  ),
                ],
              ));
  }

  Widget _hasEvo(Pokemon pokedata) {
    if (pokedata.nextEvolution != null) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Next Evolution", style: TextStyle(color: _textColor)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: widget.pokeData.nextEvolution
                  .map((nextEvo) => FilterChip(
                        label: Text(nextEvo.name),
                        onSelected: (b) {},
                      ))
                  .toList(),
            )
          ]);
    } else {
      return Container();
    }
  }

  // Funções
  //Trocar de página arrastando para o lado
  void _onHorizontalDrag(DragEndDetails details) {
    if (details.primaryVelocity == 0)
      return; // user have just tapped on screen (no dragging)

    if (details.primaryVelocity.compareTo(0) == -1) {
      id = widget.pokeData.id;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PokeInfo(
                    pokeData: nextPoke(),
                  )));
    } else {
      id = widget.pokeData.id;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PokeInfo(
                    pokeData: previousPoke(),
                  )));
    }
  }

  Pokemon nextPoke() {
    if (id != 151) {
      return pokelist.pokemon.elementAt(id);
    } else {
      return pokelist.pokemon.elementAt(151);
    }
  }

  Pokemon previousPoke() {
    if (id != 1) {
      return pokelist.pokemon.elementAt(id - 2);
    } else {
      return pokelist.pokemon.elementAt(0);
    }
  }

  //Alterar o tema
  Widget _theme() {
    if (widget.homeData == true) {
      _cardColor = Color.fromRGBO(30, 30, 30, 1);
      _textColor = Colors.white;
      return IconButton(
          icon: Icon(
            Icons.nights_stay_outlined,
            size: 30,
          ),
          onPressed: () {
            setState(() {
              widget.homeData = false;
            });
          });
    } else {
      _cardColor = Color.fromRGBO(255, 255, 255, 1);
      _textColor = Colors.black;
      return IconButton(
          icon: Icon(
            Icons.wb_sunny_outlined,
            size: 30,
          ),
          onPressed: () {
            setState(() {
              widget.homeData = true;
            });
          });
    }
  }

  //Cor do card a depender do tipo do pokemon
  Color cardColor(String type) {
    switch (type) {
      case "Normal":
        {
          return Color.fromRGBO(238, 232, 170, 1);
        }
        break;
      case "Grass":
        {
          return Color.fromRGBO(173, 255, 47, 1);
        }
        break;
      case "Fire":
        {
          return Colors.orange;
        }
        break;
      case "Water":
        {
          return Color.fromRGBO(0, 191, 255, 1);
        }
        break;
      case "Electric":
        {
          return Colors.yellow;
        }
        break;
      case "Ice":
        {
          return Color.fromRGBO(135, 206, 250, 1);
        }
        break;
      case "Fighting":
        {
          return Colors.redAccent;
        }
        break;
      case "Ground":
        {
          return Color.fromRGBO(189, 183, 107, 1);
        }
        break;
      case "Poison":
        {
          return Color.fromRGBO(138, 43, 226, 1);
        }
        break;
      case "Flying":
        {
          return Color.fromRGBO(147, 112, 219, 1);
        }
        break;
      case "Psychic":
        {
          return Colors.pinkAccent;
        }
        break;
      case "Bug":
        {
          return Color.fromRGBO(107, 142, 35, 1);
        }
        break;
      case "Rock":
        {
          return Color.fromRGBO(184, 134, 11, 1);
        }
        break;
      case "Ghost":
        {
          return Color.fromRGBO(72, 61, 139, 1);
        }
        break;
      case "Dragon":
        {
          return Color.fromRGBO(220, 20, 60, 1);
        }
        break;
      case "Dark":
        {
          return Color.fromRGBO(47, 79, 79, 1);
        }
        break;
      case "Steel":
        {
          return Color.fromRGBO(176, 196, 222, 1);
        }
        break;
      case "Fairy":
        {
          return Color.fromRGBO(255, 105, 180, 1);
        }
        break;
      default:
        {
          return Colors.grey;
        }
        break;
    }
  }
}
