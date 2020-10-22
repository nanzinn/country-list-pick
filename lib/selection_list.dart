import 'dart:io';

import 'package:country_list_pick/country_selection_theme.dart';
import 'package:country_list_pick/support/code_country.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'country_list_pick.dart';

class SelectionList extends StatefulWidget {
  SelectionList(this.elements, this.initialSelection,
      {Key key, this.appBar, this.theme, this.countryBuilder})
      : super(key: key);

  final PreferredSizeWidget appBar;
  final List elements;
  final CountryCode initialSelection;
  final CountryTheme theme;
  final Widget Function(BuildContext context, CountryCode) countryBuilder;
  final Function(CountryCode) onSelected;

  @override
  _SelectionListState createState() => _SelectionListState();
}

class _SelectionListState extends State<SelectionList> {
  List countries;
  var diff = 0.0;

  var posSelected = 0;
  var height = 0.0;
  bool isShow = true;

  @override
  void initState() {
    countries = widget.elements;
    countries.sort((a, b) {
      return a.name.toString().compareTo(b.name.toString());
    });
    //_controller.addListener(_scrollListener);
    super.initState();
  }

  void _sendDataBack(BuildContext context, CountryCode initialSelection) {
    widget?.onSelected(initialSelection);
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarBrightness:
      Platform.isAndroid ? Brightness.dark : Brightness.light,
    ));
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: widget.appBar,
      body: Container(
        color: Color(0xfff4f4f4),
        child: LayoutBuilder(builder: (context, contrainsts) {
          return ListView(
            children: [
              // SliverToBoxAdapter(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.all(15.0),
              //         child: Text(widget.theme?.searchText ?? 'SEARCH'),
              //       ),
              //       Container(
              //         color: Colors.white,
              //         child: TextField(
              //           controller: _controller,
              //           decoration: InputDecoration(
              //             border: InputBorder.none,
              //             focusedBorder: InputBorder.none,
              //             enabledBorder: InputBorder.none,
              //             errorBorder: InputBorder.none,
              //             disabledBorder: InputBorder.none,
              //             contentPadding: EdgeInsets.only(
              //                 left: 15, bottom: 0, top: 0, right: 15),
              //             hintText:
              //                 widget.theme?.searchHintText ?? "Search...",
              //           ),
              //           onChanged: _filterElements,
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(15.0),
              //         child:
              //             Text(widget.theme?.lastPickText ?? 'LAST PICK'),
              //       ),
              //       Container(
              //         color: Colors.white,
              //         child: Material(
              //           color: Colors.transparent,
              //           child: ListTile(
              //             leading: Image.asset(
              //               widget.initialSelection.flagUri,
              //               package: 'country_list_pick',
              //               width: 32.0,
              //             ),
              //             title: Text(widget.initialSelection.name),
              //             trailing: Padding(
              //               padding: const EdgeInsets.only(right: 20.0),
              //               child: Icon(Icons.check, color: Colors.green),
              //             ),
              //           ),
              //         ),
              //       ),
              //       SizedBox(height: 15),
              //     ],
              //   ),
              // ),
              ...countries.map((e) {
                return widget.countryBuilder != null
                    ? widget.countryBuilder(
                    context, e)
                    : getListCountry(e);
              }).toList()
              // SliverList(
              //   delegate: SliverChildBuilderDelegate((context, index) {
              //     return widget.countryBuilder != null
              //         ? widget.countryBuilder(
              //             context, countries.elementAt(index))
              //         : getListCountry(countries.elementAt(index));
              //   }, childCount: countries.length),
              // )
            ],
          );
        }),
      ),
    );
  }

  Widget getListCountry(CountryCode e) {
    return Container(
      height: 50,
      color: Colors.white,
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          leading: Image.asset(
            e.flagUri,
            package: 'country_list_pick',
            width: 30.0,
          ),
          trailing: Icon(Icons.check_circle),
          title: Text(e.name),
          onTap: () {
            _sendDataBack(context, e);
          },
        ),
      ),
    );
  }
}
