import'package:flutter/material.dart';
import'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var firestoredb=FirebaseFirestore.instance.collection("Board").snapshots();
  late TextEditingController nameinput=new TextEditingController();
  late TextEditingController titleinput=new TextEditingController();
  late TextEditingController descinput=new TextEditingController();


  @override
  void initState() {

    super.initState();
    nameinput=new TextEditingController();
    titleinput=new TextEditingController();
    descinput=new TextEditingController();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BORAD DATA"),
      ),
      floatingActionButton: FloatingActionButton(

        onPressed: (){
              showDialogox(context);
        },
        child: Icon(Icons.edit),
      ),


      body:StreamBuilder(
        stream: firestoredb,
        builder: (context,AsyncSnapshot snapshot){
          if(!(snapshot.hasData)){

            return CircularProgressIndicator();
          }
          else{

            return ListView.builder(
                itemCount: snapshot.data?.documents.length,
                itemBuilder: (context,int index){

                  return CustomCard(snapshot:snapshot.data,index:index);

                }

            );

          }



        },


      )

    );
  }
  
  showDialogox(BuildContext context)async
  {
    await showDialog(
      context: context,
    builder: (context) => AlertDialog(
      contentPadding:EdgeInsets.all(12) ,
      content:Column(
        children: [
          Text("ENTER THE REQUIRED FEILDS"),
          Expanded(
              child: TextField(
                autofocus: true,
                autocorrect: true,
                  decoration: InputDecoration(
                    labelText: "Your Name"

                  ),
                controller: nameinput,

              )

          ),

          Expanded(
              child: TextField(
                autofocus: true,
                autocorrect: true,
                decoration: InputDecoration(
                    labelText: "Title"

                ),
                controller: titleinput,

              )

          ),

          Expanded(
              child: TextField(
                autofocus: true,
                autocorrect: true,
                decoration: InputDecoration(
                    labelText: "Description: "

                ),
                controller: descinput,

              )

          )


        ],


      ),
      actions: [
        ElevatedButton(
            onPressed: (){
              nameinput.clear();
              titleinput.clear();
              descinput.clear();
              Navigator.pop(context);
            },
            child: Text("Cancel")
        )
,
        ElevatedButton(
            onPressed: (){
              if(nameinput.text.isNotEmpty && titleinput.text.isNotEmpty && descinput.text.isNotEmpty){
                  FirebaseFirestore.instance.collection("Board")
                      .add(
                    {
                      "name":nameinput.text,
                      "Description":descinput.text,
                      "Title":titleinput.text,
                      "timestamp":new DateTime.now()
                    }

                  ).then((response) => print(response.documentID));
                  //snackbar "ADD SUCCESSFULLY"
                  Navigator.pop(context);
                  nameinput.clear();
                  titleinput.clear();
                  descinput.clear();
              }
            },
            child: Text("Save")
        )
      ],


    ),


  );

  }
}

class CustomCard extends StatelessWidget {
  final int index;
  final QuerySnapshot snapshot;
  const CustomCard({Key? key,required this.snapshot,required this.index}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    //var timetoDate=new DateTime.now();
     var td=DateTime.fromMillisecondsSinceEpoch(snapshot.docs[index]["timestamp"].seconds*1000);
    var dateformat=new DateFormat("EEEE,MMM,d,y").format(td);

    return 
      
      Container(
      height: 120,
        child: Card(
          elevation: 10,
          child: Column(
          children: [

                 ListTile(
                  title: Text(snapshot.docs[index]["Title"]),
                  subtitle: Text(snapshot.docs[index]["Description"]),
                  leading: CircleAvatar(
                    radius: 35,
                      child: Text(snapshot.docs[index]["Title"].toString()[0].toUpperCase()),

                  ),
                ),

                Row(

                  children: [
                    Text("BY: ${snapshot.docs[index]["name"]}  "),
                    Text(dateformat),
                  ],
                )
              //Text((snapshot.docs[index]["timestamp"]==null)?"NA":snapshot.docs[index]["timestamp"].toString())

          ],




    ),
        ),
      );
  }
}

