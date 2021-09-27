import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';


class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  
  TextEditingController productnameController = TextEditingController();

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

  File photo;
  final picker = ImagePicker();

  List<String> companyList = ["G.S.T."];
  String companySelected = "G.S.T.";
  String sizesel = '2X4';

  
  resetnow(){
    this.setState((){
             companySelected = "G.S.T.";
             sizesel = '2X4';
             isAvailable = 'Available';
             photo = null;
             productnameController.text='';
    });
  }

  Future getimage(ImageSource king) async {
    print("selecting");
    final  pickedFile = await picker.getImage(source: king,imageQuality:85);
        //  File nextre = await FlutterImageCompress.compressWithFile(pickedFile.path);
      //  File result =   await FlutterImageCompress.compressAndGetFile(pickedFile.path, "king.jpeg",quality: 50);
      // print(pickedFile)
    setState(() {
      photo = File(pickedFile.path);
    });
  }

  addnow()async{
  
      
    String pname= productnameController.text;
    if(pname!=''&&photo!=null){
        this.setState(() {
      loading=true;
    });
      var request = MultipartRequest("POST", Uri.parse("http://madhavapi.herokuapp.com/material"));
        
        request.fields["name"] = pname;

        request.fields["available"] = "yes";
        request.fields["company"] = companySelected;
        request.fields["size"] = sizesel ;

        if (photo != null) {
          var pic = await MultipartFile.fromPath("fil1", photo.path);
          request.files.add(pic);
        }
        print(request.fields);
        print(request.files);
        print(request);
        // showloading(context, "Updating Profile");
        var response = await request.send();
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        print(responseString);
          resetnow();
        this.setState(() {
          loading=false;
        });


    }else{

    }
  
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Container(
         
          padding: EdgeInsets.only(left: 40, right: 40),
          child: SingleChildScrollView(
                      child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: ()async {
                    final ConfirmAction action = await _asyncConfirmDialog(context);  
                                       if("$action"=='ConfirmAction.Accept')
                                       {
                                        getimage(ImageSource.gallery);
                                       }
                                       else if("$action"=='ConfirmAction.Cancel')
                                       {
                                         getimage(ImageSource.camera);
                                       }
                    // getImageFromCamera();
                    // getimage();
                  },
                  child: (photo == null)
                      ? Container(
                          child: Icon(
                            Icons.photo_camera,
                            size: 50,
                          ),
                        )
                      : Container(
                        height: 150,
                        width: 150,
                          decoration: BoxDecoration(
                              image: DecorationImage(image: FileImage(photo))
                              ),
                        ),
                ),
                TextFormField(
                  controller: productnameController,
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
                  onTap: addnow,
                                child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      "Submit",
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
