import 'dart:io' show Platform;
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

class Counter with ChangeNotifier {
  int value = 0;
  void increment() {
    value += 1;
    notifyListeners();
  }
  void decrement() {
    value -= 1;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Counter',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Age Counter',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: false,
      ),
      body: Consumer<Counter>(
        builder: (context, counter, child) {
          double sliderValue = 0;
          Color backgroundColor;
          String message;

          // Change background color based on counter value
          if (counter.value >= 0 && counter.value <= 12) {
            backgroundColor = const Color.fromARGB(255, 178, 203, 247);
            message = 'You\'re a child!';
          } else if (counter.value >= 13 && counter.value <= 19) {
            backgroundColor = const Color.fromARGB(255, 160, 255, 209);
            message = 'Teenager Time!';
          } else if (counter.value >= 20 && counter.value <= 30) {
            backgroundColor = const Color.fromARGB(255, 255, 255, 147);
            message = 'You\'re a young adult!';
          } else if (counter.value >= 31 && counter.value <= 50) {
            backgroundColor = const Color.fromARGB(255, 255, 207, 145);
            message = 'You\'re an adult now!';
          } else {
            backgroundColor = Colors.grey;
            message = 'Golden years!';
          }

          return Container(
            color: backgroundColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Message and text
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                      'I am ${counter.value} years old',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),

                  const SizedBox(height: 30),

                  // Increment button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      context.read<Counter>().increment();
                    }, 
                    child: const Text('Increase Age', style: TextStyle(color: Colors.white)),
                  ),

                  // Decrement button
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      context.read<Counter>().decrement();
                    }, 
                    child: const Text('Reduce Age', style: TextStyle(color: Colors.white)),
                  ),
                  
                  // Slider
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Slider(
                      value: counter.value.toDouble(),
                      min: 0,
                      max: 99,
                      thumbColor: Colors.blue,
                      onChanged: (value) {
                        counter.value = value.toInt();
                        counter.notifyListeners();
                      },
                    ),
                  ),
                  
                  // Progress Bar
                  const SizedBox(height: 20),
                  Container(
                    width: max(counter.value.toDouble(), 0),
                    height: 20,
                    decoration: BoxDecoration(
                      color: counter.value <= 33 
                          ? Colors.green 
                          : counter.value <= 67 
                              ? Colors.yellow 
                              : Colors.red,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              ),
            )
          );
        }, 
      ),
    );
  }
}
