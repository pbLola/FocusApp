import 'package:flutter/material.dart'
    show
        AppBar,
        BuildContext,
        Card,
        Center,
        CircularProgressIndicator,
        Column,
        EdgeInsets,
        FontWeight,
        MainAxisSize,
        Padding,
        Scaffold,
        SizedBox,
        State,
        StatefulWidget,
        Text,
        TextStyle,
        Widget;
import 'package:http/http.dart' as http;
import 'dart:convert';

class Information {
  final String title;
  final String body;

  Information({required this.title, required this.body});

  factory Information.fromJson(Map<String, dynamic> json) {
    return Information(
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }
}

class InformacoesPage extends StatefulWidget {
  @override
  _InformacoesPageState createState() => _InformacoesPageState();
}

class _InformacoesPageState extends State<InformacoesPage> {
  Information? _information;
  String _nome = '';
  String _ano = '';
  String _faculdade = '';

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/pbLola/info-focusapp/main/informacoes.json'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _nome = data['nome'];
        _faculdade = data['faculdade'];
        _ano = data['ano'];
      });
    } else {
      print('Erro na obtenção do JSON: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    var center = Center(
      child: _information != null
          ? Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Mais informações',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                      width: 30,
                    ),
                    Text(
                      ' $_nome',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      ' $_faculdade',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      ' $_ano',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            )
          : CircularProgressIndicator(),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Sobre'),
      ),
      body: center,
    );
  }
}
