import'package:flutter/material.dart';
import'package:cloud_firestore/cloud_firestore.dart';
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
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context,int index){

                  return Text(snapshot.data.documents[index]['Description']);

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
              nameinput.clear();
              titleinput.clear();
              descinput.clear();
              Navigator.pop(context);
            },
            child: Text("Save")
        )
      ],


    ),


  );

  }
}
