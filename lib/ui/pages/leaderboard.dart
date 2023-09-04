import 'dart:convert';
import 'dart:math';
import 'package:elearning/services/user_details_api_client.dart';
import 'package:elearning/theme/config.dart' as config;
import 'package:elearning/ui/widgets/card.dart';
import 'package:elearning/ui/widgets/sectionHeader.dart';
import 'package:elearning/ui/widgets/statsCard.dart';
import 'package:elearning/ui/widgets/topBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LeaderboardPage extends StatefulWidget {
  LeaderboardPage({Key? key, required this.onMenuTap, required this.user})
      : super(key: key);
  final Function? onMenuTap;
  final User user;
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  TextEditingController controller = TextEditingController();
  late bool local;
  List<String> names = [];
  List<String> ids = [];
  List<Color> colors = [];

  @override
  void initState() {
    local = true;
    super.initState();
    // Fetch data from the API when the widget initializes
    fetchDataFromAPI();
  }
Future<void> fetchDataFromAPI() async {
  try {
    // Retrieve the token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString('token');

    if (userToken == null) {
      // Handle the case where the token is not available in SharedPreferences
      print('Authentication token not found in SharedPreferences');
      return;
    }

    // Replace with your API endpoint
    final apiUrl = Uri.parse('http://192.168.1.8/api/students');

    final response = await http.get(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $userToken', // Add the token to the headers
      },
    );

    if (response.statusCode == 200) {
      final contentType = response.headers['content-type'];
      if (contentType != null && contentType.contains('application/json')) {
        final dynamic responseData = json.decode(response.body);

        if (responseData is List) {
          // The API response is an array
          final List<dynamic> studentData = responseData;
          setState(() {
            // Extract student names and coins from the API data
            names = studentData.map((data) => data['name'].toString()).toList();
            ids = studentData.map((data) => data['id'].toString()).toList();
            // Generate random colors based on the number of students
            generateRandomColors(names.length);
          });
        } else if (responseData is Map<String, dynamic>) {
          // The API response is an object
          // Handle the object data as needed
          // For example, if the data structure is like: { "students": [ {...}, {...}, ... ] }
          final List<dynamic> studentData = responseData['students'];
          setState(() {
            // Extract student names and coins from the API data
            names = studentData.map((data) => data['name'].toString()).toList();
            ids = studentData.map((data) => data['id'].toString()).toList();
            // Generate random colors based on the number of students
            generateRandomColors(names.length);
          });
        } else {
          // Handle the unexpected response format
          print('Unexpected API response format');
          // Show an error message or handle this case accordingly.
        }
      } else {
        // API returned unexpected content type
        print('API returned an unexpected content type: $contentType');
        // Handle this case accordingly, e.g., show an error message.
      }
    } else {
      // Handle other status codes (e.g., not 200) if needed
      print('API Request Failed: ${response.statusCode}');
      print('Response Body: ${response.body}');
      // Handle this case accordingly, e.g., show an error message.
    }
  } catch (e) {
    print('Error: $e');
    // Handle the error gracefully, e.g., show an error message to the user.
  }
}




  // Function to generate random colors
  void generateRandomColors(int count) {
    Random random = Random();

    // Generate random colors for each student
    colors = List.generate(
      count,
      (index) => Color.fromRGBO(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
        1.0, // You can adjust the opacity here
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> leaderboardItems = [];

    for (int index = 0; index < names.length; index++) {
      leaderboardItems.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14),
          child: CardWidget(
            gradient: false,
            button: false,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${index + 1}.",
                    style: TextStyle(
                      fontFamily: 'Red Hat Display',
                      fontSize: 18,
                      color: Color(0xFF585858),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${names[index]}",
                    style: TextStyle(
                      fontFamily: 'Red Hat Display',
                      fontSize: 18,
                      color: Color(0xFF585858),
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.elliptical(10, 50),
                      bottomLeft: Radius.elliptical(10, 50),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        material.Colors.white,
                        colors[index],
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/CoinSmall.png',
                          width: 50,
                        ),
                        Text(
                          "${ids[index]}",
                          style: TextStyle(
                            fontFamily: 'Red Hat Display',
                            fontSize: 18,
                            color: Color(0xFF585858),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            height: 60,
          ),
        ),
      );
    }

    return CupertinoPageScaffold(
      backgroundColor: config.Colors().secondColor(1),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SafeArea(
            child: local
                ? CustomScrollView(
                    slivers: <Widget>[
                      SliverFixedExtentList(
                        delegate:
                            SliverChildListDelegate.fixed([Container()]),
                        itemExtent:
                            MediaQuery.of(context).size.height * 0.23,
                      ),
                      SliverToBoxAdapter(
                        child: SectionHeader(
                          text: 'Google Leaderboard',
                          onPressed: () {},
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 240,
                              child: ListView(
                                physics: NeverScrollableScrollPhysics(),
                                children: leaderboardItems,
                              ),
                            ),
                            Positioned(
                              top: -5,
                              left: -4,
                              child: Image.asset('assets/images/crown.png'),
                            )
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SectionHeader(
                          text: 'My Statistics',
                          onPressed: () {},
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 245,
                          child: StatsCard(),
                        ),
                      ),
                    ],
                  )
                : CustomScrollView(
                    slivers: <Widget>[
                      SliverFixedExtentList(
                        delegate:
                            SliverChildListDelegate.fixed([Container()]),
                        itemExtent:
                            MediaQuery.of(context).size.height * 0.23,
                      ),
                      SliverToBoxAdapter(
                        child: SectionHeader(
                          text: 'Leaderboard',
                          onPressed: () {},
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: ListView(
                                physics: NeverScrollableScrollPhysics(),
                                children: leaderboardItems,
                              ),
                            ),
                            Positioned(
                              top: -5,
                              left: -4,
                              child: Image.asset('assets/images/crown.png'),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
          Positioned(
            top: 0,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    TopBar(
                      controller: controller,
                      expanded: false,
                      onMenuTap: widget.onMenuTap,
                      userName: widget.user.name,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.07,
                      color: material.Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CupertinoButton(
                            onPressed: () {
                              setState(() {
                                local = true;
                              });
                            },
                            child: Text(
                              "Local",
                              style: TextStyle(
                                color: Color(0xFF343434),
                                fontSize: 20,
                                fontFamily: 'Red Hat Display',
                                fontWeight: material.FontWeight.w600,
                              ),
                            ),
                          ),
                          CupertinoButton(
                            onPressed: () {
                              setState(() {
                                local = false;
                              });
                            },
                            child: Text(
                              "Global",
                              style: TextStyle(
                                color: Color(0xFF343434),
                                fontSize: 20,
                                fontFamily: 'Red Hat Display',
                                fontWeight: material.FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: AnimatedContainer(
                    margin: local
                        ? EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.33 - 35,
                          )
                        : EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.67 - 10,
                          ),
                    width: 40,
                    height: 4,
                    duration: Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: Color(0xFF03A9F4),
                      borderRadius: BorderRadius.circular(500),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
