import 'package:flutter/material.dart';
import 'dart:async';
import 'package:Deppannini/controllers/reclamationController.dart';
import 'package:Deppannini/models/Reclamation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Deppannini/models/LoginResponse.dart';


class liste_reclamations_view extends StatefulWidget {
  final LoginResponse loginResponse;
  liste_reclamations_view(this.loginResponse) : super();

  @override
  _liste_reclamations_viewState createState() => _liste_reclamations_viewState();
}

class _liste_reclamations_viewState extends State<liste_reclamations_view> {

  @override liste_reclamations_view get widget => super.widget;
  List<Reclamation> reclamations = [];
  List<Reclamation> reclamationsTemp = [];
  bool _isLoading = false;


  getReclamations() async
  {
    print("RECLAMATIOOOOONS " + widget.loginResponse.userId);
    reclamationsTemp = await reclamationController().getListeReclamationByUserId(widget.loginResponse.userId);

    setState(() {
      reclamations = reclamationsTemp;
    });


}
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      this.getReclamations();

    });

    if(reclamations != null) {
      setState(() {
        _isLoading = false;
      });

    } else {
      setState(() {
        _isLoading = true;
      });
    }

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:
      _isLoading ? Center(child: CircularProgressIndicator(backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFf1962d)))) :
      reclamations.length!=0 ?
      ListView.builder(
        physics: const BouncingScrollPhysics(), //ça fait le scroll du liste
        itemCount:reclamations.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            child: Row(
              children: [

                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: SizedBox(
                    child:new Wrap(
                      spacing: 5.0,
                      runSpacing: 5.0,
                      direction: Axis.vertical, // main axis (rows or columns)
                      children: <Widget>[
                        Row(
                          children: [
                            Text("Réclamation "+index.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFf1962d),
                                fontSize: 18.0,
                              ),),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Type : "+reclamations[index].type,
                              style: TextStyle(
                                color:Color(0xFF225088) ,
                                fontSize: 14.0,
                              ),),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Contenu : "+reclamations[index].contenu,
                              style: TextStyle(
                                color: Color(0xFF225088),
                                fontSize: 14.0,
                              ),),
                          ],
                        ),
                        reclamations[index].etat=="A Traiter" ? Row(
                          children: [
                            Text("Etat : En cours de traitement",
                              style: TextStyle(
                                color: Color(0xFF225088),
                                fontSize: 14.0,
                              ),),
                            SizedBox(
                              width: 100,
                            ),
                            Icon(
                              Icons.update ,
                              color: Color(0xFFf1962d),
                              size: 20,
                            ),
                          ],
                        ):
                        Row(
                          children: [
                            Text("Traité",
                              style: TextStyle(
                                color: Color(0xFF225088),
                                fontSize: 14.0,
                              ),),
                            SizedBox(
                              width: 130,
                            ),
                            Icon(
                              Icons.task_alt ,
                              color: Color(0xFFf1962d),
                              size: 20,
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ),
              ],
            ),
          );
        },
      ) :

      Container(
        margin: const EdgeInsets.only(left: 16, right: 16,top: 5),
        decoration: BoxDecoration(
          //color: Color(0xFFa2dae9).withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child:Column(
        children: [
        Image.asset(
          'assets/images/reclam.png',
          width: 200,
          height: 200,
        ),
          Text(
            "Vous n'avez pas de réclamations",
            style: TextStyle(
              color: Color(0xFF225088),
              fontSize: 20.0,
            ),
          ),
      ],
        ),
      ),

    );
  }
}

