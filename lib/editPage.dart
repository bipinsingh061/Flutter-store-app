import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';


class EditPage extends StatefulWidget {

  final String company ;
  String imageUrl;
  final String id;
   String name =' ';
  final String size;
  EditPage({this.id,this.name,this.size,this.company,this.imageUrl});
  @override
  _EditPageState createState() => _EditPageState(this.id,this.name,this.size,this.company,this.imageUrl);
}

class _EditPageState extends State<EditPage> {
 File photo;
TextEditingController productnameController = TextEditingController();
  String myimageUrl; 
  String sizesel = '2X4';
  String companySelected = "G.S.T.";
  String mysize ;
  String myid;
  String myname;
  String company;
   _EditPageState(this.myid,this.myname,this.mysize,this.company,this.myimageUrl) {
     sizesel=this.mysize;
     companySelected=this.company;
     productnameController.text = myname;
     myid=this.myid;
  }

  
  
  List<String> sizelist = [
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
  List<String> availabilityList = [
    'Available',
    'Not Available'
  ];
  bool loading =false ;
  String isAvailable = 'Available';

 

  List<String> companyList = ["G.S.T."];

  
  


  changenow(BuildContext context)async{
    this.setState(() {
      loading=true;
    });
  
      print("sending");
     String url = 'http://madhavapi.herokuapp.com/get/edit';
      Map<String, String> headers = {"Content-type": "application/json"};
      String json = '{"name":"${productnameController.text}" , "id":"${myid}" , "company":"${companySelected}","size":"${sizesel}" }';
      print(json); // make POST request
      Response response = await post(url,headers: headers, body: json); // check the status code for the result
     
     print(response.body);
     if(response.body=="success")
     {       
       Navigator.pop(context);
     }
        
        // request.fields["name"] = pname;
        // request.fields["id"]=myid;
        // request.fields["company"] = companySelected;
        // request.fields["size"] = sizesel ;
        this.setState(() {
      loading=false;
    });

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Container(
         
          padding: EdgeInsets.only(left: 40, right: 40),
          child: SingleChildScrollView(
                      child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Container(
                        height: 150,
                        width: 150,
                          decoration: BoxDecoration(
                              image: DecorationImage(image:CachedNetworkImageProvider( myimageUrl))
                              ),
                        ),
                TextFormField(
                  controller: productnameController,
                  
                  // initialValue: name,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: "Product Name",
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
                Container(
                  //  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: DropdownButton(
                    items: sizelist.map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (val) {
                      this.setState(() {
                        sizesel = val;
                      });
                    },
                    value: sizesel,
                  ),
                ),
                Container(
                  //  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.8,
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
                    },
                    value: companySelected,
                  ),
                ),
                // Container(
                //   //  alignment: Alignment.center,
                //   width: MediaQuery.of(context).size.width * 0.8,
                //   child: DropdownButton(
                //     items: availabilityList.map((String value) {
                //       return new DropdownMenuItem<String>(
                //         value: value,
                //         child: new Text(value),
                //       );
                //     }).toList(),
                //     onChanged: (val) {
                //       this.setState(() {
                //         isAvailable = val;
                //       });
                //     },
                //     value: isAvailable,
                //   ),
                // ),
                SizedBox(height: 30),
                (loading!=true)?GestureDetector(
                  onTap: (){
                    changenow(context);
                  },
                                child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      "Make Changes",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                  ),
                ):Container(),
                (loading==true)?Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey,
                  ),
                ):Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum ConfirmAction { Cancel, Accept}  
Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {  
  return showDialog<ConfirmAction>(  
    context: context,  
    barrierDismissible: false, // user must tap button for close dialog!  
    builder: (BuildContext context) {  
      return AlertDialog(  
        title: Text('Choose Where to Select Image From ?'),  
        content: const Text(  
            'choose :  '),  
        actions: <Widget>[  
            
          FlatButton(  
            child: const Text('Gallery'),  
            onPressed: () {  
              Navigator.of(context).pop(ConfirmAction.Accept);  
            },  
          )  ,
          FlatButton(  
            child: const Text('Camera'),  
            onPressed: () {  
              Navigator.of(context).pop(ConfirmAction.Cancel);  
            },  
          ),
        ],  
      );  
    },  
  );  
} 
