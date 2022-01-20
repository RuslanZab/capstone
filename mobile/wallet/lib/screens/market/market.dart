import 'package:flutter/material.dart';
import 'package:wallet/screens/market/api.dart';
import 'market_card.dart';
import 'package:http/http.dart' as http;

class MarketPage extends StatefulWidget {
  const MarketPage({Key? key}) : super(key: key);

  @override
  _MarketPageState createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  List<StaticTokenInformation> tokenList = [
    StaticTokenInformation(
        "ethereum", 'assets/images/coin_logos/ethereum.webp'),
    StaticTokenInformation("tether", 'assets/images/coin_logos/tether.webp'),
    StaticTokenInformation(
        "usd-coin", 'assets/images/coin_logos/usd-coin.webp'),
  ];

  List displayedList = [];

  final TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    displayedList = tokenList;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Coin Name",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 16),
                        fillColor: Colors.blue,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      searchOperation(_controller.text);
                    },
                    child: Icon(
                      Icons.search,
                    ),
                  )
                ],
              ),
            ),
          ),
          Flexible(
            child: ListView.separated(
              padding: EdgeInsets.all(25),
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 15,
                );
              },
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: displayedList.length,
              itemBuilder: (BuildContext ctxt, int index) {
                print('alt');
                return new MarketCard(displayedList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  void searchOperation(String searchText) {
    List searchResult = [];

    for (int i = 0; i < tokenList.length; i++) {
      StaticTokenInformation data = tokenList[i];
      if (data.name.toLowerCase().contains(searchText.toLowerCase())) {
        searchResult.add(data);
      }
    }

    setState(() {
      displayedList = searchResult;
    });
  }
}

class StaticTokenInformation {
  final String name;
  final String imagePath;

  StaticTokenInformation(this.name, this.imagePath);
}
