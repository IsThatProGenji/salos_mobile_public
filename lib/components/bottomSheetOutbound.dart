import 'package:salos/components/constants.dart';
import 'package:salos/models/data.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateBottomSheetOutbound extends StatefulWidget {
  const DateBottomSheetOutbound({Key? key}) : super(key: key);

  @override
  State<DateBottomSheetOutbound> createState() =>
      _DateBottomSheetOutboundState();
}

class _DateBottomSheetOutboundState extends State<DateBottomSheetOutbound> {
  DateTime startDate = DateTime(0);
  DateTime endDate = DateTime(0);

  getFormatedFilterDate(date) {
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(date);
    var outputFormat = DateFormat('dd-MM-yyyy');
    return outputFormat.format(inputDate);
  }

  @override
  Widget build(BuildContext context) {
    return ActionChip(
        backgroundColor: Colors.white,
        label: const Text('Filter by Date',
            style: TextStyle(color: Color(0xff165b60))),
        onPressed: () {
          showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(15))),
              context: context,
              builder: (context) {
                return ListView(shrinkWrap: true, children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 15, bottom: 15),
                              child: const Text('Filter by Date',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: kDarkBlue))),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.only(),
                        color: Colors.grey.withOpacity(0.2),
                        height: 2,
                        width: double.infinity,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Select Outbounds Date Range',
                          style: TextStyle(color: kDarkBlue),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await showDatePicker(
                                      context: context,
                                      initialDate: startDate == DateTime(0)
                                          ? DateTime.now()
                                          : startDate,
                                      firstDate: DateTime(2010),
                                      lastDate: DateTime(2030))
                                  .then((newDate) {
                                if (newDate != null) {
                                  setState(() {
                                    startDate = newDate;
                                  });
                                  Provider.of<Data>(context, listen: false)
                                      .setStartDateOutbound(newDate.toString());
                                }
                              });
                            },
                            child: Container(
                                padding: const EdgeInsets.only(right: 20),
                                height: 52,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      width: 1.5,
                                      color: kDarkBlue,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(7))),
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(right: 8.0, left: 8),
                                      child: Icon(
                                        Icons.date_range,
                                        color: kDarkBlue,
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Start with',
                                          style: TextStyle(
                                              fontSize: 10, color: kDarkBlue),
                                        ),
                                        Provider.of<Data>(
                                                  context,
                                                ).startDateDataOutbound ==
                                                ''
                                            ? const Text('dd-mm-yyyy',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: kDarkBlue))
                                            : Text(
                                                getFormatedFilterDate(
                                                    Provider.of<Data>(
                                                  context,
                                                ).startDateDataOutbound),
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: kDarkBlue))
                                      ],
                                    )
                                  ],
                                )),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () async {
                              await showDatePicker(
                                      context: context,
                                      initialDate: endDate == DateTime(0)
                                          ? DateTime.now()
                                          : endDate,
                                      firstDate: DateTime(2010),
                                      lastDate: DateTime(2030))
                                  .then((newDate) {
                                if (newDate != null) {
                                  setState(() {
                                    endDate = newDate;
                                  });
                                  Provider.of<Data>(context, listen: false)
                                      .setEndDateOutbound(newDate.toString());
                                }
                              });
                            },
                            child: Container(
                                padding: const EdgeInsets.only(right: 20),
                                height: 52,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      width: 1.5,
                                      color: kDarkBlue,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(7))),
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(right: 8.0, left: 8),
                                      child: Icon(Icons.date_range,
                                          color: kDarkBlue),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'End with',
                                          style: TextStyle(
                                              fontSize: 10, color: kDarkBlue),
                                        ),
                                        Provider.of<Data>(
                                                  context,
                                                ).endDateDataOutbound ==
                                                ''
                                            ? const Text('dd-mm-yyyy',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: kDarkBlue))
                                            : Text(
                                                getFormatedFilterDate(
                                                    Provider.of<Data>(
                                                  context,
                                                ).endDateDataOutbound),
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: kDarkBlue))
                                      ],
                                    )
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, bottom: 15, top: 40),
                    child: Container(
                      height: 40,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: Provider.of<Data>(context,
                                                  listen: false)
                                              .endDateDataOutbound !=
                                          '' &&
                                      Provider.of<Data>(context, listen: false)
                                              .startDateDataOutbound !=
                                          ''
                                  ? MaterialStateProperty.all(kMainBlue)
                                  : MaterialStateProperty.all(kMainBluelight),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ))),
                          onPressed: () {
                            if (Provider.of<Data>(context, listen: false)
                                        .endDateDataOutbound !=
                                    '' &&
                                Provider.of<Data>(context, listen: false)
                                        .startDateDataOutbound !=
                                    '') {
                              Provider.of<Data>(context, listen: false)
                                  .getSQLoutbounds_pre_date();
                              Navigator.pop(context);
                            } else {}
                          },
                          child: const Center(
                              child: Text(
                            'Confirm',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ))),
                    ),
                  )
                ]);
              });
        });
  }
}
