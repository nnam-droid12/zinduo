import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';
import 'package:zinduo/quiz_screen.dart';
import 'FlagButton.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:appwrite/appwrite.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  final String name;

  const HomeScreen({Key? key, required this.name}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FlutterTts flutterTts = FlutterTts();
  GoogleTranslator translator = GoogleTranslator();
  String inputText = '';
  String documentId = const Uuid().v4();

  bool _loading = false;
  List<String> _translatedTexts = [];
  final List<String> _languagesCode = [
    'en',
    'ru',
    'fr',
    'zh-cn',
    'hi',
    'de',
    'it',
    'es',
    'ja',
    'ig'
  ];

  Client client = Client()
      .setEndpoint('https://cloud.appwrite.io/v1')
      .setProject('64899d39467825fdf608');

  Future<void> saveTranslation(String translatedText) async {
    try {
      const databaseId = '64899e8f6b358b757dd4';
      const collectionId = '64899ea6dda3d7dd42b0';

      Databases databases = Databases(client);
      await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
        data: {'text': translatedText},
      );

      // Show success message to the user
      Fluttertoast.showToast(msg: 'Translation saved successfully');
    } catch (e) {
      // Show error message to the user
      Fluttertoast.showToast(msg: 'Failed to save translation');
      // ignore: avoid_print
      print(e);
    }
  }

  Future translate() async {
    List<String> translatedTexts = [];
    setState(() {
      _loading = true;
    });
    for (String code in _languagesCode) {
      Translation translation = await translator.translate(inputText, to: code);
      String translatedText = translation.text;
      translatedTexts.add(translatedText);
    }
    setState(() {
      _translatedTexts = translatedTexts;
      _loading = false;
      // ignore: avoid_print
      print(_translatedTexts);
    });

    // Save the translated text to the Appwrite database
    if (_translatedTexts.isNotEmpty) {
      saveTranslation(_translatedTexts[0]);
    }
  }

  Future speak(String languageCode, String text) async {
    await flutterTts.setLanguage(languageCode);
    await flutterTts.setPitch(1);
    await flutterTts.setVolume(1);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zinduo'),
        backgroundColor: Colors.green,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QuizScreen()),
              );
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.green),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            child: const Text("Take Quiz", style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
      body: Column(
        children: [
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(25),
              hintText: 'Type in your preferred language...',
              hintStyle: const TextStyle(color: Colors.white),
              border: InputBorder.none,
              filled: true,
              fillColor: const Color(0xff263238),
              suffixIcon: _loading
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.green,
                      ),
                    )
                  : IconButton(
                      icon: const Icon(
                        Icons.translate,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (inputText.isNotEmpty) translate();
                      },
                    ),
            ),
            onChanged: (input) {
              inputText = input;
            },
          ),
          Expanded(
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              // physics: const BouncingScrollPhysics(
              //   parent: AlwaysScrollableScrollPhysics(),
              // ),
              children: [
                FlagButton(
                  text: _translatedTexts.isEmpty
                      ? 'English United States'
                      : _translatedTexts[0],
                  flag: 'united-states.png',
                  onTap: () {
                    if (_translatedTexts.isNotEmpty) {
                      speak('en-US', _translatedTexts[0]);
                      Fluttertoast.showToast(
                        msg: _translatedTexts.isNotEmpty
                            ? _translatedTexts[0]
                            : 'Translation not available',
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 30.0,
                        toastLength: Toast.LENGTH_LONG,
                      );
                    }
                  },
                ),
                FlagButton(
                  text: _translatedTexts.isEmpty
                      ? 'English United Kingdom'
                      : _translatedTexts[0],
                  flag: 'united-kingdom.png',
                  onTap: () {
                    if (_translatedTexts.isNotEmpty) {
                      speak('en-GB', _translatedTexts[0]);
                      Fluttertoast.showToast(
                        msg: _translatedTexts.isNotEmpty
                            ? _translatedTexts[0]
                            : 'Translation not available',
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 30.0,
                        toastLength: Toast.LENGTH_LONG,
                      );
                    }
                  },
                ),
                FlagButton(
                  text: _translatedTexts.isEmpty
                      ? 'Russian'
                      : _translatedTexts[1],
                  flag: 'russia.png',
                  onTap: () {
                    if (_translatedTexts.isNotEmpty) {
                      speak('ru-RU', _translatedTexts[1]);
                      Fluttertoast.showToast(
                        msg: _translatedTexts.isNotEmpty
                            ? _translatedTexts[1]
                            : 'Translation not available',
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 30.0,
                        toastLength: Toast.LENGTH_LONG,
                      );
                    }
                  },
                ),
                FlagButton(
                  text:
                      _translatedTexts.isEmpty ? 'French' : _translatedTexts[2],
                  flag: 'france.png',
                  onTap: () {
                    if (_translatedTexts.isNotEmpty) {
                      speak('fr-FR', _translatedTexts[2]);
                      Fluttertoast.showToast(
                        msg: _translatedTexts.isNotEmpty
                            ? _translatedTexts[2]
                            : 'Translation not available',
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0,
                        toastLength: Toast.LENGTH_LONG,
                      );
                    }
                  },
                ),
                FlagButton(
                  text: _translatedTexts.isEmpty
                      ? 'Chinese'
                      : _translatedTexts[3],
                  flag: 'china.png',
                  onTap: () {
                    if (_translatedTexts.isNotEmpty) {
                      speak('zh-CN', _translatedTexts[3]);
                      Fluttertoast.showToast(
                        msg: _translatedTexts.isNotEmpty
                            ? _translatedTexts[3]
                            : 'Translation not available',
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0,
                        toastLength: Toast.LENGTH_LONG,
                      );
                    }
                  },
                ),
                FlagButton(
                  text:
                      _translatedTexts.isEmpty ? 'Hindi' : _translatedTexts[4],
                  flag: 'india.png',
                  onTap: () {
                    if (_translatedTexts.isNotEmpty) {
                      speak('hi-IN', _translatedTexts[4]);
                      Fluttertoast.showToast(
                        msg: _translatedTexts.isNotEmpty
                            ? _translatedTexts[4]
                            : 'Translation not available',
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0,
                        toastLength: Toast.LENGTH_LONG,
                      );
                    }
                  },
                ),
                FlagButton(
                  text:
                      _translatedTexts.isEmpty ? 'German' : _translatedTexts[5],
                  flag: 'germany.png',
                  onTap: () {
                    if (_translatedTexts.isNotEmpty) {
                      speak('de-DE', _translatedTexts[5]);
                      Fluttertoast.showToast(
                        msg: _translatedTexts.isNotEmpty
                            ? _translatedTexts[5]
                            : 'Translation not available',
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0,
                        toastLength: Toast.LENGTH_LONG,
                      );
                    }
                  },
                ),
                FlagButton(
                  text: _translatedTexts.isEmpty
                      ? 'Italian'
                      : _translatedTexts[6],
                  flag: 'italy.png',
                  onTap: () {
                    if (_translatedTexts.isNotEmpty) {
                      speak('it-IT', _translatedTexts[6]);
                      Fluttertoast.showToast(
                        msg: _translatedTexts.isNotEmpty
                            ? _translatedTexts[6]
                            : 'Translation not available',
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0,
                        toastLength: Toast.LENGTH_LONG,
                      );
                    }
                  },
                ),
                FlagButton(
                  text: _translatedTexts.isEmpty
                      ? 'Spanish'
                      : _translatedTexts[7],
                  flag: 'spain.png',
                  onTap: () {
                    if (_translatedTexts.isNotEmpty) {
                      speak('es-ES', _translatedTexts[7]);
                      Fluttertoast.showToast(
                        msg: _translatedTexts.isNotEmpty
                            ? _translatedTexts[7]
                            : 'Translation not available',
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0,
                        toastLength: Toast.LENGTH_LONG,
                      );
                    }
                  },
                ),
                FlagButton(
                  text: _translatedTexts.isEmpty
                      ? 'Japanese'
                      : _translatedTexts[8],
                  flag: 'japan.png',
                  onTap: () {
                    if (_translatedTexts.isNotEmpty) {
                      speak('ja-JP', _translatedTexts[8]);
                      Fluttertoast.showToast(
                        msg: _translatedTexts.isNotEmpty
                            ? _translatedTexts[8]
                            : 'Translation not available',
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 30.0,
                        toastLength: Toast.LENGTH_LONG,
                      );
                    }
                  },
                ),
                FlagButton(
                  text: _translatedTexts.isEmpty
                      ? 'Igbo Amaka'
                      : _translatedTexts[9],
                  flag: 'igbo.png',
                  onTap: () {
                    if (_translatedTexts.isNotEmpty) {
                      speak('ig', _translatedTexts[9]);
                      Fluttertoast.showToast(
                        msg: _translatedTexts.isNotEmpty
                            ? _translatedTexts[9]
                            : 'Translation not available',
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 30.0,
                        toastLength: Toast.LENGTH_LONG,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Welcome, ${widget.name}!', // Display the name using widget.name
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
