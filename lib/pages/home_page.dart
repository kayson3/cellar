import 'package:Cellar2/model/radio.dart';
import 'package:Cellar2/pages/webview.dart';
import 'package:Cellar2/utils/ai_util.dart';
// //import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_radio_player/flutter_radio_player.dart';

class HomePage extends StatefulWidget {
  final playerState = FlutterRadioPlayer.flutter_radio_paused;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _mail =
      'mailto:info@cellarbrothers.com.ng?subject=MessageFromCellarApk&body=Message:';
  String _mail2 =
      'mailto:cellarbros@gmail.com?subject=MessageFromCellarApk&body=Message:';
  _sendmail() async =>
      await canLaunch(_mail) ? await launch(_mail) : throw 'could not send';
  _sendmail2() async =>
      await canLaunch(_mail2) ? await launch(_mail2) : throw 'could not send';
  List<MyRadio> radios;
  MyRadio _selectedRadio;
  Color _selectedColor;

  // final AudioPlayer _audioPlayer = AudioPlayer();

  //_sendmail()
  @override
  void initState() {
    super.initState();

    initRadioService();
    fetchRadios();

    // _audioPlayer.onPlayerStateChanged.listen((event) {
    //   if (event == AudioPlayerState.PLAYING) {
    //     _isPlaying = true;
    //   } else {
    //     _isPlaying = false;
    //   }
    //   setState(() {});
    // });
  }

  fetchRadios() async {
    final radioJson = await rootBundle.loadString("assets/radio.json");
    radios = MyRadioList.fromJson(radioJson).radios;
    _selectedRadio = radios[0];
    _selectedColor = Color(int.tryParse(_selectedRadio.color));
    print(radios);
    setState(() {});
  }

  final List<Widget> _children = [
    new HomePage(),
  ];

  FlutterRadioPlayer _flutterRadioPlayer = new FlutterRadioPlayer();

  Future<void> initRadioService() async {
    try {
      await _flutterRadioPlayer.init("Cellar FM", "Live",
          "https://cellarfm1.out.airtime.pro/cellarfm1_a", "false");
    } on PlatformException {
      print("Exception occurred while trying to register the services.");
    }
  }

  ///////
  ///////
  ///    dis play the radio unclick
  ///
  ///

  // _playMusic(String url) {
  //   //_audioPlayer.play(url);
  //   _selectedRadio = radios.firstWhere((element) => element.url == url);
  //   print(_selectedRadio.name);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: Container(
            color: _selectedColor ?? AIColors.primaryColor2,
            child: radios != null
                ? [
                    100.heightBox,
                    "All Channels".text.xl.white.semiBold.make().px16(),
                    20.heightBox,
                    ListView(
                      padding: Vx.m0,
                      shrinkWrap: true,
                      children: radios
                          .map((e) => ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "https://1.bp.blogspot.com/-YKQdgaPWFjE/YH28sBucbGI/AAAAAAAAAIo/aVr-E_3wcUsxbzw0ZHQH1UZiKT2D3z6yACLcBGAsYHQ/s0/Cellar.jpg"),
                                ),
                                title: "${e.name} FM".text.white.make(),
                                subtitle: e.tagline.text.white.make(),
                              ))
                          .toList(),
                    ),
                    100.heightBox,
                    "Contact Us".text.xl.white.semiBold.make().px16(),
                    5.heightBox,
                    GestureDetector(
                        onTap: _sendmail,
                        child:
                            "    info@cellarbrothers.com.ng".text.white.make()),
                    15.heightBox,
                    GestureDetector(
                            onTap: _sendmail2,
                            child: "    cellarbros@gmail.com".text.white.make())
                        .expand()
                  ].vStack(crossAlignment: CrossAxisAlignment.start)
                : const Offstage(),
          ),
        ),
        body: Stack(
          children: [
            VxAnimatedBox()
                .size(context.screenWidth, context.screenHeight)
                .withGradient(
                  LinearGradient(
                    colors: [
                      AIColors.primaryColor2,
                      _selectedColor ?? AIColors.primaryColor1,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                )
                .make(),
            [
              AppBar(
                title: "Cellar".text.xl4.bold.white.make().shimmer(
                    primaryColor: Vx.purple300, secondaryColor: Colors.white),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                centerTitle: true,
              ).h(100.0).p16(),
            ].vStack(alignment: MainAxisAlignment.start),
            30.heightBox,
            radios != null
                ? VxSwiper.builder(
                    itemCount: radios.length,
                    aspectRatio: context.mdWindowSize == MobileWindowSize.xsmall
                        ? 1.0
                        : context.mdWindowSize == MobileWindowSize.medium
                            ? 2.0
                            : 3.0,
                    enlargeCenterPage: true,
                    onPageChanged: (index) {
                      _selectedRadio = radios[index];
                      final colorHex = radios[index].color;
                      _selectedColor = Color(int.tryParse(colorHex));
                      setState(() {});
                    },
                    itemBuilder: (context, index) {
                      final rad = radios[index];

                      return VxBox(
                              child: ZStack(
                        [
                          Positioned(
                            top: 0.0,
                            right: 0.0,
                            child: VxBox(
                              child: rad.category.text.uppercase.white
                                  .make()
                                  .px16(),
                            )
                                .height(40)
                                .black
                                .alignCenter
                                .withRounded(value: 10.0)
                                .make(),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: VStack(
                              [
                                rad.name.text.xl3.white.bold.make(),
                                5.heightBox,
                                rad.tagline.text.sm.white.semiBold.make(),
                              ],
                              crossAlignment: CrossAxisAlignment.center,
                            ),
                          ),
                          // Align(
                          //     alignment: Alignment.center,
                          //     child: [
                          //       Icon(
                          //         CupertinoIcons.play_circle,
                          //         color: Colors.white,
                          //       ),
                          //       10.heightBox,
                          //       "".text.gray300.make(), //Double tap to play
                          //     ].vStack())
                        ],
                      ))
                          .clip(Clip.antiAlias)
                          .bgImage(
                            DecorationImage(
                                image: NetworkImage(rad.image),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.3),
                                    BlendMode.darken)),
                          )
                          .border(color: Colors.black, width: 5.0)
                          .withRounded(value: 60.0)
                          .make()
                          .onInkDoubleTap(() {})
                          .p16();
                    },
                  ).centered()
                : Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  ),
            Align(
              alignment: Alignment.bottomCenter,
              child: StreamBuilder(
                  stream: _flutterRadioPlayer.isPlayingStream,
                  initialData: widget.playerState,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    String returnData = snapshot.data;
                    print("object data: " + returnData);
                    switch (returnData) {
                      case FlutterRadioPlayer.flutter_radio_stopped:
                        return IconButton(
                            icon: Icon(Icons.play_circle_outline,
                                color: Colors.white, size: 50),
                            onPressed: () async {
                              await initRadioService();
                            });
                        break;
                      case FlutterRadioPlayer.flutter_radio_loading:
                        return Text("Loading stream...",
                            style:
                                TextStyle(color: Colors.white, fontSize: 19));
                      case FlutterRadioPlayer.flutter_radio_error:
                        return RaisedButton(
                            child: Text("Retry ?"),
                            onPressed: () async {
                              await initRadioService();
                            });
                        break;
                      default:
                        return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                  onPressed: () async {
                                    print("button press data: " +
                                        snapshot.data.toString());
                                    await _flutterRadioPlayer.playOrPause();
                                  },
                                  icon: snapshot.data ==
                                          FlutterRadioPlayer
                                              .flutter_radio_playing
                                      ? Icon(Icons.pause_circle_outline,
                                          color: Colors.white, size: 40)
                                      : Icon(Icons.play_circle_outline,
                                          color: Colors.white, size: 40)),
                              IconButton(
                                  onPressed: () async {
                                    await _flutterRadioPlayer.stop();
                                  },
                                  icon: Icon(Icons.stop_circle_outlined,
                                      color: Colors.white, size: 40))
                            ]);
                        break;
                    }
                  }),
            ).pOnly(bottom: context.percentHeight * 12)
          ],
          fit: StackFit.expand,
          clipBehavior: Clip.antiAlias,
        ),
        floatingActionButton: FloatingActionButton(
            child: FaIcon(FontAwesomeIcons.battleNet),
            backgroundColor: Colors.pink,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) => Web()));
            }));
  }
}
