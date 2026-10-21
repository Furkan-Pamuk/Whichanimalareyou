import 'package:flutter/material.dart';

/// Global navigator key so flows launched from transient UI
/// (drawer, dialogs) always use a valid context.
final appNavigatorKey = GlobalKey<NavigatorState>();
