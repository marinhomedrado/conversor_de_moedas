import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=b72462af";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.teal, primaryColor: Colors.white),
    debugShowCheckedModeBanner: false,
  ));
}



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar;
  double euro;

 

  final realcontroller = TextEditingController();
  final dolarcontroller = TextEditingController();
  final eurocontroller = TextEditingController();

   void _clearAll(){
    realcontroller.text = "";
    dolarcontroller.text = "";
    eurocontroller.text = "";
  }


  void _realChanged(String text) {
    if(text.isEmpty)
    {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarcontroller.text = (real/dolar).toStringAsFixed(2);
    eurocontroller.text = (real/euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if(text.isEmpty)
    {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realcontroller.text = (dolar * this.dolar).toStringAsFixed(2);
    eurocontroller.text = (dolar * this.dolar / euro).toStringAsFixed(2); 
  }

  void _euroChanged(String text) {
    if(text.isEmpty)
    {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realcontroller.text = (euro * this.euro).toStringAsFixed(2);
    dolarcontroller.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {

    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: Text(
          "\$ Conversor \$",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Carregando Dados...",
                    style: TextStyle(color: Colors.black, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Erro ao Carregar Dados :(",
                      style: TextStyle(color: Colors.black, fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on,
                            size: 150, color: Colors.amber),
                        buildTextField("Reais", "R\$", realcontroller, _realChanged),
                        Divider(),
                        buildTextField("Dólares", "US\$", dolarcontroller, _dolarChanged),
                        Divider(),
                        buildTextField("Euros", "€", eurocontroller, _euroChanged),
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(request); //aguarda os dados chegarem
  return json.decode(response.body);
}

Widget buildTextField(
    String label, String prefix, TextEditingController c, Function f) {
  return TextFormField(
    controller: c,
    decoration: InputDecoration(
        border: OutlineInputBorder(),
        prefixText: prefix,
        labelText: label,
        labelStyle: TextStyle(fontSize: 20)),
    style: TextStyle(color: Colors.black, fontSize: 20),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}

