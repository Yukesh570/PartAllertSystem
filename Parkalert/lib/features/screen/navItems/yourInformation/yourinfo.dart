import 'package:Parkalert/l10n/app_localizations.dart';
import 'package:Parkalert/navigationButton.dart';
import 'package:flutter/material.dart';

class Yourinfo extends StatefulWidget {
  const Yourinfo({super.key});

  @override
  State<Yourinfo> createState() => _YourinfoState();
}

class _YourinfoState extends State<Yourinfo> {
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);
    if (loc == null) {
      // This means localization isn't yet loaded or context is not in a localized widget tree
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(loc.yourInformation)),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(Icons.menu, color: dark ? Colors.white : Colors.black),
          ),
        ),
      ),
      drawer: const navButton(),
    );
  }
}
