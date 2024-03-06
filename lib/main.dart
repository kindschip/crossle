// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, non_constant_identifier_names, library_private_types_in_public_api

import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';
import 'dart:developer' as developer;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:soundpool/soundpool.dart';
import 'package:audio_session/audio_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  if (!kIsWeb && !Platform.isMacOS) {
    WidgetsFlutterBinding.ensureInitialized();
    MobileAds.instance.initialize();
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: ['bc10adaa4f57b5eeb8ee884eacc0ffd4']),
    );
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ButtonGrid()),
        ChangeNotifierProvider(create: (context) => MyAppState()),
        ChangeNotifierProvider(create: (context) => MyHomePageState()),
        ChangeNotifierProvider(create: (context) => RadioButtonNotifier()),
        ChangeNotifierProvider(create: (context) => HighScoreNotifier()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey, // Set the global key
        home: LifecycleManager(
          key: lifecycleManagerKey,
          child: MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Crossle',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(key: myKey),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var history = <WordPair>[];

  GlobalKey? historyListKey;

  void getNext() {
    history.insert(0, current);
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite([WordPair? pair]) {
    pair = pair ?? current;
    if (favorites.contains(pair)) {
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    }
    notifyListeners();
  }

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }
}

InterstitialAd? myInterstitial;

int loadAttempts = 0;

void updateInterstitialAd() {
  if (kIsWeb || Platform.isMacOS) {
    return;
  }

  if (myInterstitial != null) {
    myInterstitial!.show();
  }
  InterstitialAd.load(
    adUnitId: (Platform.isIOS)
        ? 'ca-app-pub-8875711544323026/7397332572'
        : 'ca-app-pub-8875711544323026/5970708442',
    request: AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (InterstitialAd ad) {
        // Keep a reference to the ad so you can show it later.
        myInterstitial = ad;
        loadAttempts = 0; // reset load attempts
      },
      onAdFailedToLoad: (LoadAdError error) {
        print('Ad failed to load: $error');
        loadAttempts++;
        if (loadAttempts <= 6) {
          updateInterstitialAd(); // retry loading ad
        }
      },
    ),
  );
}

class MyHomePageState extends ChangeNotifier {
  var _definition = 'initial definition';
  var _score = 0;

  String get definition => _definition;
  int get score => _score;

  void setScore(int value) {
    _score = value;
    notifyListeners();
  }

  var _selectedIndex = 1;

  int get selectedIndex2 => _selectedIndex;

  void setSelectedState(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void updateDefinition() {
    var context = navigatorKey.currentState!.context;
    if (Provider.of<ButtonGrid>(context, listen: false)
            .icon[anchor.x][anchor.y]
            .icon ==
        Icons.arrow_forward) {
      _definition = letters[anchor.x][anchor.y].getDefA();
    } else {
      _definition = letters[anchor.x][anchor.y].getDefD();
    }

    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required Key key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final GlobalKey<_MyHomePageState> myKey = GlobalKey();
bool soundOn = true;
SharedPreferences? prefs;

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 1;
  //List<int> highScoresInDrawer = highScores; // Sample high scores
  void resetHighScores() {
    setState(() {
      highScores = [0, 0, 0, 0, 0];
      //highScoresInDrawer = highScores;
    });
  }

  void setSelectedIndex(int value) {
    setState(() {
      selectedIndex = value;
    });
  }

  @override
  initState() {
    super.initState();
    //highScoresInDrawer = highScores;
    loadFrequencyFile();
  }

  @override
  Widget build(BuildContext context) {
    //var colorScheme = Theme.of(context).colorScheme;

    //MyHomePage(key: myKey);

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
      case 1:
        page = SplashScreen();
      case 2:
        page = HighScorePage();
      case 3:
        page = InstructionsPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // The container for the current page, with its background color
    // and subtle switching animation.
    var mainArea = ColoredBox(
      color: Colors.white,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );
    //var appState = context.watch<MyAppState>();
    //var pair = appState.current;
    var definition2 = context.watch<MyHomePageState>().definition;
    var score = context.watch<MyHomePageState>().score;
    return Scaffold(
      appBar: (selectedIndex == 0 || selectedIndex == 2)
          ? AppBar(
              //automaticallyImplyLeading: false, // Add this line
              title: Column(
                children: [
                  Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Center(
                        child: Text(
                          score.toString(),
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            //BigCard(pair: pair),
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                child: Image.asset('assets/crossleLogo.png'),
              ),
            ),
            SoundSwitch(),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                padding:
                    MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              onPressed: () {
                done = false;
                newPuzzle();
                
                Navigator.pop(context);
              },
              child: Text('Play Again', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                padding:
                    MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              onPressed: () {
                //var context = navigatorKey.currentState!.context;
                showSolution();
                Navigator.pop(context);
              },
              child: Text('Auto Solve Puzzle',
                  style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                padding:
                    MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              onPressed: () {
                myKey.currentState?.setSelectedIndex(3);
                Navigator.pop(context);
              },
              child:
                  Text('Instructions', style: TextStyle(color: Colors.white)),
            ),
            RadioButtonWidget(),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Image.asset('assets/crossleLogo.png'),
                  ),
                  ListTile(
                    title: Center(
                      child: Text(
                        'Score = ${Provider.of<MyHomePageState>(context, listen: false).score}',
                      ),
                    ),
                  ),
                  ListTile(
                    title: Center(
                      child: Text(
                        'High Scores',
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Center(
                      child: Text(
                        'Easy : ${highScores[0]}',
                      ),
                    ),
                  ),
                  ListTile(
                    title: Center(
                      child: Text(
                        'Medium : ${highScores[1]}',
                      ),
                    ),
                  ),
                  ListTile(
                    title: Center(
                      child: Text(
                        'Hard : ${highScores[2]}',
                      ),
                    ),
                  ),
                  ListTile(
                    title: Center(
                      child: Text(
                        'Challenging : ${highScores[3]}',
                      ),
                    ),
                  ),
                  ListTile(
                    title: Center(
                      child: Text(
                        'Impossible  : ${highScores[4]}',
                      ),
                    ),
                  ),
                  ListTile(
                    title: Center(
                      child: Text(
                        '                         ',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    highScores = [
                      0,
                      0,
                      0,
                      0,
                      0
                    ]; // Add your reset highscores logic here
                    lifecycleManagerKey.currentState
                        ?.updateVariable(highScores);
                    resetHighScores();
                  },
                  child: Text('Reset Highscores'),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: (selectedIndex == 0)
            ? [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Center(
                        child: Text(
                          definition2,
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                  ),
                ),
                //Expanded(child: AdWidget(ad: myBanner)),
                Expanded(flex: 20, child: mainArea),
              ]
            : [
                Expanded(child: mainArea),
              ],
      ),
    );
  }
}

class SoundSwitch extends StatefulWidget {
  @override
  _SoundSwitchState createState() => _SoundSwitchState();
}

class _SoundSwitchState extends State<SoundSwitch> {
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text('Sound'),
      value: soundOn, // use the global soundOn variable
      onChanged: (bool value) {
        setState(() {
          soundOn = value; // update the global soundOn variable
        });
        if (soundOn) {
          // Call your function to turn sound on
        } else {
          // Call your function to turn sound off
        }
      },
      secondary: const Icon(Icons.volume_up),
    );
  }
}

class RadioButtonNotifier extends ChangeNotifier {
  int _selectedRadio = 0;

  int get selectedRadio => _selectedRadio;

  void setSelectedRadio(int? value) {
    _selectedRadio = value ?? 0;
    notifyListeners();
  }
}

class RadioButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RadioButtonNotifier>(
      builder: (context, notifier, child) {
        return Column(
          children: <Widget>[
            RadioListTile(
              title: Text('Easy'),
              value: 0,
              groupValue: notifier.selectedRadio,
              onChanged: (val) {
                difficulty = 1000000;
                //loadDataFile();
                notifier.setSelectedRadio(val);
                //Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: Text('Medium'),
              value: 1,
              groupValue: notifier.selectedRadio,
              onChanged: (val) {
                difficulty = 500000;
                //loadDataFile();
                notifier.setSelectedRadio(val);
                //Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: Text('Hard'),
              value: 2,
              groupValue: notifier.selectedRadio,
              onChanged: (val) {
                difficulty = 250000;
                //loadDataFile();
                notifier.setSelectedRadio(val);
                //Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: Text('Challenging'),
              value: 3,
              groupValue: notifier.selectedRadio,
              onChanged: (val) {
                difficulty = 125000;
                //loadDataFile();
                notifier.setSelectedRadio(val);
                //Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: Text('Impossible'),
              value: 4,
              groupValue: notifier.selectedRadio,
              onChanged: (val) {
                difficulty = 0;
                //loadDataFile();
                notifier.setSelectedRadio(val);
                //Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();
    //var pair = appState.current;

    // IconData icon;
    // if (appState.favorites.contains(pair)) {
    //   icon = Icons.favorite;
    // } else {
    //   icon = Icons.favorite_border;
    // }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: ButtonGridWidget5x5(),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: AspectRatio(
              aspectRatio: 1.4,
              child: Keyboard7(),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

List<Object> keyboardKey7 = [
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
  Icons.arrow_upward,
  'K',
  'L',
  'M',
  'N',
  'O',
  Icons.arrow_back,
  Icons.refresh,
  Icons.arrow_forward,
  'P',
  'Q',
  'R',
  'S',
  'T',
  Icons.arrow_downward,
  'U',
  'V',
  'W',
  "Show Menu",
  'Free Letter',
  'X',
  'Y',
  'Z',
  'Play Again',
  'Show Puzzle'
];

Color color = Colors.red;
List<Color> colors = [
  color, //0
  color, //1
  color, //2
  color, //3
  color, //4
  color, //5
  color, //6
  color, //7
  color, //8
  color, //9
  Colors.white, //10
  color, //11
  color, //12
  color, //13
  color, //14
  color, //15
  Colors.white, //16
  Colors.black, //17
  Colors.white, //18
  color, //19
  color, //20
  color, //21
  color, //22
  color, //23
  Colors.white, //24
  color, //25
  color, //26
  color, //27
  Colors.blue, //28
  Colors.blue, //29
  color, //30
  color, //31
  color, //32
  Colors.blue, //33
  Colors.blue //34
];

Icon forwardIcon = Icon(
  Icons.arrow_forward,
  color: Colors.white,
);
Icon downIcon = Icon(
  Icons.arrow_downward,
  color: Colors.white,
);

class KeyBoardTexts extends ChangeNotifier {
  List<List<String>> _texts =
      List.generate(5, (i) => List.generate(7, (j) => 'Button $i,$j'));

  List<List<String>> get texts => _texts;

  void updateText(int i, int j, String newText) {
    _texts[i][j] = newText;
    notifyListeners();
  }
}

class Keyboard7 extends StatelessWidget {
  const Keyboard7({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 7,
      children: List.generate(35, (index) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colors[index],
            padding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.white,
                width: 5,
              ),
              borderRadius: BorderRadius.zero,
            ),
          ),
          onPressed: () {
            if (index == 34) {
              showSolution();
              return;
            }
            if (index == 28) {
              Scaffold.of(context).openDrawer();
              return;
            }
            if (index == 29) {
              Provider.of<ButtonGrid>(context, listen: false).setButtonText(
                  anchor.x, anchor.y, letters[anchor.x][anchor.y].getTag());
              forward(anchor.AorD);
              if (soundOn) {
                playSound('assets/soundBell.mp3');
              }
              return;
            }
            if (index == 33) {
              updateInterstitialAd();
              newPuzzle();
              return;
            }
            if (index == 16) {
              left();
              return;
            }
            if (index == 18) {
              right();
              return;
            }
            if (index == 10) {
              up();
              return;
            }
            if (index == 24) {
              //myWidgetKey.currentState?.down();
              down();
              return;
            }
            if (index == 17) {
              if (Provider.of<ButtonGrid>(context, listen: false)
                      .icon[anchor.x][anchor.y]
                      .icon ==
                  Icons.arrow_forward) {
                anchor.AorD = "D";
                Provider.of<ButtonGrid>(context, listen: false)
                    .setIcon(anchor.x, anchor.y, downIcon);
                updateDef();
              } else {
                anchor.AorD = "A";
                Provider.of<ButtonGrid>(context, listen: false)
                    .setIcon(anchor.x, anchor.y, forwardIcon);
                updateDef();
              }
              return;
            }
            if (keyboardKey7[index] == letters[anchor.x][anchor.y].getTag()) {
              Provider.of<ButtonGrid>(context, listen: false).setButtonText(
                  anchor.x, anchor.y, letters[anchor.x][anchor.y].getTag());
              if (Provider.of<ButtonGrid>(context, listen: false)
                      .icons[anchor.x][anchor.y]
                      .icon ==
                  Icons.arrow_forward) {
                forward("A");
              } else {
                forward("D");
              }
              //showMessage(navigatorKey.currentState!.context, "Correct!", 500);
              if (soundOn) {
                playSound('assets/soundBell.mp3');
              }
              Provider.of<MyHomePageState>(context, listen: false).setScore(
                  Provider.of<MyHomePageState>(context, listen: false).score +
                      4);
              updateHighScores(Provider.of<MyHomePageState>(context, listen: false).score);
              return;
            }
            //showMessage(navigatorKey.currentState!.context, "Wrong!", 500);
            Provider.of<MyHomePageState>(context, listen: false).setScore(
                Provider.of<MyHomePageState>(context, listen: false).score - 1);
            if (soundOn) {
              playSound('assets/soundBuzzer.mp3');
            }
          },
          child: (keyboardKey7[index] is String)
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText(
                    keyboardKey7[index] as String,
                    style: TextStyle(
                      fontSize: 400,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    minFontSize: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              : SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Icon(
                      keyboardKey7[index] as IconData,
                      color: (index == 17) ? Colors.white : Colors.black,
                    ),
                  ),
                ),
        );
      }),
    );
  }
}

void showSolution() {
  var context = navigatorKey.currentState!.context;
  for (int i = 0; i < 5; i++) {
    for (int j = 0; j < 5; j++) {
      Provider.of<ButtonGrid>(context, listen: false)
          .setButtonText(i, j, letters[i][j].getTag());
    }
  }
}

void newPuzzle() {
  loadDataFile();
  //start4();
}

Soundpool pool = Soundpool.fromOptions(
  options: SoundpoolOptions(streamType: StreamType.music, maxStreams: 5),
);

Future<void> playSound(String file) async {
  final session = await AudioSession.instance;
  await session.configure(AudioSessionConfiguration.speech());

  // Load a sound
  int soundId = await rootBundle.load(file).then((ByteData soundData) {
    return pool.load(soundData);
  });

  // Listen for audio session changes
  session.interruptionEventStream.listen((event) {
    if (event.begin) {
      pool.pause(soundId); // Pause your audio here
    } else {
      pool.resume(soundId); // Resume your audio here
    }
  });

  session.becomingNoisyEventStream.listen((_) {
    pool.pause(soundId); // Pause your audio here
  });

  await pool.play(soundId);
}

// Call this function when you're done with the sound
Future<void> releaseSound() async {
  await pool.release();
}

class ButtonGrid with ChangeNotifier {
  List<List<String>> _buttonText = List.generate(5, (i) => List.filled(5, ''));

  List<List<String>> get buttonText => _buttonText;

  void setButtonText(int i, int j, String text) {
    _buttonText[i][j] = text;
    notifyListeners();
  }

  void doNothing() {
    notifyListeners();
  }

  List<List<Icon>> icons = List.generate(
    5,
    (i) => List.generate(
      5,
      (j) => Icon(
        Icons.star,
        color: Colors.black,
      ),
    ),
  );

  List<List<Icon>> get icon => icons;

  void setIcon(int i, int j, Icon icon) {
    icons[i][j] = icon;
    notifyListeners();
  }
}

class ButtonGridWidget5x5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ButtonGrid>(
      builder: (context, buttonGrid, child) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 0.0,
            mainAxisSpacing: 0.0,
          ),
          itemCount: 25,
          itemBuilder: (context, index) {
            int i = index % 5;
            int j = index ~/ 5;
            Icon currentIcon =
                Provider.of<ButtonGrid>(context, listen: false).icon[i][j];
            return TextButton(
              style: TextButton.styleFrom(
                backgroundColor: (currentIcon.icon == Icons.arrow_forward ||
                        currentIcon.icon == Icons.arrow_downward)
                    ? Colors.black
                    : Colors.blue,
                //side: BorderSide.none,
                padding: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.white,
                    width: 5,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              onPressed: () {
                Icon arrowOrNot = Provider.of<ButtonGrid>(context, listen: false)
                        .icon[i][j];
                if (arrowOrNot == forwardIcon){
                  Provider.of<ButtonGrid>(context, listen: false)
                    .setIcon(i,j, downIcon);
                    updateDef();
                    return;
                }
                if (arrowOrNot == downIcon){
                  Provider.of<ButtonGrid>(context, listen: false)
                    .setIcon(i,j, forwardIcon);
                    updateDef();
                    return;
                }
                Icon currentIcon =
                    Provider.of<ButtonGrid>(context, listen: false)
                        .icon[anchor.x][anchor.y];
                Provider.of<ButtonGrid>(context, listen: false)
                    .setIcon(anchor.x, anchor.y, Icon(Icons.star));
                anchor.x = i;
                anchor.y = j;
                Provider.of<ButtonGrid>(context, listen: false)
                    .setIcon(anchor.x, anchor.y, currentIcon);
                updateDef();
              },
              child: (currentIcon.icon == Icons.star)
                  ? Consumer<ButtonGrid>(
                      builder: (context, buttonGrid, child) => AutoSizeText(
                        buttonGrid.buttonText[i][j],
                        style: TextStyle(
                          fontSize: 400,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        minFontSize: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : SizedBox.expand(
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Consumer<ButtonGrid>(
                            builder: (context, iconState, child) =>
                                iconState.icon[i][j]),
                      ),
                    ),
            );
          },
        );
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Image.asset('assets/crossleLogo.png'),
        ),
      ],
    );
  }
}

class InstructionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyInstructionsScrollView();
  }
}

class MyInstructionsScrollView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 70.0),
          ),
          Flexible(
            flex: 9,
            child: SingleChildScrollView(
              // ignore: sized_box_for_whitespace
              child: Container(
                height: screenHeight * 2,
                child: AutoSizeText(
                  'Welcome to Crossle.  This is a 5 by 5 crossword puzzle generator.  It generates new puzzles on the fly from a database of over 23,000 five letter words.  Some of the words are very rare, so I have implemented different difficulty levels into the app.  Easy, Medium, Hard, Challenging, and Impossible.  The app is set to Easy by default.  You can adjust the difficulty according to your desire.  You can navigate around the grid with the arrows in the middle of the keyboard or by pressing a square on the board.   The app starts with a pointer icon in the upper left of the board.  This pointer icon can be rotated to an across arrow or a down arrow.  Toggling this arrow also updates the corresponding puzzle clue at the top of the screen to the clue going across or down.  The grid has 5 rows and 5 columns making up a total of 10 words all intertwined to make the complete grid.  There is also a menu that can be pulled out by swiping from the left of the screen or by pushing the menu button at the bottom of the keyboard.  In this menu you can turn the sound on or off, start a new puzzle, show the highscores, or change the difficulty of the puzzle.  If you get stuck and cannot proceed there is also a free letter button at the bottom of the keyboard.  You will not get any points for a free letter, but it can come in handy if you\'re at a standstill in solving the puzzle.  Points are added to your score for every correct letter.  Correct letters give you 4 points.  And incorrect guesses deduct a point from your score.  So, since there are 25 letters in each puzzle, 25 times 4 points would give you a perfect score of 100. After solving each puzzle there is an ad displayed on the screen.  If you want, you can visit the app\'s sponsor websites. I thoroughly enjoyed creating this app and I hope you enjoy playing it.  Happy puzzling!',
                  style: TextStyle(fontSize: 60),
                  minFontSize: 10, // optional
                  //maxLines: screenHeight.toInt(), // optional
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: () {
                myKey.currentState?.setSelectedIndex(0);
                //Navigator.pop(context);
              },
              child: Text('Back to the Game'),
            ),
          ),
        ],
      ),
    );
  }
}

class HighScoreNotifier extends ChangeNotifier {
  List<List<String>> _items =
      List.generate(3, (i) => List.generate(6, (j) => 'Item ${i * 6 + j + 1}'));

  String getItem(int i, int j) => _items[i][j];

  void setItem(int i, int j, String value) {
    _items[i][j] = value;
    notifyListeners();
  }
}

class HighScorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            //flex: 3,
            fit: FlexFit.tight,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Text('High Scores'),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: AspectRatio(
              aspectRatio: 1.4,
              child: Text("Page"),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

void start4() {
  var context = navigatorKey.currentState!.context;
  Provider.of<MyHomePageState>(context, listen: false).setScore(0);

  anchor = XandY(0, 0, "A");
  for (int x = 0; x < numX; x++) {
    for (int y = 0; y < numY; y++) {
      letters[x][y] = Letter('wild');
    }
  }

  int x = 0;
  int y = 0;
  findLetter(x, y);

  if (repeatsExist()) {
    done = false;
    start4();
  }
  displayGrid();

  for (int i = 0; i < 5; i++) {
    for (int j = 0; j < 5; j++) {
      Provider.of<ButtonGrid>(context, listen: false).setButtonText(i, j, "");
      Provider.of<ButtonGrid>(context, listen: false)
          .setIcon(i, j, Icon(Icons.star));
    }
  }
  Provider.of<ButtonGrid>(context, listen: false).setIcon(0, 0, forwardIcon);
  initDefinitions();
  updateDef();
}

void updateDef() {
  var appState = navigatorKey.currentState!.context.read<MyHomePageState>();
  appState.updateDefinition();
}

bool repeatsExist() {
  List<String> temp = [];
  for (int i = 0; i < 5; i++) {
    temp.add(getDown(i));
    temp.add(getAcross(i));
  }
  return findDuplicates(temp);
}

bool findDuplicates(List<String> listContainingDuplicates) {
  final Set<String> set1 = {};

  for (String yourCard in listContainingDuplicates) {
    if (!set1.add(yourCard)) {
      return true;
    }
  }
  return false;
}

List<String> words = [];
List<List<String>> definitions = [];
int difficulty = 1000000;

Future<void> loadDataFile() async {
  //myInterstitial = null;
  myKey.currentState?.setSelectedIndex(1);
  words = [];
  definitions = [];
  List<String> lines = [];
  String fileContent =
      await rootBundle.loadString('assets/crosswordMaster.txt');

  lines = LineSplitter.split(fileContent).toList();

  //lines.sort();
  for (var line in lines) {
    var temp = line.split(' @@@@ ');
    // List<String> row = freqWords.firstWhere((row) => row[0] == temp[0].trim(),
    //     orElse: () => []);
    int index = binarySearch(freqWords, temp[0]);
    if (index == -1) {
      continue;
    }
    List<String> row = freqWords[index];
    if (row.isNotEmpty && int.parse(row[1]) > difficulty) {
      words.add(temp[0]);
      List<String> defs = [];
      for (int j = 1; j < temp.length; j++) {
        defs.add(temp[j]);
      }
      definitions.add(defs);
    }
  }

  print('size = ${words.length}');
  // for (var word in words) {
  //   print(word);
  // }
  // for (var def in definitions) {
  //     print(def);
  // }
  setUpLetterPick();
  generateNodes(words);
  if (!kIsWeb && !Platform.isMacOS) {
    updateInterstitialAd();
  }
  //updateInterstialAd();

  start4();
  // var appState = navigatorKey.currentState!.context.watch<MyHomePageState>();
  // appState.setSelectedState(0);
  Future.delayed(Duration(milliseconds: 4000), () {
    myKey.currentState?.setSelectedIndex(0);
  });

  // Provider.of<MyHomePageState>(navigatorKey.currentState!.context,
  //         listen: false)
  //     .setSelectedState(0);
}

int binarySearch(List<List<String>> array, String target) {
  int low = 0;
  int high = array.length - 1;

  while (low <= high) {
    int mid = low + ((high - low) >> 1);
    String midValue = array[mid][0];

    if (midValue == target) {
      return mid;
    } else if (midValue.compareTo(target) < 0) {
      low = mid + 1;
    } else {
      high = mid - 1;
    }
  }

  return -1; // Return -1 if the target is not found
}

List<List<String>> freqWords = [];

Future<void> loadFrequencyFile() async {
  List<String> lines = [];
  String fileContent = await rootBundle.loadString('assets/frequencyList2.txt');
  lines = LineSplitter.split(fileContent).toList();

  //lines.sort();
  for (var line in lines) {
    var temp = line.split(',');
    temp[0] = temp[0].toUpperCase().trim();
    if (temp[0].length == 5) {
      freqWords.add(temp);
    }
  }

  //freqWords.sort((a, b) => a[0].compareTo(b[0]));

  loadDataFile();
}

XandY anchor = XandY(0, 0, "A");

void right() {
  var context = navigatorKey.currentState!.context;
  currentX = anchor.x;
  currentY = anchor.y;
  if (anchor.AorD == "A") {
    forward2("A");
    String currentText = Provider.of<ButtonGrid>(context, listen: false)
        .buttonText[anchor.x][anchor.y];
    while (currentText != "" && !solved()) {
      forward2("A");
      currentText = Provider.of<ButtonGrid>(context, listen: false)
          .buttonText[anchor.x][anchor.y];
    }
  } else {
    forward2("A");
    anchor.y = 0;
    String currentText = Provider.of<ButtonGrid>(context, listen: false)
        .buttonText[anchor.x][anchor.y];
    while (currentText != "" && !solved()) {
      forward2("D");
      currentText = Provider.of<ButtonGrid>(context, listen: false)
          .buttonText[anchor.x][anchor.y];
    }
  }
  updateArrow();
  updateDef();
}

void left() {
  var context = navigatorKey.currentState!.context;
  currentX = anchor.x;
  currentY = anchor.y;
  if (anchor.AorD == "A") {
    backSpace2("A");
    String currentText = Provider.of<ButtonGrid>(context, listen: false)
        .buttonText[anchor.x][anchor.y];
    while (currentText != "" && !solved()) {
      backSpace2("A");
      currentText = Provider.of<ButtonGrid>(context, listen: false)
          .buttonText[anchor.x][anchor.y];
    }
  } else {
    backSpace2("A");
    String currentText = Provider.of<ButtonGrid>(context, listen: false)
        .buttonText[anchor.x][anchor.y];
    while (!getDownViews(anchor.x).contains('?') && !solved()) {
      backSpace2("A");
      currentText = Provider.of<ButtonGrid>(context, listen: false)
          .buttonText[anchor.x][anchor.y];
    }
    anchor.y = 0;
    currentText = Provider.of<ButtonGrid>(context, listen: false)
        .buttonText[anchor.x][anchor.y];
    while (currentText != "" && !solved()) {
      forward2("D");
      currentText = Provider.of<ButtonGrid>(context, listen: false)
          .buttonText[anchor.x][anchor.y];
    }
  }
  updateArrow();
  updateDef();
}

void up() {
  var context = navigatorKey.currentState!.context;
  currentX = anchor.x;
  currentY = anchor.y;
  if (anchor.AorD == "D") {
    backSpace2("D");
    String currentText = Provider.of<ButtonGrid>(context, listen: false)
        .buttonText[anchor.x][anchor.y];
    while (currentText != "" && !solved()) {
      backSpace2("D");
      currentText = Provider.of<ButtonGrid>(context, listen: false)
          .buttonText[anchor.x][anchor.y];
    }
  } else {
    backSpace2("D");
    String currentText = Provider.of<ButtonGrid>(context, listen: false)
        .buttonText[anchor.x][anchor.y];
    while (!getAcrossViews(anchor.y).contains('?') && !solved()) {
      backSpace2("D");
      currentText = Provider.of<ButtonGrid>(context, listen: false)
          .buttonText[anchor.x][anchor.y];
    }
    anchor.x = 0;
    currentText = Provider.of<ButtonGrid>(context, listen: false)
        .buttonText[anchor.x][anchor.y];
    while (currentText != "" && !solved()) {
      forward2("A");
      currentText = Provider.of<ButtonGrid>(context, listen: false)
          .buttonText[anchor.x][anchor.y];
    }
  }
  updateArrow();
  updateDef();
}

void down() {
  var context = navigatorKey.currentState!.context;
  currentX = anchor.x;
  currentY = anchor.y;
  if (anchor.AorD == "D") {
    forward2("D");
    String currentText = Provider.of<ButtonGrid>(context, listen: false)
        .buttonText[anchor.x][anchor.y];
    while (currentText != "" && !solved()) {
      forward2("D");
      currentText = Provider.of<ButtonGrid>(context, listen: false)
          .buttonText[anchor.x][anchor.y];
    }
  } else {
    forward2("D");
    anchor.x = 0;
    String currentText = Provider.of<ButtonGrid>(context, listen: false)
        .buttonText[anchor.x][anchor.y];
    while (currentText != "" && !solved()) {
      forward2("A");
      currentText = Provider.of<ButtonGrid>(context, listen: false)
          .buttonText[anchor.x][anchor.y];
    }
  }
  updateArrow();
  updateDef();
}

void updateArrow() {
  var context = navigatorKey.currentState!.context;
  Icon currentIcon =
      Provider.of<ButtonGrid>(context, listen: false).icon[currentX][currentY];
  Provider.of<ButtonGrid>(context, listen: false)
      .setIcon(currentX, currentY, Icon(Icons.star));
  Provider.of<ButtonGrid>(context, listen: false)
      .setIcon(anchor.x, anchor.y, currentIcon);
}

int currentX = 0;
int currentY = 0;

void forward(var dir) {
  int x = anchor.x;
  int y = anchor.y;
  if (dir == "A") {
    x++;
    if (x == 5) {
      x = 0;
      y++;
    }
    if (y == 5) {
      x = 0;
      y = 0;
    }
  } else {
    y++;
    if (y == 5) {
      x++;
      y = 0;
    }
    if (x == 5) {
      x = 0;
      y = 0;
    }
  }

  var context = navigatorKey.currentState!.context;
  Icon currentIcon =
      Provider.of<ButtonGrid>(context, listen: false).icon[anchor.x][anchor.y];
  Provider.of<ButtonGrid>(context, listen: false)
      .setIcon(anchor.x, anchor.y, Icon(Icons.star));
  anchor.x = x;
  anchor.y = y;

  Provider.of<ButtonGrid>(context, listen: false)
      .setIcon(anchor.x, anchor.y, currentIcon);

  String currentText = Provider.of<ButtonGrid>(context, listen: false)
      .buttonText[anchor.x][anchor.y];
  print("== $currentText");
  updateDef();
  if (currentText != "") {
    if (!solved()) {
      forward(dir);
    }
  }
}

void forward2(var dir) {
  int x = anchor.x;
  int y = anchor.y;

  if (dir == "A") {
    x++;
    if (x == 5) {
      x = 0;
      y++;
    }
    if (y == 5) {
      x = 0;
      y = 0;
    }
  } else {
    y++;
    if (y == 5) {
      y = 0;
      x++;
    }
    if (x == 5) {
      x = 0;
      y = 0;
    }
  }
  anchor.x = x;
  anchor.y = y;
}

bool solved() {
  for (int i = 0; i < 5; i++) {
    for (int j = 0; j < 5; j++) {
      if (Provider.of<ButtonGrid>(navigatorKey.currentState!.context,
                  listen: false)
              .buttonText[i][j] ==
          "") {
        return false;
      }
    }
  }
  var context = navigatorKey.currentState!.context;
  updateHighScores(Provider.of<MyHomePageState>(context, listen: false).score);
  showMessage(navigatorKey.currentState!.context, "", 0);
  return true;
}

void backSpace2(var dir) {
  int x = anchor.x;
  int y = anchor.y;
  if (dir == "A") {
    x--;
    if (x == -1) {
      y--;
      x = 4;
    }
    if (y == -1) {
      x = 4;
      y = 4;
    }
  } else {
    y--;
    if (y == -1) {
      x--;
      y = 4;
    }
    if (x == -1) {
      y = 4;
      x = 4;
    }
  }
  anchor.x = x;
  anchor.y = y;
}

var letterPick = <String>[];
void setUpLetterPick() {
  for (int i = 0; i < 26; i++) {
    letterPick.add("E");
  }
  for (int i = 0; i < 20; i++) {
    letterPick.add("A");
    letterPick.add("I");
  }
  for (int i = 0; i < 17; i++) {
    letterPick.add("O");
  }
  for (int i = 0; i < 5; i++) {
    letterPick.add("U");
  }
  for (int i = 0; i < 12; i++) {
    letterPick.add("N");
    letterPick.add("R");
    letterPick.add("T");
  }
  for (int i = 0; i < 8; i++) {
    letterPick.add("L");
    letterPick.add("S");
    letterPick.add("D");
  }
  for (int i = 0; i < 6; i++) {
    letterPick.add("G");
  }
  for (int i = 0; i < 4; i++) {
    letterPick.add("B");
    letterPick.add("C");
    letterPick.add("M");
    letterPick.add("P");
    letterPick.add("F");
    letterPick.add("H");
    letterPick.add("V");
    letterPick.add("W");
    letterPick.add("Y");
  }
  for (int i = 0; i < 1; i++) {
    letterPick.add("K");
    letterPick.add("J");
    letterPick.add("Q");
    letterPick.add("X");
    letterPick.add("Z");
  }
}

void initDefinitions() {
  List<String> acrossDefs = [];
  List<String> downDefs = [];

  for (int i = 0; i < numX; i++) {
    String across = getAcross(i);
    String down = getDown(i);
    print("TAG: $across");
    int indexA = words.indexOf(across);
    int indexD = words.indexOf(down);

    List<String> defsA = definitions[indexA];
    int r = Random().nextInt(defsA.length);
    String def = removePeriodAtEnd(defsA[r]);
    acrossDefs.add(def);
    List<String> defsD = definitions[indexD];
    r = Random().nextInt(defsD.length);
    def = removePeriodAtEnd(defsD[r]);
    downDefs.add(def);
  }
  for (int x = 0; x < numX; x++) {
    for (int y = 0; y < numY; y++) {
      letters[x][y].setDefA(acrossDefs[y]);
      letters[x][y].setDefD(downDefs[x]);
    }
  }
}

String removePeriodAtEnd(String def) {
  if (def.endsWith('.')) {
    def = def.substring(0, def.length - 1);
  }
  return def;
}

class Letter {
  String tag;
  int color;
  String defA;
  String defD;

  Letter(this.tag)
      : color = 0,
        defA = '',
        defD = '';

  String getDefA() {
    return defA;
  }

  void setDefA(String defA) {
    this.defA = defA;
  }

  String getDefD() {
    return defD;
  }

  void setDefD(String defD) {
    this.defD = defD;
  }

  int getColor() {
    return color;
  }

  void setColor(int color) {
    this.color = color;
  }

  String getTag() {
    return tag;
  }

  void setTag(String tag) {
    this.tag = tag;
  }
}

class XandY {
  int x, y;
  String l, AorD;
  List<String> possibleWords;
  List<Point<int>> added;

  XandY(this.x, this.y, this.AorD)
      : l = "null",
        possibleWords = [],
        added = [];

  int getX() => x;
  int getY() => y;
  String getL() => l;
  String getAorD() => AorD;
  List<Point<int>> getAdded() => added;

  void setX(int x) {
    this.x = x;
  }

  void setY(int y) {
    this.y = y;
  }

  void setL(String l) {
    this.l = l;
  }

  void setAorD(String AorD) {
    this.AorD = AorD;
  }

  void setAdded(List<Point<int>> added) {
    this.added = added;
  }
}

class Node {
  String? value;
  Node? parent;
  List<Node> children;

  Node() : children = [];

  String? getValue() {
    return value;
  }

  void setValue(String? value) {
    this.value = value;
  }

  Node? getParent() {
    return parent;
  }

  void setParent(Node? parent) {
    this.parent = parent;
  }

  List<Node> getChildren() {
    return children;
  }

  void setChildren(List<Node> children) {
    this.children = children;
  }

  void addChild(Node child) {
    children.add(child);
  }
}

Node? root;
void generateNodes(List<String> words) {
  root = Node();
  root?.setValue("root");
  Node? current;
  Node? previous;
  String? letter;
  int count = 0;
  for (int i = 0; i < words.length; i++) {
    previous = root;
    for (int j = 0; j < words[i].length; j++) {
      bool addNode = true;
      letter = words[i].substring(j, j + 1);
      List<Node> siblings = previous!.getChildren();
      current = root;
      for (Node sibling in siblings) {
        if (sibling.getValue() == letter) {
          addNode = false;
          current = sibling;
          break;
        }
      }
      if (addNode) {
        current = Node();
        current.setValue(letter);
        current.setParent(previous);
        previous.addChild(current);
      }
      previous = current;
      count++;
    }
  }
  // ignore: prefer_interpolation_to_compose_strings
  print("num nodes = $count");
}

List<String> findLetters(String s, Node r) {
  List<Node> result;
  List<String> finalResult = [];
  int index = 0;
  String c = s[index];
  result = r.getChildren();
  if (c == '?') {
    result.shuffle();
    for (Node n in result) {
      finalResult.add(n.getValue()![0]);
    }
    return finalResult;
  }
  Node? current;
  while (c != '?') {
    for (Node n in result) {
      if (n.getValue()![0] == c) {
        current = n;
        break;
      }
    }
    assert(current != null);
    result = current!.getChildren();
    index++;
    c = s[index];
  }
  result.shuffle();
  for (Node n in result) {
    finalResult.add(n.getValue()![0]);
  }
  return finalResult;
}

int numX = 5;
int numY = 5;

bool done = false;
//List<List<Letter>> letters = []; // Define and initialize the variable 'letters'
List<List<Letter>> letters =
    List.generate(5, (i) => List<Letter>.generate(5, (j) => Letter('')));

void findLetter(int x, int y) {
  if (done) return;

  letters[x][y].setTag("wild");
  String sA = getAcross(y);
  String sD = getDown(x);
  List<String> cA = findLetters(sA, root!);
  List<String> cD = findLetters(sD, root!);
  List<String> intersection = cA.toSet().intersection(cD.toSet()).toList();
  //print(intersection);
  int i = x;
  int j = y;
  i++;
  if (i == 5) {
    i = 0;
    j++;
  }
  for (String c in intersection) {
    if (done) return;
    letters[x][y].setTag(c.toString());
    if (j == 5) {
      done = true;
      //displayGrid();
      return;
    }
    findLetter(i, j);
  }
  if (!done) letters[x][y].setTag("wild");
}

void displayGrid() {
  for (int y = 0; y < numY; y++) {
    String row = getAcross(y);
    developer.log('+ $row');
  }
  developer.log('+ ');
}

String getDown(int x) {
  StringBuffer down = StringBuffer();
  for (int y = 0; y < 5; y++) {
    String tag = letters[x][y].getTag();
    if (tag == 'wild') {
      down.write('?');
    } else {
      down.write(tag);
    }
  }
  return down.toString();
}

String getDownViews(int x) {
  StringBuffer down = StringBuffer();
  for (int y = 0; y < 5; y++) {
    String tag = Provider.of<ButtonGrid>(navigatorKey.currentState!.context,
            listen: false)
        .buttonText[x][y];
    if (tag == '') {
      down.write('?');
    } else {
      down.write(tag);
    }
  }
  return down.toString();
}

String getAcross(int y) {
  StringBuffer across = StringBuffer();
  for (int x = 0; x < 5; x++) {
    String tag = letters[x][y].getTag();
    if (tag == 'wild') {
      across.write('?');
    } else {
      across.write(tag);
    }
  }
  return across.toString();
}

String getAcrossViews(int y) {
  StringBuffer across = StringBuffer();
  for (int x = 0; x < 5; x++) {
    String tag = Provider.of<ButtonGrid>(navigatorKey.currentState!.context,
            listen: false)
        .buttonText[x][y];
    if (tag == '') {
      across.write('?');
    } else {
      across.write(tag);
    }
  }
  return across.toString();
}

List<int> highScores = [
  0,
  0,
  0,
  0,
  0
]; // easy, medium, hard, challenging, impossible
void updateHighScores(int value) {
  int level = Provider.of<RadioButtonNotifier>(
          navigatorKey.currentState!.context,
          listen: false)
      .selectedRadio;
  if (value > highScores[level]) {
    highScores[level] = value;
    newHighScore = true;
  }

  print('High Scores');
  for (int i = 0; i < 5; i++) {
    print(highScores[i]);
  }
  print(' ');
  if (!kIsWeb && !Platform.isMacOS) {
    lifecycleManagerKey.currentState?.updateVariable(highScores);
  }
  //lifecycleManagerKey.currentState?.updateVariable(highScores);
}

bool newHighScore = false;
void showMessage(BuildContext context, String message, int seconds) {
  message = "Solved!";
  if (newHighScore) {
    message = "$message\nNew High Score!";
    newHighScore = false;
  }
  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Center(
          child: Text(message,
              style: TextStyle(fontSize: 24), textAlign: TextAlign.center),
        ),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context).pop();
              newPuzzle();
            },
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 6, color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Play Again',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 6, color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'OK',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
  // Future.delayed(Duration(milliseconds: seconds), () {
  //   Navigator.of(context).pop();
  // });
}

final GlobalKey<_LifecycleManagerState> lifecycleManagerKey =
    GlobalKey<_LifecycleManagerState>();

class LifecycleManager extends StatefulWidget {
  final Widget child;

  LifecycleManager({super.key, required this.child});

  @override
  _LifecycleManagerState createState() => _LifecycleManagerState();
}

class _LifecycleManagerState extends State<LifecycleManager>
    with WidgetsBindingObserver {
  List<int> myVariable = [];

  void updateVariable(List<int> newValue) async {
    setState(() {
      myVariable = newValue;
    });
    await saveVariable(newValue);
  }

  Future<void> saveVariable(List<int> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('myVariable', value.join(','));
    print('Saved variable');
  }

  Future<void> loadVariable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myVariableString = prefs.getString('myVariable');
    highScores =
        myVariableString?.split(',').map(int.parse).toList() ?? [0, 0, 0, 0, 0];
    setState(() {
      myVariable = highScores;
    });
    print('Loaded variable: $myVariable');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadVariable();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
