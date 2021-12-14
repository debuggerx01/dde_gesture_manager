import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const String PACKAGE_NAME = "cherry_toast";

const TextStyle DEFAULT_TITLTE_STYLE =
    const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
const TextStyle DEFAULT_DESCRIPTION_STYLE =
    const TextStyle(color: Colors.black);

const Duration DEFAULT_ANIMATION_DURATION = Duration(milliseconds: 1500);
const Duration DEFAULT_TOAST_DURATION = Duration(milliseconds: 3000);
const Cubic DEFAULT_ANIMATION_CURVE = Curves.ease;

const double CLOSE_BUTTON_SIZE = 15;

const double DEFAULT_ICON_SIZE = 20;
const double DEFAULT_ICON_LAYOUT_SIZE = 40;
const double DEFAULT_RADIUS = 20;
