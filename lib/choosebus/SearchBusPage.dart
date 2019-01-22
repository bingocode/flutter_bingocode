import 'package:flutter/material.dart';

class searchBarDelegate extends SearchDelegate<String> {
  List<String> searchList;

  searchBarDelegate(this.searchList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = "",
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchItems();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchItems();
  }

  Widget _buildSearchItems() {
    final suggestionList = query.isEmpty
        ? []
        : searchList.where((input) => input.startsWith(query)).toList();
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) => ListTile(
            title: InkWell(
                onTap: () {
                  close(context, suggestionList[index]);
                },
                child: RichText(
                    text: TextSpan(
                        text: suggestionList[index].substring(0, query.length),
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                              text: suggestionList[index].substring(query.length),
                              style: TextStyle(color: Colors.grey))
                        ])))));
  }
}
