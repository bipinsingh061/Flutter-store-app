import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loginPage/editPage.dart';
import 'package:loginPage/fullscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import "package:cached_network_image/cached_network_image.dart";

import 'LoginPage.dart';
import 'addProduct.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List mydata = [];
  List power = [];

  _SearchScreenState() {
    getdata();
  }
  bool loading = true;

  getdata() async {
    print("loadinf");
    String url = 'http://madhavapi.herokuapp.com/get/all';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{}';
    print(json); // make POST request

    Response response = await post(url,
        headers: headers, body: json); // check the status code for the result
    print("done");
    print(response.body);

    print('done');
    var d = jsonDecode(response.body);
    print('done');
    this.setState(() {
      mydata = d['data'];
      power = d['data'];
      loading = false;
    });

    searchnow();
  }

  deleteitem(String id) async {
    print("sending");
    String url = 'http://madhavapi.herokuapp.com/get/delete';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"id":"$id"}';
    print(json); // make POST request
    Response response = await post(url,
        headers: headers, body: json); // check the status code for the result

    print(response.body);
  }

  List<String> items = [
    'ALL',
    '2X4',
    '2X2',
    '12X12',
    '16X16',
    '12X18',
    '2X1',
    '800X1600',
    '39X39',
    '800X800',
    '10X15',
    '8X40'
  ];

  List<String> availability = ["ALL", "Available", "Not Available"];
  String selavail = "ALL";
  List<String> companyList = ["G.S.T."];
  String companySelected = "G.S.T.";
  String sizesel = 'ALL';

  TextEditingController searchController = TextEditingController();

  searchnow() {
    List monu = [];
    List bipin = [];
    String name = searchController.text;
    String size = sizesel;
    String company = companySelected;
    if (name == "") {
      bipin = power;
    } else {
      for (int i = 0; i < power.length; ++i) {
        if (power[i]['name']
            .toString()
            .toLowerCase()
            .contains(name.toLowerCase())) {
          bipin.add(power[i]);
        }
      }
    }
    //bipin ready
    monu = [];

    if (size == "ALL") {
      monu = bipin;
    } else {
      for (int i = 0; i < bipin.length; ++i) {
        if (bipin[i]['size'].toString() == size) {
          monu.add(bipin[i]);
        }
      }
    }
    //monu ready
    bipin = [];
    if (company == "ALL") {
      bipin = monu;
    } else {
      for (int i = 0; i < monu.length; ++i) {
        if (monu[i]['company'].toString() == company) bipin.add(monu[i]);
      }
    }
    // bipin ready
    monu = [];
    if (selavail == 'ALL') {
      monu = bipin;
    } else if (selavail == 'Available') {
      for (int i = 0; i < bipin.length; ++i) {
        if (bipin[i]['available'].toString().toLowerCase().contains("yes")) {
          monu.add(bipin[i]);
        }
      }
    } else {
      for (int i = 0; i < bipin.length; ++i) {
        if (bipin[i]['available'].toString().toLowerCase().contains("no")) {
          monu.add(bipin[i]);
        }
      }
    }

    this.setState(() {
      mydata = monu;
    });
  }

  update(String id, String av) async {
    print("sending");
    String url = 'http://madhavapi.herokuapp.com/get/update';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"id":"$id" , "available":"$av" }';
    print(json); // make POST request
    Response response = await post(url,
        headers: headers, body: json); // check the status code for the result

    print(response.body);
  }

  logout() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("logged", "false");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  gotoimage(String url) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FullPage(
                  url: url,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Madhav Marble"),
        backgroundColor: Colors.black,
        actions: [
          GestureDetector(
            onTap: () {
              this.setState(() {
                loading = true;
              });
              getdata();
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: (loading == false)
                  ? Icon(
                      Icons.refresh,
                      color: Colors.white,
                    )
                  : CircularProgressIndicator(),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddProduct()));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: Text(
                  "Add Items",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 35),
                ),
              ),
            ),
            SizedBox(height: 32),
            GestureDetector(
              onTap: () {
                logout();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: Text(
                  "Log Out",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 35),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.only(left: 50, top: 15, right: 50),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(9)),
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextFormField(
                onFieldSubmitted: (ds) {
                  searchnow();
                },
                onChanged: (s) {
                  searchnow();
                },
                controller: searchController,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  hintText: " Search with Id",
                  focusColor: Colors.grey,
                  hoverColor: Colors.grey,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Text(
                "   Size ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(width: 64),
              Container(
                //  alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.5,
                child: DropdownButton(
                  items: items.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (val) {
                    this.setState(() {
                      sizesel = val;
                    });
                    searchnow();
                  },
                  value: sizesel,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "   Company ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(width: 13),
              Container(
                //  alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.5,
                child: DropdownButton(
                  items: companyList.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (val) {
                    this.setState(() {
                      companySelected = val;
                    });
                    searchnow();
                  },
                  value: companySelected,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "   Availability ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Container(
                //  alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.5,
                child: DropdownButton(
                  items: availability.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (val) {
                    this.setState(() {
                      selavail = val;
                    });
                    searchnow();
                  },
                  value: selavail,
                ),
              ),
              Text(
                mydata.length.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 10),
          (loading == true)
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 200),
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey,
                  ),
                )
              : Container(),
          (mydata.length != 0)
              ? Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    // physics: ,
                    itemCount: mydata.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          margin: EdgeInsets.only(bottom: 5),
                          color: Colors.black,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  gotoimage(mydata[index]['url']);
                                },
                                child: CachedNetworkImage(
                                  imageUrl: mydata[index]['url'],
                                  height: 150,
                                  width: 150,
                                ),
                              ),
                              SizedBox(width: 5),
                              Container(
                                width: MediaQuery.of(context).size.width - 155,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      mydata[index]['name'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 35,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      mydata[index]['company'],
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    Text(
                                      mydata[index]['size'],
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            final ConfirmAction action =
                                                await _asyncConfirmDialog(
                                                    context);
                                            if ("$action" ==
                                                'ConfirmAction.Accept') {
                                              deleteitem(mydata[index]['_id']);
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              "Delete",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 50),
                                      ],
                                    ),
                                    SizedBox(height: 13),
                                    GestureDetector(
                                      onTap: () async {
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => EditPage(
                                                      id: mydata[index]["_id"],
                                                      company: mydata[index]
                                                          ["company"],
                                                      name: mydata[index]
                                                          ["name"],
                                                      size: mydata[index]
                                                          ["size"],
                                                      imageUrl: mydata[index]
                                                          ["url"],
                                                    )));
                                        getdata();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          "Edit Name",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            final ConfirmAction2 action =
                                                await _asyncConfirmDialog2(
                                                    context);
                                            if ("$action" ==
                                                'ConfirmAction2.Accept') {
                                              print(mydata[index]);
                                              this.setState(() {
                                                if (mydata[index]
                                                        ["available"] ==
                                                    "yes")
                                                  mydata[index]["available"] =
                                                      "no";
                                                else
                                                  mydata[index]["available"] =
                                                      "yes";

                                                print(
                                                    mydata[index]["available"]);

                                                update(mydata[index]["_id"],
                                                    mydata[index]["available"]);
                                              });
                                            }
                                          },
                                          child: Container(
                                            color: (mydata[index]
                                                        ["available"] ==
                                                    "yes")
                                                ? Colors.green
                                                : Colors.red,
                                            height: 40,
                                            width: 40,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ));
                    },
                  ),
                )
              : Text("No Items Available"),
        ],
      ),
    );
  }
}

enum ConfirmAction { Cancel, Accept }
Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete This Tile?'),
        content: const Text('This will delete the Tile from your List.'),
        actions: <Widget>[
          FlatButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.Cancel);
            },
          ),
          FlatButton(
            child: const Text('Delete'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.Accept);
            },
          )
        ],
      );
    },
  );
}

enum ConfirmAction2 { Cancel, Accept }
Future<ConfirmAction2> _asyncConfirmDialog2(BuildContext context) async {
  return showDialog<ConfirmAction2>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm '),
        content: const Text('This will change your availability status'),
        actions: <Widget>[
          FlatButton(
            child: const Text('Confirm'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction2.Accept);
            },
          ),
          FlatButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction2.Cancel);
            },
          ),
        ],
      );
    },
  );
}
