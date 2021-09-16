import 'package:dde_gesture_manager/models/settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gsettings/gsettings.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:xdg_directories/xdg_directories.dart' as xdgDir;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    print(await xdgDir.configHome);
    print(await xdgDir.cacheHome);
    print(await xdgDir.dataHome);
    print('------');
    print(await xdgDir.configDirs.join('\n'));
    print('------');
    print(await xdgDir.dataDirs.join('\n'));
    print('------');
    print(await xdgDir.runtimeDir);
    print('------');
    var windowManager = WindowManager.instance;
    windowManager.setTitle('Gesture Manager For DDE');
    windowManager.setMinimumSize(const Size(800, 600));
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var xsettings = GSettings('com.deepin.xsettings');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      xsettings.keysChanged.listen((event) {
        xsettings.get('theme-name').then((value) {
          context.read<SettingsProvider>().setProps(isDarkMode: value.toString().contains('dark'));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider(create: (context) => SettingsProvider()),
        ],
        builder: (context, child) {
          var isDarkMode = context.watch<SettingsProvider>().settings.isDarkMode;
          return isDarkMode == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : MaterialApp(
                  title: 'Flutter Demo',
                  theme: ThemeData(
                    primarySwatch: isDarkMode ? Colors.blue : Colors.blue,
                    brightness: isDarkMode ? Brightness.dark : Brightness.light,
                  ),
                  home: MyHomePage(title: 'Flutter Demo Home Page'),
                );
        });
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
