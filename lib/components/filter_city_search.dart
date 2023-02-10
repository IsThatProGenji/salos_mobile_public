import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:salos/models/data.dart';

import '../models/city.dart';
import 'constants.dart';

class FilterCitySearch extends StatefulWidget {
  const FilterCitySearch({Key? key, required this.page}) : super(key: key);
  final String page;
  @override
  State<FilterCitySearch> createState() => _FilterCitySearchState();
}

class _FilterCitySearchState extends State<FilterCitySearch> {
  FocusNode textFormField = FocusNode();
  String query = '';

  renderSuggestion() {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return TextButton(
            onPressed: () {
              widget.page == 'outbound'
                  ? Provider.of<Data>(context, listen: false)
                      .getSQLoutbounds_pre_search_city(result)
                  : Provider.of<Data>(context, listen: false)
                      .getSQLSearch(result);
              Navigator.pop(context);
            },
            child: ListTile(
              leading: Icon(Icons.search),
              title: Text(
                result,
                style: TextStyle(fontSize: 14),
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    textFormField.requestFocus();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.white,
          ),
          title: TextFormField(
            focusNode: textFormField,
            decoration: kInputDecoration.copyWith(
                hintText: 'Search',
                contentPadding: const EdgeInsets.only(
                  left: 0,
                )),
            onChanged: (value) {
              setState(() {
                query = value;
              });
            },
          ),
        ),
        body: renderSuggestion());
  }
}
