import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'settings_page.dart';
import 'configuracao.dart';
import 'package:percent_indicator/percent_indicator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'Focus'),
        '/config': (context) => ConfigPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 1500;
  late Timer _timer;
  bool _isRunning = false;
  bool _isPaused = false;

 class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    // Defina aqui a interface do usuário para as configurações
    return Container();
  }
}

void _handleBottomNav(int index, BuildContext context) {
  if (index == 0) {
    _resetTimer();
  } else if (index == 1) {
    _handleButtonPress();
  } else if (index == 2) {
    _pauseTimer();
  } else if (index == 3) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsPage()),
    );
  }
}


  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _counter--;
        if (_counter == 0) {
          _timer.cancel();
        }
      });
    });
  }

  void _pauseTimer() {
    _timer.cancel();
    setState(() {
      _isPaused = true;
      _isRunning = false;
    });
  }

  void _resetTimer() {
    setState(() {
      _counter = 1500;
      _isRunning = false;
      _isPaused = false;
    });
    _timer.cancel();
  }

  void _handleButtonPress() {
    setState(() {
      _isRunning = !_isRunning;
      if (_isRunning) {
        _startTimer();
      } else {
        _pauseTimer();
      }
    });
  }

  String get _formattedTime {
    Duration duration = Duration(seconds: _counter);
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: CircularPercentIndicator(
                radius: MediaQuery.of(context).size.width * 0.7,
                lineWidth: 10.0,
                percent: _counter / 1500,
                center: Text(
                  _formattedTime,
                  style: TextStyle(fontSize: 60.0),
                ),
                progressColor: Colors.blue,
                backgroundColor: Colors.grey,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.restart_alt),
                  iconSize: 40.0,
                  onPressed: _resetTimer,
                ),
                IconButton(
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  iconSize: 60.0,
                  onPressed: _handleButtonPress,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            _resetTimer();
          } else if (index == 1) {
            _handleButtonPress();
          } else if (index == 2) {
            _pauseTimer();
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          }
        },
      ),
    );
  }
}
