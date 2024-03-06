import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final textTheme = Theme.of(navigatorKey.currentState!.context).textTheme;