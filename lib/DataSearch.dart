import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pokedex_app/HomePage.dart';
import 'pokeData.dart';
import 'package:pokedex_app/pokeInfo.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DataSearch extends SearchDelegate<String> {
  PokeData listPoke;
  bool homeData;
  Color _backgroundColor, _textColor;

  DataSearch({String hintText = "Search Pokemon", this.listPoke, this.homeData})
      : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  @override
  List<Widget> buildActions(BuildContext context) {
    if (homeData == true) {
      _backgroundColor = Color.fromRGBO(30, 30, 30, 1);
      _textColor = Colors.white;
    } else {
      _backgroundColor = Color.fromRGBO(255, 255, 255, 1);
      _textColor = Colors.black;
    }
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implementar o que acontece ao clicar na opção.
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Pokemon> suggestionList = query.isEmpty
        ? listPoke.pokemon
        : listPoke.pokemon
            .where((typed) => typed.name.startsWith(query))
            .toList();
    return ListView.builder(
      itemBuilder: (context, index) => Container(
          color: _backgroundColor,
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PokeInfo(
                            pokeData: listPoke.pokemon.elementAt(
                                listPoke.pokemon.indexWhere((element) =>
                                    element.name ==
                                    suggestionList.elementAt(index).name)),
                            homeData: homeData,
                          )));
            },
            leading: Icon(
              MdiIcons.pokeball,
              color: _textColor,
            ),
            title: RichText(
              text: TextSpan(
                  text: suggestionList
                      .elementAt(index)
                      .name
                      .substring(0, query.length),
                  style: TextStyle(
                      color: Colors.greenAccent, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                        text: suggestionList
                            .elementAt(index)
                            .name
                            .substring(query.length),
                        style: TextStyle(color: _textColor))
                  ]),
            ),
          )),
      itemCount: suggestionList.length,
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      primaryColor: Color.fromRGBO(220, 20, 60, 1),
    );
  }
}
