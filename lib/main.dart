import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mastering_stream/stream.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const StreamHomePage(),
    );
  }
}

class StreamHomePage extends StatefulWidget {
  const StreamHomePage({super.key});

  @override
  _StreamHomePageState createState() => _StreamHomePageState();
}

class _StreamHomePageState extends State<StreamHomePage> {
  Color? bgColor;
  ColorStream colorStream = ColorStream();
  var lastNumber;
  StreamController? numberStreamController;
  NumberStream numberStream = NumberStream();
  late StreamTransformer transformer;
  late StreamSubscription? subscription;
  late StreamSubscription? subscription2;
  String values = '';

  @override
  void initState() {
    super.initState();
    numberStreamController = numberStream.controller;
    // Stream? stream = numberStreamController?.stream;
    Stream? stream = numberStreamController?.stream.asBroadcastStream();

    // transformer = StreamTransformer<int, dynamic>.fromHandlers(
    //     handleData: (value, sink) {
    //       sink.add(value * 10);
    //     },
    //     handleError: (error, trace, sink) {
    //       sink.add(-1);
    //     },
    //     handleDone: (sink) => sink.close());
    // stream?.listen((event) {
    //   setState(() {
    //     lastNumber = event;
    //   });
    // }).onError((error) {
    //   setState(() {
    //     lastNumber = error;
    //   });
    // });

    // subscription = stream?.listen((event) {
    //   setState(() {
    //     lastNumber = event;
    //   });
    // });
    subscription = stream?.listen((event) {
      setState(() {
        values += '$event - ';
      });
    });
    subscription2 = stream?.listen((event) {
      setState(() {
        values += '$event - ';
      });
    });
    subscription?.onError((error) {
      setState(() {
        lastNumber = -1;
      });
    });
    subscription?.onDone(() {
      print('OnDone was called');
    });
    // stream?.transform(transformer).listen((event) {
    //   setState(() {
    //     lastNumber = event;
    //   });
    // }).onError((error) {
    //   setState(() {
    //     lastNumber = error;
    //   });
    // });
    changeColor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Stream')),
        body: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: bgColor),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(values),
                  ElevatedButton(
                      onPressed: () => addRandomNumber(),
                      child: Text('New Random Number')),
                  ElevatedButton(
                    onPressed: () => stopStream(),
                    child: Text('Stop Stream'),
                  )
                ])));
  }

  void addRandomNumber() {
    Random random = Random();
    int myNum = random.nextInt(10);
    if (!numberStreamController!.isClosed) {
      numberStream.addNumberToSink(myNum);
    } else {
      setState(() {
        lastNumber = -1;
      });
    }
  }

  void stopStream() {
    numberStreamController?.close();
  }

  // void addRandomNumber() {
  //   Random random = Random();
  //   int myNum = random.nextInt(10);
  //   //numberStream.addNumberToSink(myNum);
  //   numberStream.addError();
  // }

  changeColor() async {
    // await for (var eventColor in colorStream.getColors()) {
    //   setState(() {
    //     bgColor = eventColor;
    //   });
    // }
    colorStream.getColors().listen((eventColor) {
      setState(() {
        bgColor = eventColor;
      });
    });
  }
}
