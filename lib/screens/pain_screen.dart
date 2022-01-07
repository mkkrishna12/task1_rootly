import 'package:aws_polly/aws_polly.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

int _score_val = 0;

final AwsPolly _awsPolly = AwsPolly.instance(
  poolId: 'us-east-1:b64af8d0-a9e9-4d73-96ee-ff9a32a49a73',
  region: AWSRegionType.USEast1,
);
FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _fireStore = FirebaseFirestore.instance;

const _emojis = [
  '😄',
  '😏',
  '😐',
  '😕',
  '😮',
  '😦',
  '😣',
  '😖',
  '😠',
  '😵‍',
  '😵'
];

class PainScreen extends StatefulWidget {
  const PainScreen({Key key}) : super(key: key);
  static const String id = 'PainScreen';

  @override
  _PainScreenState createState() => _PainScreenState();
}

class _PainScreenState extends State<PainScreen> {
  double _value = 0;

  void onPlay() async {
    final url = await _awsPolly.getUrl(
      voiceId: AWSPolyVoiceId.nicole,
      input: 'You Have ${_value.toInt()} More sessions today',
    );
    final player = AudioPlayer();
    await player.setUrl(url);
    player.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'image/background.jpeg',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                width: double.infinity,
                height: 170,
                child: Center(
                  child: ScoreReader(score: _value),
                  // Text(
                  //   "You Have $_score_val More sessions today",
                  //   maxLines: 3,
                  //   overflow: TextOverflow.ellipsis,
                  //   textAlign: TextAlign.start,
                  //   style: const TextStyle(
                  //     color: Colors.black,
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 20,
                  //   ),
                  // ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          height: 30,
                          width: double.infinity,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            child: const Text(
                              'Pain Score',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            child: const Text(
                              'How does your knee feel now ?',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            _emojis[_value.toInt()],
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // Text(_emojis[0], softWrap: true),
                                Expanded(
                                  child: SfSlider(
                                    min: 0,
                                    max: 10,
                                    value: _value.toInt(),
                                    interval: 1,
                                    showTicks: true,
                                    showLabels: true,
                                    enableTooltip: true,
                                    showDividers: true,
                                    dividerShape: const SfDividerShape(),
                                    onChanged: (dynamic value) {
                                      setState(() {
                                        _score_val = value.toInt();
                                        _value = value;
                                        onPlay();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    // color: Colors.white,
                                    // height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20.0)),
                                    ),
                                    width: 200,
                                    child: FlatButton(
                                      onPressed: () {
                                        _fireStore.collection('score').add({
                                          'userid': _auth.currentUser.uid,
                                          'score': _value.toInt() % 5 + 1,
                                          'value': _value.toInt(),
                                          'TS': FieldValue.serverTimestamp(),
                                        });
                                      },
                                      child: const Text(
                                        'Submit',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                // Text(
                                //   _emojis[10],
                                //   softWrap: true,
                                // )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScoreReader extends StatefulWidget {
  const ScoreReader({Key key, @required this.score}) : super(key: key);
  final double score;
  @override
  _ScoreReaderState createState() => _ScoreReaderState();
}

class _ScoreReaderState extends State<ScoreReader> {
  int score = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore.collection('score').orderBy('TS').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.docs.reversed;
        // print(messages);
        for (var mes in messages) {
          if (mes.get('value') == widget.score.toInt()) {
            score = mes.get('score');
          } else {
            score = 0;
          }
        }
        return Expanded(
          child: Text(
            "You Have $score More sessions today",
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        );
      },
    );
  }
}
