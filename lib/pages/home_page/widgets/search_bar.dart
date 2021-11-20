import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key, this.onChange}) : super(key: key);
  final onChange;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(children: [
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
              TextFormField(
                maxLines: 1,
                onChanged: (value) => widget.onChange(value),
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(left: 32, right: 8),
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.black38),
                  fillColor: Colors.white12,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54, width: 0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 0),
                  ),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
