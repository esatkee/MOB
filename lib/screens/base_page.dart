import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_drawer.dart';

class BasePage extends StatelessWidget {
  final String title;
  final Widget body;
  final DrawerMenu? drawer;

  const BasePage({
    super.key, 
    required this.title, 
    required this.body,
    this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: title),
      drawer: drawer ?? const DrawerMenu(),
      body: body,
    );
  }
} 