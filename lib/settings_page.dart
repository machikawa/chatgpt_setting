import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _settings1Value = "";

  @override
  void initState() {
    super.initState();
    _loadSettings1Value();
  }

  Future<void> _loadSettings1Value() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _settings1Value = prefs.getString("settings1") ?? "";
    });
  }

  void _navigateToEditPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditPage(initialValue: _settings1Value)),
    ).then((newValue) {
      if (newValue != null) {
        setState(() {
          _settings1Value = newValue;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("設定データ"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _settings1Value,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToEditPage,
              child: Text("編集"),
            ),
          ],
        ),
      ),
    );
  }
}
