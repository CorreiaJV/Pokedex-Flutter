import 'package:flutter/material.dart';
import 'pokeData.dart';

class PokeInfo extends StatelessWidget {
  final Pokemon pokeData;

  PokeInfo({this.pokeData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.cyan,
        appBar: AppBar(
          title: Text(pokeData.name),
          backgroundColor: Colors.cyan,
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Positioned(
              height: MediaQuery.of(context).size.height / 1.5,
              width: MediaQuery.of(context).size.width - 20,
              left: 10,
              top: MediaQuery.of(context).size.height * 0.1,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: 120,),
                    Text(
                      pokeData.name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text("Height: ${pokeData.height}"),
                    Text("Weight: ${pokeData.weight}"),
                    Text("Type"),
                    Row(
                      //Caixinhas com fundo bonitinho
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: pokeData.type
                          .map((type) => FilterChip(
                                label: Text(type),
                                onSelected: (b) {},
                              ))
                          .toList(),
                    ),
                    Text("Weakness"),
                    Row(
                      //Caixinhas com fundo bonitinho
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: pokeData.weaknesses
                          .map((weaknesses) => FilterChip(
                                label: Text(weaknesses),
                                onSelected: (b) {},
                              ))
                          .toList(),
                    ),
                    _hasEvo(pokeData),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Hero(
                tag: pokeData.img,
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                      image:
                          DecorationImage(
                            fit: BoxFit.cover,
                              image: NetworkImage(pokeData.img))),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _hasEvo(Pokemon pokedata) {
    if (pokedata.nextEvolution != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: pokeData.nextEvolution
            .map((nextEvo) => FilterChip(
                  label: Text(nextEvo.name),
                  onSelected: (b) {},
                ))
            .toList(),
      );
    } else {
      return Container();
    }
  }
}
