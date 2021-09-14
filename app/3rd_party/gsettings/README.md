[![Pub Package](https://img.shields.io/pub/v/gsettings.svg)](https://pub.dev/packages/gsettings)

Provides a client to use [GSettings](https://developer.gnome.org/gio/stable/GSettings.html) - a settings database used for storing user preferences on Linux.

```dart
import 'package:dbus/dbus.dart';
import 'package:gsettings/gsettings.dart';

void main() async {
  var schema = GSettings('org.gnome.desktop.interface');
  var value = await schema.get('font-name');
  var font = (value as DBusString).value;
  print('Current font set to: $font');
}
```

## Contributing to gsettings.dart

We welcome contributions! See the [contribution guide](CONTRIBUTING.md) for more details.
