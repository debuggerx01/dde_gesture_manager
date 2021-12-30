
  

  

#  Cherry Toast

<p  align="center">
<img  src="https://github.com/koukibadr/Cherry-Toast/blob/main/cherry_toast_logo.gif?raw=true" height="200"/>
<br>
<b>A new way to display toasts in Flutter in an elegant design and animations</b>
</p>


| ![info_cherry_toast.gif](https://github.com/koukibadr/Cherry-Toast/blob/main/example/info_cherry_toast.gif?raw=true) | ![error_cherry_toast.gif](https://github.com/koukibadr/Cherry-Toast/blob/main/example/error_cherry_toast.gif?raw=true) | ![bottom_cherry_toast.gif](https://github.com/koukibadr/Cherry-Toast/blob/main/example/bottom_cherry_toast.gif?raw=true) |
|--|--|--|
| ![warning_cherry_toast.gif](https://github.com/koukibadr/Cherry-Toast/blob/main/example/warning_cherry_toast.gif?raw=true) | ![success_cherry_toast.gif](https://github.com/koukibadr/Cherry-Toast/blob/main/example/success_cherry_toast.gif?raw=true) | ![right_layout_cherry_toast.gif](https://github.com/koukibadr/Cherry-Toast/blob/main/example/right_layout_cherry_toast.gif?raw=true) |

  

  

##  Cherry Toast v1.0.2


- Support all platforms
- Top and Bottom display position
- Multiple built-in themes
- Built-in animations
- Support null safety
- Elegant design
- Full customizable
- Heartbeat animation on icons
- Customizable icon size and color and display
  

  

##  Installation


To add cherry toast to your project add this line to your `pubspec.yaml` file

```yaml
dependencies:
	cherry_toast: ^1.0.2
```

  

  

##  Parameters


| Name | Description | Required | Default Value |
|--|--|--|--|
| title | The toast title `String` | true | N/A |
| description | the toast description text (nullable) | false | null |
| action | the toast action text (clickable text) | false | null |
| titleStyle | the title text style | false | `TextStyle(color: Colors.black, fontWeight: FontWeight.bold)` |
| descriptionStyle | the description text style | false | `TextStyle(color: Colors.black)` |
| actionStyle | the action text style | false | `TextStyle(color: Colors.black, fontWeight: FontWeight.bold)` |
| displayTitle | indicates whether the title will be rendered or not | false | true |
| icon | the toast displayed icon (IconData) | required when using the default constructor otherwise it's not required | N/A |
| toastPosition | the position of the toast (Top/Bottom) | false | `POSITION.TOP` |
| themeColor | the color that will be applied on the icon back circle (for built-in themes it will match the action text color | required when using the default constructor otherwise it's not required | N/A |
| actionHandler | Function that will be invoked when clicking on the action text | false | null |
| animationDuration | the duration of the animation display and hide | false | `Duration(milliseconds: 1500)` |
| animationCurve | the display animation curve | false | `Curves.ease` |
| animationType | the type of the animation that will be applied on the toast (From left, From right, From top) | false | `ANIMATION_TYPE.FROM_LEFT` |
| autoDismiss | indicates whether the toast will be dismissed automatically or not | false | false |
| toastDuration | the duration of the toast when `autoDismiss` is true | false | `Duration(milliseconds: 3000)` |
| layout | the taost's layout rendering (LTR, RTL) | false | `TOAST_LAYOUT.LTR` |
| displayCloseButton | indicates whether display or not the close button | false | true |
| borderRadius| define the toast border radius | false | 20 |
| iconColor| define the icon color | false | `Colors.black`|
| displayIcon| hide or show the icon on the toast | false | true |
| enableIconAnimation | define wether apply an animation on the icon or not | false | true |
| iconSize | define the icon size | false | 20 |

  

##  Usage

- Simple cherry toast with only title

```dart

CherryToast.success(
	title:  "The simplest cherry toast"
).show(context);

```



  

- Simple cherry toast with action button

```dart

CherryToast.info(
	title:  "User added",
	action:  "Display information",
	actionHandler: (){
		print("Action button pressed");
	},
).show(context);

```

<p  align="center">
<img  src="https://github.com/koukibadr/Cherry-Toast/blob/main/example/cherry_toast_animation.gif?raw=true" height="600"/>
<br>
<b>A new way to display toasts in Flutter in an elegant design and animations</b>
</p>

  

- Toast with description without title

```dart

CherryToast.warning(
	title:  "",
	displayTitle:  false,
	description:  "All information may be deleted after this action",
	animationType:  ANIMATION_TYPE.FROM_TOP,
	action:  "Backup data",
	actionHandler: (){
		print("Hello World!!");
	},
).show(context);

```

  

  

- Toast with nothing but description with different animation type and auto dismiss

```dart
CherryToast.error(
	title:  "",
	displayTitle:  false,
	description:  "Invalid account information",
	animationType:  ANIMATION_TYPE.FROM_RIGHT,
	animationDuration:  Duration(milliseconds:  1000),
	autoDismiss:  true)
.show(context);

```

- Bottom displayed cherry toast

```dart
CherryToast(
	icon:  Icons.alarm_add,
	themeColor:  Colors.pink,
	title:  "",
	displayTitle:  false,
	description:  "A bottom cherry toast example",
	toastPosition:  POSITION.BOTTOM,
	animationDuration:  Duration(milliseconds:  1000),
	autoDismiss:  true)
.show(context);

  

```


- Right layout rendered cherry toast

```dart
CherryToast(
	icon:  Icon(Icons.car_repair),
	themeColor:  Colors.green,
	title:  "",
	displayTitle:  false,
	description:  "هذا مثال تصميم من اليمين",
	toastPosition:  POSITION.BOTTOM,
	layout:  TOAST_LAYOUT.RTL,
	animationType:  ANIMATION_TYPE.FROM_RIGHT,
	action:  "انقر هنا",
	actionStyle:  TextStyle(color:  Colors.green),
	animationDuration:  Duration(milliseconds:  1000),
	autoDismiss:  true)
.show(context);

```

##  Contribution

Of course the project is open source, and you can contribute to it [repository link](https://github.com/koukibadr/Cherry-Toast)

- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.