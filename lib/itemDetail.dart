import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ItemDetail extends StatefulWidget {
  final String size;
  ItemDetail({this.size});
  @override
  _ItemDetailState createState() => _ItemDetailState(this.size);
}

class _ItemDetailState extends State<ItemDetail> {
  String mysize;
  List mydata = [];
  List power = [];
  _ItemDetailState(this.mysize) {
    getdata();
  }

  bool loading =true;

  getdata() async {
   
    
    print("sending");
    String url = 'http://madhavapi.herokuapp.com/get/size';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"size":"$mysize"}';
    print(json); // make POST request
    Response response = await post(url,
        headers: headers, body: json); // check the status code for the result
    print(response.body);
    var d = jsonDecode(response.body);
    this.setState(() {
      mydata = d['data'];
      power = d['data'];
      loading=false;
    });
   
  }

  searchnow(String text) {
    print("searching");
    print(text);
    List temp = [];
    if (text == '') {
      this.setState(() {
        mydata = power;
      });
    } else {
      print("else");
      for (int i = 0; i < power.length; ++i) {
        if (power[i]["name"]
            .toLowerCase()
            .toString()
            .contains(text.toLowerCase())) {
          print("assed");
          temp.add(power[i]);
        }
      }
      this.setState(() {
        mydata = temp;
      });
    }
  }

  TextEditingController searchController = TextEditingController();


  update(String id, String av) async {
    //  this.setState(() {
    //    loading=true;
    //  });

    print("sending");
    String url = 'http://madhavapi.herokuapp.com/get/update';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"id":"$id" , "available":"$av" }';
    print(json); // make POST request
    Response response = await post(url,
        headers: headers, body: json); // check the status code for the result

    // print(response.body);
    // this.setState(() {
    //    loading=false;
    //  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(mysize),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 50, top: 15, right: 50),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(9)),
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextFormField(
                controller: searchController,
                onFieldSubmitted: (s) {
                  searchnow(s);
                },
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  hintText: " Search",
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
          SizedBox(height: 10),
           (loading==true)?Padding(
            padding: const EdgeInsets.only(bottom : 200),
            child: CircularProgressIndicator(
              backgroundColor: Colors.grey,
            ),
          ):Container(),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: mydata.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    margin: EdgeInsets.only(bottom: 5),
                    color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.network(
                          mydata[index]['url'],
                          height: 150,
                          width: 150,
                        ),
                        SizedBox(width: 5),
                        Container(
                          width: MediaQuery.of(context).size.width - 155,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      print(mydata[index]);
                                      this.setState(() {
                                        if (mydata[index]["available"] == "yes")
                                          mydata[index]["available"] = "no";
                                        else
                                          mydata[index]["available"] = "yes";

                                        print(mydata[index]["available"]);

                                        update(mydata[index]["_id"],
                                            mydata[index]["available"]);
                                      });
                                    },
                                    child: Container(
                                      color:
                                          (mydata[index]["available"] == "yes")
                                              ? Colors.green
                                              : Colors.red,
                                      height: 40,
                                      width: 40,
                                    ),
                                  )
                                ],
                              ),
                              
                            ],
                          ),
                        ),
                        
                      ],
                    ));
                    
              },
            ),
            
          ),
         
          
        ],
      ),
    );
  }
}
