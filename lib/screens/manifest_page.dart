import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salos/models/data.dart';
import 'package:provider/provider.dart';
import 'package:salos/components/container.dart';
import 'package:salos/components/bottomSheet.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:shimmer/shimmer.dart';
import 'package:salos/components/scrollbehaviour.dart';

import '../components/constants.dart';
import '../components/filter_city_search.dart';

class ManifestScreen extends StatefulWidget {
  const ManifestScreen({Key? key}) : super(key: key);
  static const String id = 'manifest_screen';

  @override
  State<ManifestScreen> createState() => _ManifestScreenState();
}

class _ManifestScreenState extends State<ManifestScreen> {
  bool search = false;
  FocusNode textfieldfocus = FocusNode();
  String searchData = '';
  final ScrollController _scrollController = ScrollController();
  final LinkedScrollControllerGroup _controllers =
      LinkedScrollControllerGroup();
  ScrollController _scrollController2 = ScrollController();
  ScrollController _scrollController3 = ScrollController();
  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          Provider.of<Data>(context, listen: false).getLazyStatus != 'true' &&
          Provider.of<Data>(context, listen: false).getLazyStatus != 'nodata') {
        Provider.of<Data>(context, listen: false).getSQLlazy();
      }
    });

    _scrollController2 = _controllers.addAndGet();
    _scrollController3 = _controllers.addAndGet();
    super.initState();
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    // _scrollController2.dispose();
    // _scrollController3.dispose();
    super.dispose();
  }

  renderShimmer() {
    List<Shimmer> shimmer = [];
    for (var i = 0; i < 15; i++) {
      shimmer.add(
        Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: const Color(0xFFEBEBF4),
            child: Padding(
              padding: const EdgeInsets.only(right: 5, left: 5, top: 10),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(7))),
                height: 40,
              ),
            )),
      );
    }
    return shimmer;
  }

  renderLazy() {
    Widget lazy = const Padding(
      padding: EdgeInsets.all(8.0),
      child: SizedBox(
        height: 20,
        width: 20,
      ),
    );
    if (Provider.of<Data>(context).getLazyStatus == 'true') {
      lazy = const Padding(
        padding: EdgeInsets.all(8.0),
        child: SizedBox(width: 540, child: LinearProgressIndicator()),
      );
    }
    if (Provider.of<Data>(context).getLazyStatus == 'nodata') {
      lazy = const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('No More Data Found',
            style: TextStyle(color: Color(0xff165b60))),
      );
    }
    return lazy;
  }

  renderArrow(sort) {
    var render = const Icon(
      Icons.arrow_downward_rounded,
      size: 20.0,
      color: Colors.transparent,
    );

    if (Provider.of<Data>(context).sortData == sort + ' desc') {
      render = Icon(
        Icons.south,
        size: 20.0,
        color: Colors.white,
      );
    } else if (Provider.of<Data>(context).sortData == sort) {
      render = Icon(
        Icons.north,
        size: 20.0,
        color: Colors.white,
      );
    }

    return render;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
          backgroundColor: const Color(0xFF55BDD1),
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Color(0xFF55BDD1),
              statusBarIconBrightness: Brightness.light),
        ),
        body: SafeArea(
          top: false,
          child: CustomScrollView(
            physics: ClampingScrollPhysics(),
            scrollBehavior: MyBehavior(),
            key: const PageStorageKey('page'),
            controller: _scrollController,
            slivers: <Widget>[
              SliverAppBar(
                toolbarHeight: 45,
                collapsedHeight: 45,
                expandedHeight: 125.0,
                backgroundColor: const Color(0xFF55BDD1),
                foregroundColor: Colors.white,
                elevation: 0,
                actions: [
                  search
                      ? TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              search = false;
                            });
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              search = true;
                              Provider.of<Data>(context, listen: false)
                                  .requestfocus();
                            });
                          },
                          icon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ))
                ],
                floating: true,
                pinned: true,
                snap: true,
                title: search
                    ? Container(
                        height: 36,
                        padding: const EdgeInsets.only(right: 20),
                        child: TextField(
                          cursorColor: Colors.white,
                          focusNode: Provider.of<Data>(context).focus,
                          maxLines: 1,
                          style: TextStyle(fontSize: 15, color: Colors.white),
                          onChanged: (value) {
                            searchData = value;
                          },
                          onSubmitted: ((value) {
                            setState(() {
                              search = false;
                              Provider.of<Data>(context, listen: false)
                                  .getSQLSearch(searchData);
                            });
                          }),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: Colors.white),
                            hintStyle: TextStyle(color: Colors.white),
                            filled: true,
                            prefixIcon: Icon(Icons.search, color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1.5,
                                  color: Color.fromARGB(255, 128, 214, 231)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1.5,
                                  color: Color.fromARGB(255, 128, 214, 231)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            fillColor: const Color(0xFF55BDD1),
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Search',
                          ),
                        ),
                      )
                    : const Text(
                        'Manifests',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                flexibleSpace: FlexibleSpaceBar(
                    background: SafeArea(
                  child: Column(
                    children: [
                      Container(
                        height: 45,
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 40,
                              // color: Colors.grey,
                              child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                key: const PageStorageKey('chips'),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 17.0),
                                      child: DateBottomSheet(),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    ActionChip(
                                      backgroundColor: Colors.white,
                                      label: const Text(
                                        'Filter by Recipient City',
                                        style:
                                            TextStyle(color: Color(0xff165b60)),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(createRoute());
                                      },
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    ActionChip(
                                      backgroundColor: Colors.white,
                                      label: Row(children: [
                                        Text(
                                          'Reset Filter',
                                          style: TextStyle(
                                              color: Color(0xff165b60)),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Icon(
                                          Icons.replay,
                                          color: kDarkBlue,
                                          size: 17,
                                        )
                                      ]),
                                      onPressed: () {
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .getSQLSort('reset');
                                      },
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              key: const PageStorageKey('scroll'),
                              physics: const BouncingScrollPhysics(),
                              controller: _scrollController2,
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                height: 37,
                                margin: const EdgeInsets.only(left: 9),
                                padding:
                                    const EdgeInsets.only(right: 0, left: 0),
                                width: 572,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .getSQLSort('manifest_number');
                                      },
                                      child: Container(
                                        color: const Color(0xFF55BDD1),
                                        margin: const EdgeInsets.only(left: 5),
                                        padding: const EdgeInsets.only(
                                            right: 7,
                                            left: 3,
                                            top: 7,
                                            bottom: 7),
                                        width: 132,
                                        child: Row(children: [
                                          const Text(
                                            'No. Manifest',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          renderArrow('manifest_number'),
                                        ]),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .getSQLSort('name');
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 5, top: 7, bottom: 7),
                                        width: 170,
                                        color: const Color(0xFF55BDD1),
                                        child: Row(children: [
                                          const Text(
                                            'Kota/Kab Tujuan',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.white),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          renderArrow('name'),
                                        ]),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .getSQLSort('manifest_date');
                                      },
                                      child: Container(
                                        width: 160,
                                        padding: const EdgeInsets.only(
                                            left: 5, top: 7, bottom: 7),
                                        color: const Color(0xFF55BDD1),
                                        child: Row(children: [
                                          const Text(
                                            'Tanggal Manifest',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.white),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          renderArrow('manifest_date'),
                                        ]),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .getSQLSort('remark');
                                      },
                                      child: Container(
                                        width: 90,
                                        padding: const EdgeInsets.only(
                                            left: 5, top: 7, bottom: 7),
                                        color: const Color(0xFF55BDD1),
                                        child: Row(children: [
                                          const Text(
                                            'Remark',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          renderArrow('remark'),
                                        ]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ]),
                    ],
                  ),
                )),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Provider.of<Data>(context).getNodataStatus
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'No Result Found',
                              style: TextStyle(color: Color(0xff165b60)),
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            Provider.of<Data>(context).getloadingStatus
                                ? Column(children: renderShimmer())
                                : SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    key: const PageStorageKey('scroll'),
                                    controller: _scrollController3,
                                    scrollDirection: Axis.horizontal,
                                    child: Column(
                                      children: [
                                        const OpenContainerTransformDemo(
                                          id: 1,
                                          number: 'test',
                                          date: 'test',
                                          city: 'test',
                                          remark: 'test',
                                        ),
                                        const OpenContainerTransformDemo(
                                          id: 1,
                                          number: 'test',
                                          date: 'test',
                                          city: 'test',
                                          remark: 'test',
                                        ),
                                        const OpenContainerTransformDemo(
                                          id: 1,
                                          number: 'test',
                                          date: 'test',
                                          city: 'test',
                                          remark: 'test',
                                        ),
                                        const OpenContainerTransformDemo(
                                          id: 1,
                                          number: 'test',
                                          date: 'test',
                                          city: 'test',
                                          remark: 'test',
                                        ),
                                        const OpenContainerTransformDemo(
                                          id: 1,
                                          number: 'test',
                                          date: 'test',
                                          city: 'test',
                                          remark: 'test',
                                        ),
                                        const OpenContainerTransformDemo(
                                          id: 1,
                                          number: 'test',
                                          date: 'test',
                                          city: 'test',
                                          remark: 'test',
                                        ),
                                        const OpenContainerTransformDemo(
                                          id: 1,
                                          number: 'test',
                                          date: 'test',
                                          city: 'test',
                                          remark: 'test',
                                        ),
                                        const OpenContainerTransformDemo(
                                          id: 1,
                                          number: 'test',
                                          date: 'test',
                                          city: 'test',
                                          remark: 'test',
                                        ),
                                        const OpenContainerTransformDemo(
                                          id: 1,
                                          number: 'test',
                                          date: 'test',
                                          city: 'test',
                                          remark: 'test',
                                        ),
                                        const OpenContainerTransformDemo(
                                          id: 1,
                                          number: 'test',
                                          date: 'test',
                                          city: 'test',
                                          remark: 'test',
                                        ),
                                        const OpenContainerTransformDemo(
                                          id: 1,
                                          number: 'test',
                                          date: 'test',
                                          city: 'test',
                                          remark: 'test',
                                        ),
                                        Column(
                                          children: [
                                            Builder(builder:
                                                (BuildContext context) {
                                              return Column(
                                                children: [
                                                  Column(
                                                      children:
                                                          Provider.of<Data>(
                                                                  context)
                                                              .manifestData),
                                                  renderLazy(),
                                                ],
                                              );
                                            }),

                                            // Padding(
                                            //   padding: const EdgeInsets.symmetric(
                                            //       vertical: 15.0),
                                            //   child: LinearProgressIndicator(),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                          ],
                        )
                ]),
              ),
            ],
          ),
        ));

    //      ListView(
    //   children: [Column(children: Provider.of<Data>(context).manifestData)],
    // )
  }
}

Route createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const FilterCitySearch(
      page: 'manifest',
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
