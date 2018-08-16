import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:teste_speech/second.dart';

void main() {
  runApp(new MyAppLess());
}

class MyAppLess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Speech'),
      ),
      body: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  SpeechRecognition _speech;

  bool _isListening = false;
  bool _speechRecognitionAvailable = false;
  String transcription = '';
  String _currentLocale = 'pt_BR';

  @override
  void initState() {
    super.initState();
    activateSpeechRecognizer();
  }

  void activateSpeechRecognizer() {
    _speech = new SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setCurrentLocaleHandler(onCurrentLocale);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.activate().then((res) => _speechRecognitionAvailable = res);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Padding(
        padding: new EdgeInsets.all(9.0),
        child: new Center(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Expanded(
                  child: new Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.grey.shade200,
                child: new Text(transcription),
              )),
              _buildButton(
                onPressed: _speechRecognitionAvailable && !_isListening
                    ? () => start()
                    : null,
                label: _isListening ? 'Listening...' : 'Listen (pt_BR)',
              ),
              _buildButton(
                onPressed: _isListening ? () => cancel() : null,
                label: 'Cancel',
              ),
              _buildButton(
                onPressed: _isListening ? () => stop() : null,
                label: 'Stop',
              ),
              _buildButton(
                onPressed: _isListening ? () => confirm() : null,
                label: 'Confirm',
              ),
              Padding(
                  padding: new EdgeInsets.all(12.0),
                  child: new RaisedButton(
                    color: Colors.cyan.shade600,
                    onPressed: () => Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new SecondScreen(transcription))),
                    child: new Text(
                      'Edit',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({String label, VoidCallback onPressed}) => new Padding(
      padding: new EdgeInsets.all(12.0),
      child: new RaisedButton(
        color: Colors.cyan.shade600,
        onPressed: onPressed,
        child: new Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ));

  void start() => _speech
      .listen(locale: _currentLocale)
      .then((result) => print('_MyAppState.start => result ${result}'));

  void cancel() =>
      _speech.cancel().then((result) => setState(() => _isListening = result));

  void stop() =>
      _speech.stop().then((result) => setState(() => _isListening = result));

  void confirm() => () {
        print('CONFIRMADO!');
      };

  void edit(BuildContext contex) {
    Navigator.push(
      contex,
      MaterialPageRoute(builder: (context) => SecondScreen(transcription)),
    );
  }

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onCurrentLocale(String locale) =>
      setState(() => _currentLocale = locale);

  void onRecognitionStarted() => setState(() => _isListening = true);

  void onRecognitionResult(String text) => setState(() => transcription = text);

  void onRecognitionComplete() => setState(() => _isListening = false);
}
