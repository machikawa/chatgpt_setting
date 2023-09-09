import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPage extends StatefulWidget {
  final String initialValue;

  EditPage({required this.initialValue});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController _controller = TextEditingController();
  String _newValue = "";

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue;
  }

  void _saveNewValue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("settings1", _newValue);
    Navigator.pop(context, _newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("編集画面"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _controller,
              onChanged: (value) {
                setState(() {
                  _newValue = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveNewValue();
                if (_newValue.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("保存されました。"),
                    ),
                  );
                }
              },
              child: Text("保存"),
            ),
            SizedBox(height: 20),
            if (_newValue.isNotEmpty) Text("保存されました。"),
          ],
        ),
      ),
    );
  }
}
