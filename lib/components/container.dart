// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:salos/components/constants.dart';
import 'package:salos/components/container_detail.dart';
import 'package:salos/models/data.dart';

/// The demo page for [OpenContainerTransform].
class OpenContainerTransformDemo extends StatefulWidget {
  /// Creates the demo page for [OpenContainerTransform].
  const OpenContainerTransformDemo(
      {Key? key,
      required this.number,
      required this.id,
      required this.date,
      required this.city,
      required this.remark})
      : super(key: key);
  final String number;
  final String date;
  final String city;
  final String remark;
  final int id;
  @override
  State<OpenContainerTransformDemo> createState() {
    return _OpenContainerTransformDemoState();
  }
}

class _OpenContainerTransformDemoState
    extends State<OpenContainerTransformDemo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 572,
      margin: const EdgeInsets.only(right: 0, left: 5, top: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 1.5,
            color: Colors.grey.shade100,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(7))),
      child: TextButton(
        style: TextButton.styleFrom(),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return _DetailsPage(
                    id: widget.id,
                    number: widget.number,
                    date: widget.date,
                    city: widget.city);
              },
            ),
          );
        },
        child: Row(
          children: [
            const SizedBox(
              width: 3,
            ),
            Container(
              width: 130,
              padding: const EdgeInsets.only(right: 4, left: 2),
              child: Row(children: [
                Text(
                  widget.number,
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xff165b60)),
                ),
                const SizedBox(
                  width: 5,
                ),
              ]),
            ),
            Container(
              width: 170,
              padding: const EdgeInsets.only(left: 5),
              child: Row(children: [
                Text(
                  widget.city,
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(
                  width: 5,
                ),
              ]),
            ),
            Container(
              width: 160,
              padding: const EdgeInsets.only(right: 0, left: 5),
              child: Row(children: [
                Text(
                  widget.date,
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(
                  width: 5,
                ),
              ]),
            ),
            Container(
              width: 90,
              padding: const EdgeInsets.only(right: 0, left: 5),
              child: Row(children: [
                Text(
                  widget.remark,
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(
                  width: 5,
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsPage extends StatefulWidget {
  const _DetailsPage(
      {required this.id,
      required this.number,
      required this.date,
      required this.city});

  final String number;
  final String date;
  final String city;
  final int id;

  @override
  State<_DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<_DetailsPage> {
  double kilo = 0;
  double koli = 0;

  renderListing(title, content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          title,
          style: TextStyle(color: Color(0xff165b60)),
        ),
        Text(content, style: TextStyle(color: Color(0xff165b60)))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    int indexid = 0;

    renderoutbound() {
      kilo = 0;
      koli = 0;

      List data = Provider.of<Data>(context).outboundData;
      List<ContainerDetail> outbound = [];
      for (var i = 0; i < data.length; i++) {
        if (Provider.of<Data>(context).outboundData[i]['id'] == widget.id) {
          // outbound.add(Provider.of<Data>(context).outboundData[i]);
          indexid = indexid + 1;
          outbound.add(ContainerDetail(
            index: indexid,
            id: widget.id,
            cn: data[i]['cn'].toString(),
            destination: data[i]['destination'].toString(),
            sender_name: data[i]['sender_name'].toString(),
            recipient_address: data[i]['recipient_address'].toString(),
            recipient_district: data[i]['recipient_district'].toString(),
            kilo: data[i]['kilo'].toString(),
            koli: data[i]['koli'].toString(),
            sender_address: data[i]['sender_address'].toString(),
            sender_regency: data[i]['sender_regency'].toString(),
            sender_phone: data[i]['sender_phone'].toString(),
            recipient_name: data[i]['recipient_name'].toString(),
            recipient_regency: data[i]['recipient_regency'].toString(),
            recipient_phone: data[i]['recipient_phone'].toString(),
            tgl_entry: data[i]['tgl_entry'].toString(),
            instruction: data[i]['instruction'].toString(),
            cost: data[i]['cost'].toString(),
            packing_fee: data[i]['packing_fee'].toString(),
            service: data[i]['service'].toString(),
            origin: data[i]['origin'].toString(),
          ));
          WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
                kilo += Provider.of<Data>(context, listen: false)
                    .outboundData[i]['kilo'];
                koli += Provider.of<Data>(context, listen: false)
                    .outboundData[i]['koli'];
              }));
        }
      }
      //  print(Provider.of<Data>(context).outboundData[0].toString());
      // print(outbound);

      return outbound;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLightGrey,
        elevation: 0,
        toolbarHeight: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: kLightGrey,
            statusBarIconBrightness: Brightness.dark),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            const SliverAppBar(
              backgroundColor: Colors.transparent,
              foregroundColor: Color(0xff165b60),
              elevation: 0,
              title: Text('Manifest Detail',
                  style: TextStyle(fontWeight: FontWeight.w500)),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Column(
                children: [
                  renderListing('No Manifest', widget.number),
                  renderListing('Tanggal', widget.date),
                  renderListing('Destination', widget.city),
                  renderListing('Jumlah Kilo', kilo.toString()),
                  renderListing('Jumlah Koli', koli.toInt().toString()),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  height: 41,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                      ),
                    ],
                    color: const Color(0xFF55BDD1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Container(
                              padding: const EdgeInsets.only(right: 4, left: 2),
                              child: FittedBox(
                                alignment: Alignment.center,
                                fit: BoxFit.scaleDown,
                                child: Row(children: const [
                                  Text(
                                    'No',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ]),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 11,
                            child: Container(
                              padding: const EdgeInsets.only(right: 4, left: 2),
                              child: FittedBox(
                                alignment: Alignment.center,
                                fit: BoxFit.scaleDown,
                                child: Row(children: const [
                                  Text(
                                    'No Pod',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ]),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              padding: const EdgeInsets.only(left: 5),
                              child: FittedBox(
                                alignment: Alignment.center,
                                fit: BoxFit.scaleDown,
                                child: Row(children: const [
                                  Text(
                                    'Dest',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ]),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Container(
                              padding: const EdgeInsets.only(right: 0, left: 5),
                              child: FittedBox(
                                alignment: Alignment.center,
                                fit: BoxFit.scaleDown,
                                child: Row(children: const [
                                  Text(
                                    'Pengirim',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ]),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: Container(
                              padding: const EdgeInsets.only(right: 0, left: 7),
                              child: FittedBox(
                                alignment: Alignment.center,
                                fit: BoxFit.scaleDown,
                                child: Row(children: const [
                                  Text(
                                    "Kecamatan",
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ]),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Container(
                              padding: const EdgeInsets.only(right: 0, left: 7),
                              child: FittedBox(
                                alignment: Alignment.center,
                                fit: BoxFit.scaleDown,
                                child: Row(children: const [
                                  Text(
                                    ' Kilo / Koli',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: renderoutbound(),
                ),
              ),
            ]))
          ],
        ),
      ),
    );
  }
}
