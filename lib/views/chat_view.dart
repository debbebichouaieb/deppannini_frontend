import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/io.dart';
import 'package:Deppannini/environnement/variables.dart';
import 'package:Deppannini/models/SimpleUser.dart';
import 'package:Deppannini/controllers/userController.dart';
import 'package:Deppannini/models/FournisseurService.dart';
import 'package:Deppannini/controllers/fournisseurServiceController.dart';


class ChatPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ChatPageState();
  }
}

class ChatPageState extends State<ChatPage>{

  IOWebSocketChannel channel; //channel varaible for websocket
  bool connected;
  // boolean value to track connection status
  SimpleUser user;
  SimpleUser userTemp;

  String myid = null; //my id
  String recieverid = null;
  //reciever id
  // swap myid and recieverid value on another mobile to test send and recieve
  String auth = "chatapphdfgjd34534hjdfk"; //auth key

  List<MessageData> msglist = [];

  TextEditingController msgtext = TextEditingController();
  String adresseIP = variables().adresseIP;
  String username=null;

  checkStatus() async {
    final Map arguments = ModalRoute.of(context).settings.arguments ;
    print(arguments);
    if (arguments != null) {

      userTemp=await userController().getConnectedUserV3(arguments['idUser']);

      setState(() {
        user= userTemp;
        myid=user.id;
        username=user.username;
        recieverid = arguments['id'];
        print("IDDDDDDDDDDDD  "+myid);
        print("recieverid  "+recieverid);
        this.channelconnect();


      });

    }
  }

  @override
  void initState() {
    connected = false;
    msgtext.text = "";
    Future.delayed(Duration.zero, () {
      this.checkStatus();

    });


    super.initState();
  }

  channelconnect(){ //function to connect
    try{
      print("MYYYYYYYYYYYY +$myid");
      channel = IOWebSocketChannel.connect("ws://"+adresseIP+":6060/$myid/$recieverid"); //channel IP : Port
      channel.stream.listen((message) {
        print(message);
        setState(() {
          if(message == "connected"){
            connected = true;
            setState(() { });
            print("Connection establised.");
          }else if(message == "send:success"){
            print("Message send success");
            setState(() {
              msgtext.text = "";
            });
          }else if(message == "send:error"){
            print("Message send error");
          }else if (message.substring(0, 6) == "{'cmd'") {
            print("Message data");
            message = message.replaceAll(RegExp("'"), '"');
            var jsondata = json.decode(message);

            msglist.add(MessageData( //on message recieve, add data to model
              msgtext: jsondata["msgtext"],
              userid: jsondata["userid"],
              isme: false,
            )
            );
            setState(() { //update UI after adding data to message model

            });
          }
        });
      },
        onDone: () {
          //if WebSocket is disconnected
          print("Web socket is closed");
          setState(() {
            connected = false;
          });
        },
        onError: (error) {
          print(error.toString());
        },);
    }catch (_){
      print("error on connecting to websocket.");
    }
  }

  Future<void> sendmsg(String sendmsg, String id) async {
    if(connected == true){
      String msg = "{'auth':'$auth','cmd':'send','userid':'$id', 'msgtext':'$sendmsg'}";
      setState(() {
        msgtext.text = "";
        msglist.add(MessageData(msgtext: sendmsg, userid: myid, isme: true));
      });
      channel.sink.add(msg); //send message to reciever channel
    }else{
      channelconnect();
      print("Websocket is not connected.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "$username est connect??  ",
                style: TextStyle(fontSize: 20,color: Color(0xFFf1962d))
              ),

              WidgetSpan(
                child: Icon(Icons.circle, color: connected?Colors.greenAccent:Colors.redAccent),
              ),

            ],
          ),
        ),
        //leading: Icon(Icons.circle, color: connected?Colors.greenAccent:Colors.redAccent),
        //if app is connected to node.js then it will be gree, else red.
        titleSpacing: 0,
        backgroundColor: Color(0xfff7f6fb),
        iconTheme: IconThemeData(
          color: Colors.grey, //change your color here
        ),
      ),
      body: Container(
        child: Stack(children: [
          Positioned(
            top:0,bottom:70,left:0, right:0,
            child:Container(
              padding: EdgeInsets.all(15),
              child: SingleChildScrollView(
                child:Column(children: [

                  Container(
                    child:Text("Messages", style: TextStyle(fontSize: 20,color: Color(0xFF225088))),
                  ),

                  Container(
                    child: Column(
                      children: msglist.map((onemsg){
                        return Container(
                          margin: EdgeInsets.only( //if is my message, then it has margin 40 at left
                            left: onemsg.isme?40:0,
                            right: onemsg.isme?0:40, //else margin at right
                          ),
                          child: Card(
                            color: onemsg.isme? Colors.blue[100]:Colors.orange[100],
                            //if its my message then, blue background else red background
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(15),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Container(
                                    child:Text(onemsg.isme?"ID: ME":"ID: " + onemsg.userid)
                                  ),

                                  Container(
                                    margin: EdgeInsets.only(top:10,bottom:10),
                                    child: Text("Message: " + onemsg.msgtext, style: TextStyle(fontSize: 17)),
                                  ),

                                ],),
                            )
                          )
                        );
                      }).toList(),
                    )
                  )
                ],)
              )
            )
          ),

          Positioned(  //position text field at bottom of screen

            bottom: 0, left:0, right:0,
            child: Container(
              color: Colors.grey.shade200,
              height: 70,
              child: Row(children: [

                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: TextField(
                      controller: msgtext,
                      decoration: InputDecoration(
                        hintText: "Enter your Message"
                      ),
                    ),
                  )
                ),

                Container(
                  margin: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue[100]),
                      ),
                    child:Icon(Icons.send),
                    onPressed: (){
                      if(msgtext.text != ""){
                        sendmsg(msgtext.text, recieverid); //send message with webspcket
                      }else{
                        print("Enter message");
                      }
                    },
                  )
                )
              ],)
            ),
          )
        ],)
      )
    );
  }
}

class MessageData{ //message data model
  String msgtext, userid;
  bool isme;
  MessageData({this.msgtext, this.userid, this.isme});

}
