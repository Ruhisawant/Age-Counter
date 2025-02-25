import 'dart:io' show Platform;
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    // Provide the model to all widgets within the app. We're using
    // ChangeNotifierProvider because that's a simple way to rebuild
    // widgets when a model changes. We could also just use
    // Provider, but then we would have to listen to Counter ourselves.
    //
    // Read Provider's docs to learn about all the available providers.
    ChangeNotifierProvider(
      // Initialize the model in the builder. That way, Provider
      // can own Counter's lifecycle, making sure to call `dispose`
      // when not needed anymore.
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

/// Simplest possible model, with just one field.
///
/// [ChangeNotifier] is a class in `flutter:foundation`. [Counter] does
/// _not_ depend on Provider.

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
      title: 'Flutter Demo',
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
                  // Consumer looks for an ancestor Provider widget
                  // and retrieves its model (Counter, in this case).
                  // Then it uses that model to build widgets, and will trigger
                  // rebuilds if the model is updated.
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
                    padding: const EdgeInsets.symmetric(horizontal: 300),
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // You can access your providers anywhere you have access
      //     // to the context. One way is to use Provider.of<Counter>(context).
      //     // The provider package also defines extension methods on the context
      //     // itself. You can call context.watch<Counter>() in a build method
      //     // of any widget to access the current state of Counter, and to ask
      //     // Flutter to rebuild your widget anytime Counter changes.
      //     //
      //     // You can't use context.watch() outside build methods, because that
      //     // often leads to subtle bugs. Instead, you should use
      //     // context.read<Counter>(), which gets the current state
      //     // but doesn't ask Flutter for future rebuilds.
      //     //
      //     // Since we're in a callback that will be called whenever the user
      //     // taps the FloatingActionButton, we are not in the build method here.
      //     // We should use context.read().
      //     var counter = context.read<Counter>();
      //     counter.increment();
      //   },
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
