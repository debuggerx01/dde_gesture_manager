import 'package:dde_gesture_manager/models/configs.dart';
import 'package:dde_gesture_manager/models/configs.provider.dart';
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
        ChangeNotifierProvider(create: (context) => ConfigsProvider()),
      ],
      builder: (context, child) {
        var isDarkMode = context.watch<SettingsProvider>().isDarkMode;
        var brightnessMode = context.watch<ConfigsProvider>().brightnessMode;
        late bool showDarkMode;
        if (brightnessMode == BrightnessMode.system) {
          showDarkMode = isDarkMode ?? false;
        } else {
          showDarkMode = brightnessMode == BrightnessMode.dark;
        }
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: showDarkMode ? Colors.blue : Colors.blue,
            brightness: showDarkMode ? Brightness.dark : Brightness.light,
          ),
          home: AnimatedCrossFade(
            crossFadeState: isDarkMode != null ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            alignment: Alignment.center,
            layoutBuilder: (topChild, topChildKey, bottomChild, bottomChildKey) => Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(key: bottomChildKey, child: bottomChild),
                Positioned(key: topChildKey, child: topChild),
              ],
            ),
            firstChild: Builder(builder: (context) {
              Future.microtask(() => initEvents(context));
              return Container();
            }),
            secondChild: MyHomePage(title: 'Flutter Demo Home Page'),
            duration: Duration(milliseconds: 500),
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
    var brightnessMode = context.watch<ConfigsProvider>().brightnessMode;
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
            ListTile(
              title: const Text('System'),
              leading: Radio<BrightnessMode>(
                value: BrightnessMode.system,
                groupValue: brightnessMode,
                onChanged: (BrightnessMode? value) {
                  context.read<ConfigsProvider>().setProps(brightnessMode: value);
                },
              ),
            ),
            ListTile(
              title: const Text('Light'),
              leading: Radio<BrightnessMode>(
                value: BrightnessMode.light,
                groupValue: brightnessMode,
                onChanged: (BrightnessMode? value) {
                  setState(() {
                    context.read<ConfigsProvider>().setProps(brightnessMode: value);
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Dark'),
              leading: Radio<BrightnessMode>(
                value: BrightnessMode.dark,
                groupValue: brightnessMode,
                onChanged: (BrightnessMode? value) {
                  setState(() {
                    context.read<ConfigsProvider>().setProps(brightnessMode: value);
                  });
                },
              ),
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
