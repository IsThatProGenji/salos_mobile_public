// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:salos/components/constants.dart';

final oCcy = NumberFormat("#,##0.00", "en_US");

/// The demo page for [OpenContainerTransform].
class ContainerDetail extends StatefulWidget {
  /// Creates the demo page for [OpenContainerTransform].
  const ContainerDetail({
    Key? key,
    required this.index,
    required this.id,
    required this.cn,
    required this.destination,
    required this.sender_name,
    required this.recipient_address,
    required this.recipient_district,
    required this.kilo,
    required this.koli,
    required this.sender_address,
    required this.sender_regency,
    required this.sender_phone,
    required this.recipient_name,
    required this.recipient_regency,
    required this.recipient_phone,
    required this.tgl_entry,
    required this.instruction,
    required this.cost,
    required this.packing_fee,
    required this.service,
    required this.origin,
  }) : super(key: key);
  final int index;
  final int id;
  final String cn;
  final String destination;
  final String sender_name;
  final String recipient_address;
  final String recipient_district;
  final String kilo;
  final String koli;
  final String sender_address;
  final String sender_regency;
  final String sender_phone;
  final String recipient_name;
  final String recipient_regency;
  final String recipient_phone;
  final String tgl_entry;
  final String instruction;
  final String cost;
  final String packing_fee;
  final String service;
  final String origin;
  @override
  State<ContainerDetail> createState() {
    return _ContainerDetailState();
  }
}

class _ContainerDetailState extends State<ContainerDetail> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        OpenContainer<bool>(
          transitionType: ContainerTransitionType.fade,
          openBuilder: (BuildContext _, VoidCallback openContainer) {
            return _DetailsPage(
              id: widget.id,
              cn: widget.cn,
              destination: widget.destination,
              sender_name: widget.sender_name,
              recipient_address: widget.recipient_address,
              recipient_district: widget.recipient_district,
              kilo: widget.kilo,
              koli: widget.koli,
              sender_address: widget.sender_address,
              sender_regency: widget.sender_regency,
              sender_phone: widget.sender_phone,
              recipient_name: widget.recipient_name,
              recipient_regency: widget.recipient_regency,
              recipient_phone: widget.recipient_phone,
              tgl_entry: widget.tgl_entry,
              instruction: widget.instruction,
              cost: widget.cost,
              packing_fee: widget.packing_fee,
              service: widget.service,
              origin: widget.origin,
            );
          },
          tappable: false,
          openShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(7))),
          closedElevation: 0.0,
          closedBuilder: (BuildContext _, VoidCallback openContainer) {
            return Container(
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 1.5,
                    color: Colors.grey.shade100,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(7))),
              child: TextButton(
                onPressed: openContainer,
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
                              child: Row(children: [
                                Text(
                                  widget.index.toString(),
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(
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
                              child: Row(children: [
                                Text(
                                  widget.cn,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(
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
                              child: Row(children: [
                                Text(
                                  widget.destination,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(
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
                              child: Row(children: [
                                Text(
                                  widget.sender_name,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(
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
                              child: Row(children: [
                                Text(
                                  widget.recipient_district,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(
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
                              child: Row(children: [
                                Text(
                                  ' ${widget.kilo} / ${widget.koli}',
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(
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
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class _DetailsPage extends StatelessWidget {
  const _DetailsPage({
    required this.id,
    required this.cn,
    required this.destination,
    required this.sender_name,
    required this.recipient_address,
    required this.recipient_district,
    required this.kilo,
    required this.koli,
    required this.sender_address,
    required this.sender_regency,
    required this.sender_phone,
    required this.recipient_name,
    required this.recipient_regency,
    required this.recipient_phone,
    required this.tgl_entry,
    required this.instruction,
    required this.cost,
    required this.packing_fee,
    required this.service,
    required this.origin,
  });
  final String cn;
  final String destination;
  final String sender_name;
  final String recipient_address;
  final String recipient_district;
  final String kilo;
  final String koli;
  final String sender_address;
  final String sender_regency;
  final String sender_phone;
  final String recipient_name;
  final String recipient_regency;
  final String recipient_phone;
  final String tgl_entry;
  final String instruction;
  final String cost;
  final String packing_fee;
  final String service;
  final String origin;
  renderListing(title, content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          title,
          style: TextStyle(color: Color(0xff165b60)),
        ),
        Text(
          content,
          style: TextStyle(color: Color(0xff165b60)),
        )
      ]),
    );
  }

  final int id;
  @override
  Widget build(BuildContext context) {
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
        child: CustomScrollView(slivers: [
          const SliverAppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: Color(0xff165b60),
            elevation: 0,
            title: Text(
              'Outbound Detail',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$origin-$destination',
                  style:
                      const TextStyle(fontSize: 18, color: Color(0xff165b60)),
                ),
              ],
            ),
            renderListing('Connocement', cn),
            renderListing('Service', service),
            renderListing(
                'Biaya Kirim',
                'Rp. ' +
                    NumberFormat("#,##0.00", "en_US")
                        .format(int.parse(cost) / 10) +
                    '.-'),
            const SizedBox(
              height: 20,
            ),
            renderListing('Pengirim', sender_name),
            renderListing('Alamat ', sender_address),
            renderListing('Kota ', sender_regency),
            renderListing('Telp', sender_phone),
            const SizedBox(
              height: 20,
            ),
            renderListing('Penerima', recipient_name),
            renderListing('Alamat ', recipient_address),
            renderListing('Kecamatan ', recipient_district),
            renderListing('Kota ', recipient_regency),
            const SizedBox(
              height: 20,
            ),
            renderListing('Tanggal', tgl_entry),
            renderListing('Attention', instruction),
            renderListing('Berat', '$kilo Kg'),
            renderListing('Koli', koli),
            renderListing(
                'Biaya Kirim',
                'Rp. ' +
                    NumberFormat("#,##0.00", "en_US")
                        .format(int.parse(cost) / 10) +
                    '.-'),
            renderListing(
                'Biaya Packing',
                'Rp. ' +
                    NumberFormat("#,##0.00", "en_US")
                        .format(int.parse(packing_fee) / 10) +
                    '.-'),
            renderListing(
                'Kota Tujuan', '$recipient_district, $recipient_regency'),
            const SizedBox(
              height: 20,
            ),
          ]))
        ]),
      ),
    );
  }
}
