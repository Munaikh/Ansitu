import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/models/app_data.dart';
import '/models/surah.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/reader.dart';
import 'readers_page.dart';

class ReaderPage extends StatefulWidget {
  ReaderPage({Key? key, required this.reader}) : super(key: key);

  final Reader reader;

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage>
    with SingleTickerProviderStateMixin {
  late AnimationController iconController;
  @override
  void initState() {
    iconController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    AppData.assetsAudioPlayer.showNotification = true;
    super.initState();
  }

  @override
  void dispose() {
    // assetsAudioPlayer.stop();
    iconController.dispose();
    super.dispose();
  }

  
  bool _play = false;
  String _currentPosition = '';
  TextEditingController searchController = TextEditingController();
  List<Surah> listToShow = [];

  @override
  Widget build(BuildContext context) {
    String url =
        '${widget.reader.server}/${widget.reader.suras[0].id.padLeft(3, '0')}.mp3';
    ThemeData theme = Theme.of(context);
    Color primary = theme.brightness == Brightness.light
        ? theme.primaryColor
        : theme.primaryColorDark;

    bool isFav = AppData.favoriteReaders.contains(widget.reader);
    if (searchController.text == '') listToShow = widget.reader.suras;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // print(_play);
          // print(AppData.assetsAudioPlayer.isPlaying.value);
          setState(() {
            _play = !_play;
            if (!AppData.assetsAudioPlayer.isPlaying.value) {
              AppData.assetsAudioPlayer.play();
              iconController.forward();
            } else {
              AppData.assetsAudioPlayer.pause();
              iconController.reverse();
            }
          });
        },
        child: AnimatedBuilder(
          animation:
              CurvedAnimation(parent: iconController, curve: Curves.easeInOut),
          builder: (context, child) {
            return AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: CurvedAnimation(
                  parent: iconController, curve: Curves.easeInOut),
            );
          },
          child: Icon(
            _play ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: Scrollbar(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    // backgroundColor: primary,
                    expandedHeight: 100,
                    pinned: true,
                    leading: SizedBox(),
                    actions: [
                      if (widget.reader.instagram != '')
                        IconButton(
                          splashRadius: 20,
                          onPressed: () {
                            launch(widget.reader.instagram!);
                          },
                          icon: Icon(FontAwesomeIcons.instagram),
                        ),
                      if (widget.reader.twitter != '')
                        IconButton(
                          splashRadius: 20,
                          onPressed: () {
                            launch(widget.reader.twitter!);
                          },
                          icon: Icon(FontAwesomeIcons.twitter),
                        ),
                      if (widget.reader.youtube != '')
                        IconButton(
                          splashRadius: 20,
                          onPressed: () {
                            launch(widget.reader.youtube!);
                          },
                          icon: Icon(FontAwesomeIcons.youtube),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios_new),
                        ),
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      title: OverflowBox(
                        alignment: AlignmentDirectional.bottomStart,
                        maxWidth: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                if (isFav) {
                                  AppData.favoriteReaders.remove(widget.reader);
                                  // await saveAppData();
                                } else {
                                  AppData.favoriteReaders.add(widget.reader);
                                  // await saveAppData();
                                }
                                setState(() {});
                              },
                              icon: Icon(
                                isFav
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: Colors.redAccent,
                              ),
                              padding: EdgeInsets.all(0),
                              splashRadius: 16,
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                widget.reader.name,
                                overflow: TextOverflow.fade,
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                          ],
                        ),
                      ),
                      centerTitle: false,
                      titlePadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: PersistentHeader(
                      widget: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Hero(
                                  tag: 'Search',
                                  child: Material(
                                    child: SizedBox(
                                      height: 44,
                                      child: TextField(
                                        controller: searchController,
                                        onChanged: (value) {
                                          listToShow = widget.reader.suras
                                              .where((surah) => surah.name
                                                  .contains(
                                                      searchController.text))
                                              .toList();

                                          setState(() {});
                                          print(listToShow);
                                        },
                                        decoration: InputDecoration(
                                          hintText: "Search",
                                          contentPadding:
                                              EdgeInsets.symmetric(vertical: 4),
                                          prefixIcon: Icon(Icons.search),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        Surah surah = listToShow[index];
                        return ListTile(
                          title: Text(surah.name,
                              style: theme.textTheme.headline6),
                          onTap: () async {
                            AppData.assetsAudioPlayer.stop();
                            print(_play);
                            HapticFeedback.mediumImpact();
                            try {
                              await AppData.assetsAudioPlayer.open(
                                Audio.network(
                                  '${widget.reader.server}/${surah.id.padLeft(3, '0')}.mp3',
                                  metas: Metas(
                                    title: surah.name,
                                    artist: widget.reader.name,
                                  ),
                                ),
                                showNotification: true,
                                playInBackground: PlayInBackground.enabled,
                              );
                              iconController.forward();
                              setState(() {
                                _play = true;
                              });
                            } catch (t) {
                              //mp3 unreachable
                              print('error');
                            }
                            // print(
                            //     await reader.getAudio(int.parse(surah.id)));
                          },
                        );
                      },
                      childCount: listToShow.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
