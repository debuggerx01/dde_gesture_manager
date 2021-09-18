import 'package:dde_gesture_manager/models/settings.provider.dart';
import 'package:dde_gesture_manager/utils/init.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initConfigs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
      ],
      builder: (context, child) {
        var isDarkMode = context.watch<SettingsProvider>().isDarkMode;
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: isDarkMode == true ? Colors.blue : Colors.blue,
            brightness: isDarkMode == true ? Brightness.dark : Brightness.light,
          ),
          home: AnimatedCrossFade(
            crossFadeState: isDarkMode != null ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            alignment: Alignment.center,
            layoutBuilder: (topChild, topChildKey, bottomChild, bottomChildKey) => Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(key: bottomChildKey, child: bottomChild),
                Positioned(key: topChildKey, child: topChild),
              ],
            ),
            firstChild: MyHomePage(title: 'Flutter Demo Home Page'),
            secondChild: Builder(builder: (context) {
              initEvents(context);
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
            duration: Duration(seconds: 1),
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
