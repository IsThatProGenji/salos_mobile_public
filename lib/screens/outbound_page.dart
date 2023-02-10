import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salos/components/constants.dart';
import 'package:salos/components/scrollbehaviour.dart';
import 'package:salos/models/data.dart';
import 'package:provider/provider.dart';
import 'package:salos/components/bottomSheetOutbound.dart';
import 'package:shimmer/shimmer.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import '../components/filter_city_search.dart';

class OutboundScreen extends StatefulWidget {
  const OutboundScreen({Key? key}) : super(key: key);
  static const String id = 'manifest_screen';

  @override
  State<OutboundScreen> createState() => _OutboundScreenState();
}

class _OutboundScreenState extends State<OutboundScreen> {
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
          Provider.of<Data>(context, listen: false).getLazyStatusOutbound !=
              'true' &&
          Provider.of<Data>(context, listen: false).getLazyStatusOutbound !=
              'nodata') {
        print('getting');
        Provider.of<Data>(context, listen: false).getSQLoutbounds_pre_lazy();
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
    if (Provider.of<Data>(context).getLazyStatusOutbound == 'true') {
      lazy = const Padding(
        padding: EdgeInsets.all(8.0),
        child: SizedBox(width: 760, child: LinearProgressIndicator()),
      );
    }
    if (Provider.of<Data>(context).getLazyStatusOutbound == 'nodata') {
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

    if (Provider.of<Data>(context).sortDataoutbound == sort + ' desc') {
      render = Icon(
        Icons.south,
        size: 20.0,
        color: Colors.white,
      );
    } else if (Provider.of<Data>(context).sortDataoutbound == sort) {
      render = Icon(
        Icons.north,
        size: 20.0,
        color: Colors.white,
      );
    }

    return render;
  }

  var index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF55BDD1),
          elevation: 0,
          toolbarHeight: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Color(0xFF55BDD1),
              statusBarIconBrightness: Brightness.light),
        ),
        body: SafeArea(
          top: false,
          child: CustomScrollView(
            physics: ClampingScrollPhysics(),
            scrollBehavior: MyBehavior(),
            key: const PageStorageKey('page_2'),
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
                                  .requestfocusoutbound();
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
                          focusNode: Provider.of<Data>(context).focus_outbound,
                          maxLines: 1,
                          style: TextStyle(fontSize: 15, color: Colors.white),
                          onChanged: (value) {
                            searchData = value;
                          },
                          onSubmitted: ((value) {
                            setState(() {
                              search = false;
                              Provider.of<Data>(context, listen: false)
                                  .getSQLoutbounds_pre_search(searchData);
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
                        'Outbounds',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                flexibleSpace: FlexibleSpaceBar(
                    background: SafeArea(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 45,
                        ),
                        SizedBox(
                          height: 40,
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            key: const PageStorageKey('chips_2'),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 17.0),
                                  child: DateBottomSheetOutbound(),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                ActionChip(
                                  backgroundColor: Colors.white,
                                  label: const Text(
                                    'Filter by Recipient City',
                                    style: TextStyle(color: Color(0xff165b60)),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(createRoute());
                                  },
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                ActionChip(
                                  backgroundColor: Colors.white,
                                  label: Row(children: [
                                    const Text(
                                      'Reset Filter',
                                      style:
                                          TextStyle(color: Color(0xff165b60)),
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
                                    Provider.of<Data>(context, listen: false)
                                        .getSQLoutbounds_pre_sort('reset');
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
                          key: const PageStorageKey('scroll_2'),
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          controller: _scrollController2,
                          child: Container(
                            height: 37,
                            width: 780,
                            margin: const EdgeInsets.only(
                              right: 5,
                              left: 8,
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Provider.of<Data>(context, listen: false)
                                        .getSQLoutbounds_pre_sort(
                                            'connocement');
                                  },
                                  child: Container(
                                    width: 140,
                                    color: const Color(0xFF55BDD1),
                                    margin: const EdgeInsets.only(left: 10),
                                    padding: const EdgeInsets.only(
                                        right: 10, left: 0, top: 7, bottom: 7),
                                    child: Row(children: [
                                      const Text(
                                        'Connocement',
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.white),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      renderArrow('connocement'),
                                    ]),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Provider.of<Data>(context, listen: false)
                                        .getSQLoutbounds_pre_sort('tgl_entry');
                                  },
                                  child: Container(
                                    width: 155,
                                    padding: const EdgeInsets.only(
                                        left: 5, top: 7, bottom: 7),
                                    color: const Color(0xFF55BDD1),
                                    child: Row(children: [
                                      const Text(
                                        'Data Entry',
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.white),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      renderArrow('tgl_entry'),
                                    ]),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Provider.of<Data>(context, listen: false)
                                        .getSQLoutbounds_pre_sort('r1.`name`');
                                  },
                                  child: Container(
                                    color: const Color(0xFF55BDD1),
                                    padding: const EdgeInsets.only(
                                        left: 5, top: 7, bottom: 7),
                                    width: 170,
                                    child: Row(children: [
                                      const Text(
                                        'Sender City',
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.white),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      renderArrow('r1.`name`'),
                                    ]),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Provider.of<Data>(context, listen: false)
                                        .getSQLoutbounds_pre_sort('r2.`name`');
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 5, top: 7, bottom: 7),
                                    color: const Color(0xFF55BDD1),
                                    width: 170,
                                    child: Row(children: [
                                      const Text(
                                        'Recipient City',
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.white),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      renderArrow('r2.`name`'),
                                    ]),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Provider.of<Data>(context, listen: false)
                                        .getSQLoutbounds_pre_sort('status');
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 5, top: 7, bottom: 7),
                                    color: const Color(0xFF55BDD1),
                                    width: 120,
                                    child: Row(children: [
                                      const Text(
                                        'Status',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      renderArrow('status'),
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ]),
                )),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Provider.of<Data>(context).getNodataStatusOutbound
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text('No Result Found',
                                style: TextStyle(color: Color(0xff165b60))),
                          ),
                        )
                      : Column(
                          children: [
                            Provider.of<Data>(context).getloadingStatusOutbound
                                ? Column(children: renderShimmer())
                                : SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    key: const PageStorageKey('scroll_2'),
                                    controller: _scrollController3,
                                    scrollDirection: Axis.horizontal,
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            Builder(builder:
                                                (BuildContext context) {
                                              return Column(
                                                children: [
                                                  Column(
                                                      children: Provider.of<
                                                                  Data>(context)
                                                              .getoutbounds +
                                                          Provider.of<Data>(
                                                                  context)
                                                              .getoutbounds +
                                                          Provider.of<Data>(
                                                                  context)
                                                              .getoutbounds),
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
      page: 'outbound',
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
