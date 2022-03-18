import 'package:flutter/material.dart';
import '/models/app_data.dart';
import '/models/reader.dart';
import '/pages/reader_page.dart';

class ReadersPage extends StatefulWidget {
  const ReadersPage({Key? key}) : super(key: key);

  @override
  State<ReadersPage> createState() => _ReadersPageState();
}

class _ReadersPageState extends State<ReadersPage> {
  bool toggelFav = false;
  TextEditingController searchController = TextEditingController();
  List<Reader> listToShow = AppData.readerList;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color primary = theme.brightness == Brightness.light
        ? theme.primaryColor
        : theme.primaryColorDark;

    return Scaffold(
      body: Center(
        child: Scrollbar(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 100,
                  // backgroundColor: primary,
                  pinned: true,
                  leading: SizedBox(),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios_new)),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      "القراء",
                      style: TextStyle(fontSize: 30),
                    ),
                    centerTitle: false,
                    titlePadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
                            // Icon(
                            //   toggelFav
                            //       ? Icons.favorite_rounded
                            //       : Icons.favorite_border_rounded,
                            //   size: Theme.of(context)
                            //       .textTheme
                            //       .headline6!
                            //       .fontSize,
                            //   color: Colors.redAccent,
                            // ),
                            // Switch(
                            //   value: toggelFav,
                            //   onChanged: (value) {
                            //     setState(() {
                            //       toggelFav = value;
                            //     });
                            //   },
                            // ),
                            Expanded(
                              child: Hero(
                                tag: 'Search',
                                child: Material(
                                  child: SizedBox(
                                    height: 44,
                                    child: TextField(
                                      controller: searchController,
                                      onChanged: (value) {
                                        if (toggelFav) {
                                          listToShow = AppData.favoriteReaders
                                              .where((reader) => reader.name
                                                  .contains(searchController.text))
                                              .toList();
                                          setState(() {});
                                        } else {
                                          listToShow = AppData.readerList
                                              .where((reader) => reader.name
                                                  .contains(searchController.text))
                                              .toList();
                                        }
                                        setState(() {});
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
                            SizedBox(width: 8),
                            DropdownButton(
                              hint: toggelFav ? Text("Favorite") : Text("All"),
                              underline: SizedBox(),
                              items: [
                                DropdownMenuItem(
                                  value: false,
                                  child: Text('All'),
                                ),
                                DropdownMenuItem(
                                  value: true,
                                  child: Text('Favorite'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  toggelFav = value.toString() == 'true';
                                  listToShow = toggelFav ? AppData.favoriteReaders : AppData.readerList;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if(listToShow.isEmpty) SliverToBoxAdapter(
                  child: Center(
                    child: Text("No Reciters", style: TextStyle(fontSize: 20),),
                  ),
                ),
                if(listToShow.isNotEmpty) SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      var reader = listToShow[index];
                      return ListTile(
                        title: Text(
                          reader.name,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        subtitle: Text(reader.rewaya),
                        trailing: Icon(Icons.arrow_back_ios_new_rounded),
                        leading: Icon(Icons.record_voice_over),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReaderPage(reader: reader),
                            ),
                          );
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
    );
  }
}

class PersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget widget;

  PersistentHeader({required this.widget});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      width: double.infinity,
      // height: 56.0,
      color: Theme.of(context).backgroundColor,

      child: Center(child: widget),
    );
  }

  @override
  double get maxExtent => 56.0;

  @override
  double get minExtent => 56.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
