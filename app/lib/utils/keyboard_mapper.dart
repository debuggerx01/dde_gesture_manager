import 'package:collection/collection.dart';

const KeysOrder = [
  'Ctrl',
  'Super',
  'Alt',
  'Shift',
  'Return',
  'Escape',
  'BackSpace',
  'Tab',
  'space',
  '→',
  '←',
  '↓',
  '↑',
  'Print',
  'ScrollLock',
  'Pause',
  'Insert',
  'Home',
  'Page_Up',
  'Delete',
  'End',
  'Page_Down',
  'F1',
  'F2',
  'F3',
  'F4',
  'F5',
  'F6',
  'F7',
  'F8',
  'F9',
  'F10',
  'F11',
  'F12',
  '-',
  '=',
  '(',
  ')',
  r'\',
  ';',
  "'",
  '`',
  ',',
  '.',
  '/',
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '0',
];

class KeyNames implements Comparable {
  final String displayName;
  final String realName;

  const KeyNames({required this.displayName, required this.realName});

  @override
  int compareTo(other) => KeysOrder.indexOf(this.displayName) - KeysOrder.indexOf(other.displayName);

  @override
  String toString() => realName;
}

KeyNames? getPhysicalKeyNames(int keyId) => _knownPhysicalKeyNames[keyId];

KeyNames? getPhysicalKeyNamesByRealName(String name) =>
    _knownPhysicalKeyNames.values.firstWhereOrNull((element) => element.realName == name);

/// https://www.w3.org/TR/uievents-code/
const Map<int, KeyNames> _knownPhysicalKeyNames = <int, KeyNames>{
  /// https://www.w3.org/TR/uievents-code/#key-legacy
  /*0x00000010: hyper,
  0x00000011: superKey,
  0x00000016: turbo,
  0x0007009b: abort,
  0x00000015: resume,
  0x00000014: suspend,
  0x00070079: again,
  0x0007007c: copy,
  0x0007007b: cut,
  0x0007007e: find,
  0x00070074: open,
  0x0007007d: paste,
  0x000700a3: props,
  0x00070077: select,
  0x0007007a: undo,*/

  /// Often handled in hardware so that events aren't generated for this key.
  /*0x00000012: fn,
  0x00000013: fnLock,*/

  /// W.T.F
  /*0x00000017: privacyScreenToggle,
  0x00010082: sleep,
  0x00010083: wakeUp,
  0x000100b5: displayToggleIntExt,
  0x0005ff01: gameButton1,
  0x0005ff02: gameButton2,
  0x0005ff03: gameButton3,
  0x0005ff04: gameButton4,
  0x0005ff05: gameButton5,
  0x0005ff06: gameButton6,
  0x0005ff07: gameButton7,
  0x0005ff08: gameButton8,
  0x0005ff09: gameButton9,
  0x0005ff0a: gameButton10,
  0x0005ff0b: gameButton11,
  0x0005ff0c: gameButton12,
  0x0005ff0d: gameButton13,
  0x0005ff0e: gameButton14,
  0x0005ff0f: gameButton15,
  0x0005ff10: gameButton16,
  0x0005ff11: gameButtonA,
  0x0005ff12: gameButtonB,
  0x0005ff13: gameButtonC,
  0x0005ff14: gameButtonLeft1,
  0x0005ff15: gameButtonLeft2,
  0x0005ff16: gameButtonMode,
  0x0005ff17: gameButtonRight1,
  0x0005ff18: gameButtonRight2,
  0x0005ff19: gameButtonSelect,
  0x0005ff1a: gameButtonStart,
  0x0005ff1b: gameButtonThumbLeft,
  0x0005ff1c: gameButtonThumbRight,
  0x0005ff1d: gameButtonX,
  0x0005ff1e: gameButtonY,
  0x0005ff1f: gameButtonZ,
  0x00070000: usbReserved,
  0x00070001: usbErrorRollOver,
  0x00070002: usbPostFail,
  0x00070003: usbErrorUndefined,*/

  0x00070004: const KeyNames(displayName: 'A', realName: 'a'),
  0x00070005: const KeyNames(displayName: 'B', realName: 'b'),
  0x00070006: const KeyNames(displayName: 'C', realName: 'c'),
  0x00070007: const KeyNames(displayName: 'D', realName: 'd'),
  0x00070008: const KeyNames(displayName: 'E', realName: 'e'),
  0x00070009: const KeyNames(displayName: 'F', realName: 'f'),
  0x0007000a: const KeyNames(displayName: 'G', realName: 'g'),
  0x0007000b: const KeyNames(displayName: 'H', realName: 'h'),
  0x0007000c: const KeyNames(displayName: 'I', realName: 'i'),
  0x0007000d: const KeyNames(displayName: 'J', realName: 'j'),
  0x0007000e: const KeyNames(displayName: 'K', realName: 'k'),
  0x0007000f: const KeyNames(displayName: 'L', realName: 'l'),
  0x00070010: const KeyNames(displayName: 'M', realName: 'm'),
  0x00070011: const KeyNames(displayName: 'N', realName: 'n'),
  0x00070012: const KeyNames(displayName: 'O', realName: 'o'),
  0x00070013: const KeyNames(displayName: 'P', realName: 'p'),
  0x00070014: const KeyNames(displayName: 'Q', realName: 'q'),
  0x00070015: const KeyNames(displayName: 'R', realName: 'r'),
  0x00070016: const KeyNames(displayName: 'S', realName: 's'),
  0x00070017: const KeyNames(displayName: 'T', realName: 't'),
  0x00070018: const KeyNames(displayName: 'U', realName: 'u'),
  0x00070019: const KeyNames(displayName: 'V', realName: 'v'),
  0x0007001a: const KeyNames(displayName: 'W', realName: 'w'),
  0x0007001b: const KeyNames(displayName: 'X', realName: 'x'),
  0x0007001c: const KeyNames(displayName: 'Y', realName: 'y'),
  0x0007001d: const KeyNames(displayName: 'Z', realName: 'z'),
  0x0007001e: const KeyNames(displayName: '1', realName: '1'),
  0x0007001f: const KeyNames(displayName: '2', realName: '2'),
  0x00070020: const KeyNames(displayName: '3', realName: '3'),
  0x00070021: const KeyNames(displayName: '4', realName: '4'),
  0x00070022: const KeyNames(displayName: '5', realName: '5'),
  0x00070023: const KeyNames(displayName: '6', realName: '6'),
  0x00070024: const KeyNames(displayName: '7', realName: '7'),
  0x00070025: const KeyNames(displayName: '8', realName: '8'),
  0x00070026: const KeyNames(displayName: '9', realName: '9'),
  0x00070027: const KeyNames(displayName: '0', realName: '0'),
  0x00070028: const KeyNames(displayName: 'Return', realName: 'Return'),
  0x00070029: const KeyNames(displayName: 'Escape', realName: 'Escape'),
  0x0007002a: const KeyNames(displayName: 'BackSpace', realName: 'BackSpace'),
  0x0007002b: const KeyNames(displayName: 'Tab', realName: 'Tab'),
  0x0007002c: const KeyNames(displayName: 'space', realName: 'space'),
  0x0007002d: const KeyNames(displayName: '-', realName: 'minus'),
  0x0007002e: const KeyNames(displayName: '=', realName: 'equal'),
  0x0007002f: const KeyNames(displayName: '(', realName: 'parenleft'),
  0x00070030: const KeyNames(displayName: ')', realName: 'parenright'),
  0x00070031: const KeyNames(displayName: r'\', realName: 'backslash'),
  0x00070033: const KeyNames(displayName: ';', realName: 'semicolon'),
  0x00070034: const KeyNames(displayName: "'", realName: 'apostrophe'),
  0x00070035: const KeyNames(displayName: '`', realName: 'grave'),
  0x00070036: const KeyNames(displayName: ',', realName: 'comma'),
  0x00070037: const KeyNames(displayName: '.', realName: 'period'),
  0x00070038: const KeyNames(displayName: '/', realName: 'slash'),
  0x00070039: const KeyNames(displayName: 'CapsLock', realName: 'Caps_Lock'),
  0x0007003a: const KeyNames(displayName: 'F1', realName: 'F1'),
  0x0007003b: const KeyNames(displayName: 'F2', realName: 'F2'),
  0x0007003c: const KeyNames(displayName: 'F3', realName: 'F3'),
  0x0007003d: const KeyNames(displayName: 'F4', realName: 'F4'),
  0x0007003e: const KeyNames(displayName: 'F5', realName: 'F5'),
  0x0007003f: const KeyNames(displayName: 'F6', realName: 'F6'),
  0x00070040: const KeyNames(displayName: 'F7', realName: 'F7'),
  0x00070041: const KeyNames(displayName: 'F8', realName: 'F8'),
  0x00070042: const KeyNames(displayName: 'F9', realName: 'F9'),
  0x00070043: const KeyNames(displayName: 'F10', realName: 'F10'),
  0x00070044: const KeyNames(displayName: 'F11', realName: 'F11'),
  0x00070045: const KeyNames(displayName: 'F12', realName: 'F12'),
  0x00070046: const KeyNames(displayName: 'Print', realName: 'Print'),
  0x00070047: const KeyNames(displayName: 'ScrollLock', realName: 'Scroll_Lock'),
  0x00070048: const KeyNames(displayName: 'Pause', realName: 'Pause'),
  0x00070049: const KeyNames(displayName: 'Insert', realName: 'Insert'),
  0x0007004a: const KeyNames(displayName: 'Home', realName: 'Home'),
  0x0007004b: const KeyNames(displayName: 'Page_Up', realName: 'Page_Up'),
  0x0007004c: const KeyNames(displayName: 'Delete', realName: 'Delete'),
  0x0007004d: const KeyNames(displayName: 'End', realName: 'End'),
  0x0007004e: const KeyNames(displayName: 'Page_Down', realName: 'Page_Down'),
  0x0007004f: const KeyNames(displayName: '→', realName: 'Right'),
  0x00070050: const KeyNames(displayName: '←', realName: 'Left'),
  0x00070051: const KeyNames(displayName: '↓', realName: 'Down'),
  0x00070052: const KeyNames(displayName: '↑', realName: 'Up'),
  0x00070053: const KeyNames(displayName: 'NumLock', realName: 'Num_Lock'),
  0x00070054: const KeyNames(displayName: 'KP_Divide', realName: 'KP_Divide'),
  0x00070055: const KeyNames(displayName: 'KP_Multiply', realName: 'KP_Multiply'),
  0x00070056: const KeyNames(displayName: 'KP_Subtract', realName: 'KP_Subtract'),
  0x00070057: const KeyNames(displayName: 'KP_Add', realName: 'KP_Add'),
  0x00070058: const KeyNames(displayName: 'KP_Enter', realName: 'KP_Enter'),
  0x00070059: const KeyNames(displayName: 'KP_1', realName: 'KP_1'),
  0x0007005a: const KeyNames(displayName: 'KP_2', realName: 'KP_2'),
  0x0007005b: const KeyNames(displayName: 'KP_3', realName: 'KP_3'),
  0x0007005c: const KeyNames(displayName: 'KP_4', realName: 'KP_4'),
  0x0007005d: const KeyNames(displayName: 'KP_5', realName: 'KP_5'),
  0x0007005e: const KeyNames(displayName: 'KP_6', realName: 'KP_6'),
  0x0007005f: const KeyNames(displayName: 'KP_7', realName: 'KP_7'),
  0x00070060: const KeyNames(displayName: 'KP_8', realName: 'KP_8'),
  0x00070061: const KeyNames(displayName: 'KP_9', realName: 'KP_9'),
  0x00070062: const KeyNames(displayName: 'KP_0', realName: 'KP_0'),
  0x00070063: const KeyNames(displayName: '.', realName: 'KP_Decimal'),

  /// IntlBackslash ???
  0x00070064: const KeyNames(displayName: r'\', realName: 'backslash'),
  0x00070065: const KeyNames(displayName: 'Menu', realName: 'Menu'),

  /// Mac only
  // 0x00070066: power,
  0x00070067: const KeyNames(displayName: 'KP_Equal', realName: 'KP_Equal'),
  0x00070068: const KeyNames(displayName: 'F13', realName: 'F13'),
  0x00070069: const KeyNames(displayName: 'F14', realName: 'F14'),
  0x0007006a: const KeyNames(displayName: 'F15', realName: 'F15'),
  0x0007006b: const KeyNames(displayName: 'F16', realName: 'F16'),
  0x0007006c: const KeyNames(displayName: 'F17', realName: 'F17'),
  0x0007006d: const KeyNames(displayName: 'F18', realName: 'F18'),
  0x0007006e: const KeyNames(displayName: 'F19', realName: 'F19'),
  0x0007006f: const KeyNames(displayName: 'F20', realName: 'F20'),
  0x00070070: const KeyNames(displayName: 'F21', realName: 'F21'),
  0x00070071: const KeyNames(displayName: 'F22', realName: 'F22'),
  0x00070072: const KeyNames(displayName: 'F23', realName: 'F23'),
  0x00070073: const KeyNames(displayName: 'F24', realName: 'F24'),

  /// Not present on standard PC keyboards.
  // 0x00070075: help,
  0x0007007f: const KeyNames(displayName: 'XF86AudioMute', realName: 'XF86AudioMute'),
  0x00070080: const KeyNames(displayName: 'XF86AudioRaiseVolume', realName: 'XF86AudioRaiseVolume'),
  0x00070081: const KeyNames(displayName: 'XF86AudioLowerVolume', realName: 'XF86AudioLowerVolume'),
  0x00070085: const KeyNames(displayName: 'KP_Separator', realName: 'KP_Separator'),
  0x00070087: const KeyNames(displayName: 'KanaRo', realName: 'kana_RO'),
  0x00070088: const KeyNames(displayName: 'Hiragana_Katakana', realName: 'Hiragana_Katakana'),
  0x00070089: const KeyNames(displayName: 'yen', realName: 'yen'),
  0x0007008a: const KeyNames(displayName: 'Henkan_Mode', realName: 'Henkan_Mode'),
  0x0007008b: const KeyNames(displayName: 'Muhenkan', realName: 'Muhenkan'),
  0x00070090: const KeyNames(displayName: 'Hangul', realName: 'Hangul'),
  0x00070091: const KeyNames(displayName: 'Hangul_Hanja', realName: 'Hangul_Hanja'),
  0x00070092: const KeyNames(displayName: 'Katakana', realName: 'Katakana'),
  0x00070093: const KeyNames(displayName: 'Hiragana', realName: 'Hiragana'),
  0x00070094: const KeyNames(displayName: 'Zenkaku', realName: 'Zenkaku'),
  0x000700b6: const KeyNames(displayName: 'KP_Left', realName: 'KP_Left'),
  0x000700b7: const KeyNames(displayName: 'KP_Right', realName: 'KP_Right'),

  /// Found on the Microsoft Natural Keyboard.
  // 0x000700bb: numpadBackspace,

  /// W.T.F ???
  /*0x000700d0: numpadMemoryStore,
  0x000700d1: numpadMemoryRecall,
  0x000700d2: numpadMemoryClear,
  0x000700d3: numpadMemoryAdd,
  0x000700d4: numpadMemorySubtract,
  0x000700d7: numpadSignChange,
  0x000700d9: numpadClearEntry,*/
  0x000700d8: const KeyNames(displayName: 'NumLock', realName: 'Num_Lock'),
  0x000700e0: const KeyNames(displayName: 'Ctrl', realName: 'Control_L'),
  0x000700e1: const KeyNames(displayName: 'Shift', realName: 'Shift_L'),
  0x000700e2: const KeyNames(displayName: 'Alt', realName: 'Alt_L'),
  0x000700e3: const KeyNames(displayName: 'Super', realName: 'Super_L'),
  0x000700e4: const KeyNames(displayName: 'Ctrl', realName: 'Control_R'),
  0x000700e5: const KeyNames(displayName: 'Shift', realName: 'Shift_R'),
  0x000700e6: const KeyNames(displayName: 'Alt', realName: 'Alt_R'),
  0x000700e7: const KeyNames(displayName: 'Super', realName: 'Super_R'),

  /// Toggles the display of information about the currently selected content, program, or media.
  // 0x000c0060: info,

  /// Toggles closed captioning on and off.
  // 0x000c0061: closedCaptionToggle,

  /// Too dangerous ...
  /*0x000c006f: brightnessUp,
  0x000c0070: brightnessDown,
  0x000c0072: brightnessToggle,
  0x000c0073: brightnessMinimum,
  0x000c0074: brightnessMaximum,
  0x000c0075: brightnessAuto,*/

  /// seems only works on mobile.
  /*0x000c0079: kbdIllumUp,
  0x000c007a: kbdIllumDown,
  0x000c0083: mediaLast,
  0x000c008c: launchPhone,
  0x000c008d: programGuide,
  0x000c0094: exit,
  0x000c009c: channelUp,
  0x000c009d: channelDown,
  0x000c00b0: mediaPlay,
  0x000c00b1: mediaPause,
  0x000c00b2: mediaRecord,
  0x000c00b3: mediaFastForward,
  0x000c00b4: mediaRewind,
  0x000c00b5: mediaTrackNext,
  0x000c00b6: mediaTrackPrevious,
  0x000c00b7: mediaStop,

  /// Mac only
  // 0x000c00b8: eject,
  0x000c00cd: mediaPlayPause,
  0x000c00cf: speechInputToggle,
  0x000c00e5: bassBoost,
  0x000c0183: mediaSelect,*/
  0x000c0184: const KeyNames(displayName: 'XF86Word', realName: 'XF86Word'),
  0x000c0186: const KeyNames(displayName: 'XF86Excel', realName: 'XF86Excel'),
  0x000c018a: const KeyNames(displayName: 'XF86Mail', realName: 'XF86Mail'),

  /// not implements on linux.
  // 0x000c018d: launchContacts,
  0x000c018e: const KeyNames(displayName: 'XF86Calendar', realName: 'XF86Calendar'),
  0x000c0192: const KeyNames(displayName: 'XF86Launch2', realName: 'XF86Launch2'),
  0x000c0194: const KeyNames(displayName: 'XF86Launch1', realName: 'XF86Launch1'),

  /// I don't think need implement those keys
  /*0x000c0196: launchInternetBrowser,
  0x000c019c: logOff,
  0x000c019e: lockScreen,
  0x000c019f: launchControlPanel,
  0x000c01a2: selectTask,
  0x000c01a7: launchDocuments,
  0x000c01ab: spellCheck,
  0x000c01ae: launchKeyboardLayout,
  0x000c01b1: launchScreenSaver,
  0x000c01b7: launchAudioBrowser,
  0x000c01cb: launchAssistant,
  0x000c0201: newKey,
  0x000c0203: close,
  0x000c0207: save,
  0x000c0208: print,
  0x000c0221: browserSearch,
  0x000c0223: browserHome,
  0x000c0224: browserBack,
  0x000c0225: browserForward,
  0x000c0226: browserStop,
  0x000c0227: browserRefresh,
  0x000c022a: browserFavorites,
  0x000c022d: zoomIn,
  0x000c022e: zoomOut,
  0x000c0232: zoomToggle,
  0x000c0279: redo,
  0x000c0289: mailReply,
  0x000c028b: mailForward,
  0x000c028c: mailSend,
  0x000c029d: keyboardLayoutSelect,
  0x000c029f: showAllWindows,*/
};
