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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
      ],
      builder: (context, child) {
        var isDarkMode = context.watch<SettingsProvider>().isDarkMode;
        return AnimatedCrossFade(
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
          firstChild: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: isDarkMode == true ? Colors.blue : Colors.blue,
              brightness: isDarkMode == true ? Brightness.dark : Brightness.light,
            ),
            home: MyHomePage(title: 'Flutter Demo Home Page'),
          ),
          secondChild: Builder(builder: (_) {
            var xsettings = GSettings('com.deepin.xsettings');
            xsettings.get('theme-name').then((value) {
              Future.delayed(
                Duration(seconds: 1),
                () => context.read<SettingsProvider>().setProps(isDarkMode: value.toString().contains('dark')),
              );
            });
            xsettings.keysChanged.listen((event) {
              xsettings.get('theme-name').then((value) {
                context.read<SettingsProvider>().setProps(isDarkMode: value.toString().contains('dark'));
              });
            });
            return CircularProgressIndicator();
          }),
          duration: Duration(seconds: 1),
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
