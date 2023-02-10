// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:salos/components/constants.dart';

/// The demo page for [OpenContainerTransform].
class OpenContainerTransformDemo_outbound extends StatefulWidget {
  /// Creates the demo page for [OpenContainerTransform].
  const OpenContainerTransformDemo_outbound(
      {Key? key,
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
      required this.status})
      : super(key: key);
  final String id;
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
  final String status;
  @override
  State<OpenContainerTransformDemo_outbound> createState() {
    return _OpenContainerTransformDemo_outboundState();
  }
}

class _OpenContainerTransformDemo_outboundState
    extends State<OpenContainerTransformDemo_outbound> {
  renderStatus(no) {
    Widget status = Row(children: const [
      Text(
        'Input Outbound',
        style: TextStyle(fontSize: 13),
      ),
      SizedBox(
        width: 5,
      ),
    ]);
    if (no == '0') {
      status = FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(7)),
            color: Color.fromARGB(172, 252, 234, 239),
          ),
          child: const Center(
            child: Text(
              'Input Outbound',
              style: TextStyle(
                  fontSize: 13, color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      );
    } else if (no == '1') {
      status = FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(7)),
            color: Color(0xffe8fff3),
          ),
          child: const Center(
            child: Text(
              'Manifest',
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.green,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      );
    } else if (no == '2') {
      status = FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(7)),
            color: Color(0xffe8fff3),
          ),
          child: const Center(
            child: Text(
              'Invoice',
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.green,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      );
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 780,
      height: 40,
      margin: const EdgeInsets.only(right: 5, left: 8, top: 10),
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
                  id: widget.id.toString(),
                  cn: widget.cn.toString(),
                  destination: widget.destination.toString(),
                  sender_name: widget.sender_name.toString(),
                  recipient_address: widget.recipient_address.toString(),
                  recipient_district: widget.recipient_district.toString(),
                  kilo: widget.kilo.toString(),
                  koli: widget.koli.toString(),
                  sender_address: widget.sender_address.toString(),
                  sender_regency: widget.sender_regency.toString(),
                  sender_phone: widget.sender_phone.toString(),
                  recipient_name: widget.recipient_name.toString(),
                  recipient_regency: widget.recipient_regency.toString(),
                  recipient_phone: widget.recipient_phone.toString(),
                  tgl_entry: widget.tgl_entry.toString(),
                  instruction: widget.instruction.toString(),
                  cost: widget.cost.toString(),
                  packing_fee: widget.packing_fee.toString(),
                  service: widget.service.toString(),
                  origin: widget.origin.toString(),
                );
              },
            ),
          );
        },
        child: Row(
          children: [
            Container(
              width: 140,
              padding: const EdgeInsets.only(right: 4, left: 2),
              child: Row(children: [
                Text(
                  widget.cn,
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xff165b60)),
                ),
                const SizedBox(
                  width: 5,
                ),
              ]),
            ),
            Container(
              width: 155,
              padding: const EdgeInsets.only(left: 5),
              child: Row(children: [
                Text(
                  widget.tgl_entry,
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
              padding: const EdgeInsets.only(right: 0, left: 5),
              child: Row(children: [
                Text(
                  widget.sender_regency,
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
              padding: const EdgeInsets.only(right: 0, left: 5),
              child: Row(children: [
                Text(
                  widget.recipient_regency,
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xff165b60)),
                ),
                const SizedBox(
                  width: 5,
                ),
              ]),
            ),
            Container(
                width: 120,
                height: 30,
                padding: const EdgeInsets.only(right: 0, left: 7),
                child: Row(
                  children: [renderStatus(widget.status)],
                )),
          ],
        ),
      ),
    );
  }
}

class _DetailsPage extends StatefulWidget {
  const _DetailsPage(
      {required this.id,
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
      required this.origin});

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
  final String id;
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
              title: Text('Outbound Detail',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Color(0xff165b60))),
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
                    '${widget.origin}-${widget.destination}',
                    style:
                        const TextStyle(fontSize: 18, color: Color(0xff165b60)),
                  ),
                ],
              ),
              renderListing('Connocement', widget.cn),
              renderListing('Service', widget.service),
              renderListing(
                  'Biaya Kirim',
                  'Rp. ' +
                      NumberFormat("#,##0.00", "en_US")
                          .format(int.parse(widget.cost) / 10) +
                      '.-'),
              const SizedBox(
                height: 20,
              ),
              renderListing('Pengirim', widget.sender_name),
              renderListing('Alamat ', widget.sender_address),
              renderListing('Kota ', widget.sender_regency),
              renderListing('Telp', widget.sender_phone),
              const SizedBox(
                height: 20,
              ),
              renderListing('Penerima', widget.recipient_name),
              renderListing('Alamat ', widget.recipient_address),
              renderListing('Kecamatan ', widget.recipient_district),
              renderListing('Kota ', widget.recipient_regency),
              const SizedBox(
                height: 20,
              ),
              renderListing('Tanggal', widget.tgl_entry),
              renderListing('Attention', widget.instruction),
              renderListing('Berat', '${kilo.toString()} Kg'),
              renderListing('Koli', koli.toString()),
              renderListing(
                  'Biaya Kirim',
                  'Rp. ' +
                      NumberFormat("#,##0.00", "en_US")
                          .format(int.parse(widget.cost) / 10) +
                      '.-'),
              renderListing(
                  'Biaya Packing',
                  'Rp. ' +
                      NumberFormat("#,##0.00", "en_US")
                          .format(int.parse(widget.packing_fee) / 10) +
                      '.-'),
              renderListing('Kota Tujuan',
                  '${widget.recipient_district}, ${widget.recipient_regency}'),
              const SizedBox(
                height: 20,
              ),
            ]))
          ],
        ),
      ),
    );
  }
}
