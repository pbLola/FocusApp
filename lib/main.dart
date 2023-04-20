import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
      home: MyHomePage(title: 'Focus'),
    );
  }
}

//configurações
class Settings extends StatelessWidget {
  final ValueChanged<int> onPomodoroDurationChange;
  final int initialPomodoroDuration;

  Settings(
      {required this.onPomodoroDurationChange,
      required this.initialPomodoroDuration});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController =
        TextEditingController(text: widget.initialPomodoroDuration.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: Center(
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Duração do Pomodoro',
                style: Theme.of(context).textTheme.headline6,
              ),
              TextField(
                controller: _textEditingController,
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: () {
                  final newDuration =
                      int.tryParse(_textEditingController.text) ?? 0;
                  widget.onPomodoroDurationChange(newDuration);
                  Navigator.pop(context);
                },
                child: Text('Salvar'),
              )
            ],
          ),
        ),
      ),
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
  int _timerValue = 1500;
  int _counter = 1500;
  late Timer _timer;
  bool _isRunning = false;
  bool _isPaused = false;
  int _pausedTime = 0;

  Widget SettingsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Settings()),
    );
    return Container();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _timer.cancel();
          _showTimerFinishedDialog();
        }
      });
    });
  }

  void _pauseTimer() {
    _timer.cancel();
    setState(() {
      _isPaused = true;
      _isRunning = false;
      _pausedTime = _counter;
    });
  }

  void _resetTimer() {
    setState(() {
      _counter = _timerValue;
      _isRunning = false;
      _isPaused = false;
    });
    _timer.cancel();
  }

  void _handleButtonPress() {
    setState(() {
      _isRunning = !_isRunning;
      if (_isRunning) {
        if (_isPaused) {
          _counter = _pausedTime;
        } else {
          _counter = _timerValue;
        }
        _startTimer();
      } else {
        _pauseTimer();
      }
    });
  }

  void _showTimerFinishedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Timer finalizado'),
          content: Text('O timer chegou ao fim!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
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
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: CircularPercentIndicator(
                radius: MediaQuery.of(context).size.width * 0.7,
                lineWidth: 10.0,
                percent: _timerValue / 1500,
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
                FloatingActionButton(
                  heroTag: 'reset',
                  child: Icon(Icons.restart_alt),
                  onPressed: _resetTimer,
                ),
                FloatingActionButton(
                  heroTag: 'play',
                  child: Icon(Icons.play_arrow),
                  onPressed: _startTimer,
                ),
                FloatingActionButton(
                  heroTag: 'pause',
                  child: Icon(Icons.pause),
                  onPressed: _pauseTimer,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
