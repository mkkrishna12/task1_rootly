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
const  List<String>painList=[
  'No pain',
  'Mild Pain',
  'Moderate Pain',
  'Severe Pain',
];
class PainScreen extends StatefulWidget {
  const PainScreen({Key key}) : super(key: key);
  static const String id = 'PainScreen';

  @override
  _PainScreenState createState() => _PainScreenState();
}

class _PainScreenState extends State<PainScreen> {
  double _value = 0;
  String pain = "No pain";
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
                  child: Text(
                    "You Have 2 More sessions today",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration:  BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                         SizedBox(
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
                        Row(
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
                                    // onPlay();

                                  });
                                  _fireStore.collection('painCollection').snapshots().listen(
                                          (snapshot){
                                        final messages = snapshot.docs.reversed;

                                        setState(() {

                                          for (var mes in messages) {
                                            if (mes.get('scoreValue') == _value.toInt()) {
                                              print(mes.get('pain'));
                                              pain = mes.get('pain');
                                              break;
                                            } else {
                                              pain = "Please wait...";
                                            }
                                          }
                                        });
                                  });
                                },
                              ),
                            ),

                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(pain,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.green
                          ),
                        ),
                        const SizedBox(
                          height: 60.0,
                        ),

                        Container(
                          // color: Colors.white,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          ),
                          width: 200,
                          child: FlatButton(
                            onPressed: () async{

                            },
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        )

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
//
// class ScoreReader extends StatefulWidget {
//   const ScoreReader({Key key, @required this.score}) : super(key: key);
//   final double score;
//   @override
//   _ScoreReaderState createState() => _ScoreReaderState();
// }
//
// class _ScoreReaderState extends State<ScoreReader> {
//   String  score;
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _fireStore.collection('score').orderBy('TS').snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(
//             child: CircularProgressIndicator(
//               backgroundColor: Colors.lightBlueAccent,
//             ),
//           );
//         }
//         final messages = snapshot.data.docs.reversed;
//         // print(messages);
//         for (var mes in messages) {
//           if (mes.get('value') == widget.score.toInt()) {
//             score = mes.get('pain');
//             break;
//           } else {
//             score = "Please wait...";
//           }
//         }
//         return Container(
//           height: 100,
//           child: Text(
//             score,
//             maxLines: 3,
//             overflow: TextOverflow.ellipsis,
//             textAlign: TextAlign.start,
//             style: const TextStyle(
//               color: Colors.black,
//               fontWeight: FontWeight.bold,
//               fontSize: 20,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

