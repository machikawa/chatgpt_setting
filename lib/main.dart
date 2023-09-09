import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.red), // メインのカラーをレッド系に設定
      home: SettingsPage(),
    );
  }
}

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

    // プロンプト：保存ボタンを押したら勝手に１画面に戻るんだけど、その制御をしているのはどこ？　で指示された箇所。
//    Navigator.pop(context, _newValue);
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
            //初期プロンプトで生成しちゃったコード。ここは誤り。
            // コメントアウトすると同時に、一つ上の ElavetedButtonを書き換えました。
            // ------- 以下のプロンプトで修正をさせました。 -----
            //if (_newValue.isNotEmpty) Text("保存されました。"),
            // ここは、入力ボックスに値が入った瞬間にTrueになる。Onpressedで出力されるようにできないか？
            // ------- 以下のプロンプトで修正をさせました。 -----
            SizedBox(height: 20),
            //if (_newValue.isNotEmpty) Text("保存されました。"),
          ],
        ),
      ),
    );
  }
}
