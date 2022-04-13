import 'package:flutter/material.dart';
import 'package:Deppannini/controllers/fournisseurServiceController.dart';
import 'dart:async';
import 'package:Deppannini/controllers/reservationController.dart';
import 'package:Deppannini/controllers/userController.dart';
import 'package:Deppannini/models/FournisseurService.dart';
import 'package:Deppannini/models/Reclamation.dart';
import 'package:Deppannini/models/Reservation.dart';
import 'package:Deppannini/models/SimpleUser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Deppannini/models/LoginResponse.dart';


class liste_reservations_view extends StatefulWidget {
  final LoginResponse loginResponse;
  liste_reservations_view(this.loginResponse) : super();

  @override
  _liste_reservations_viewState createState() => _liste_reservations_viewState();
}

class _liste_reservations_viewState extends State<liste_reservations_view> {

  @override liste_reservations_view get widget => super.widget;
  List<Reservation> reservations = [];
  List<Reservation> reservationsTemp = [];
  bool _isLoading = false;



  getReservations() async
  {
    print("RECLAMATIOOOOONS " + widget.loginResponse.role);
    if(widget.loginResponse.role=='User')
      {
        reservationsTemp = await reservationController().getListeReservationByUserId(widget.loginResponse.userId);
        print("reservationssssssssss1111 "+reservationsTemp.toString());
        setState(() {
          reservations = reservationsTemp;
        });
        //print("reservationssssssssss1111 "+reservations.toString());

      }else
        {


          String fournisseur_id=await fournisseurServiceController().getFournisseurServiceByUserId(widget.loginResponse.userId);
          print("fournisseur_id " + fournisseur_id);
          reservationsTemp = await reservationController().getListeReservationByFournisseurId(fournisseur_id,widget.loginResponse.userId);

          setState(() {
            reservations = reservationsTemp;
          });

          print("reservationssssssssss2222 "+reservations.toString());
        }
  }


  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      this.getReservations();

    });

    if(reservations != null) {
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
      reservations.length!=0 ?
      ListView.builder(
        physics: const BouncingScrollPhysics(), //ça fait le scroll du liste
        itemCount:reservations.length,
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
                            Text("Réservation "+index.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFf1962d),
                                fontSize: 18.0,
                              ),),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Etat : "+reservations[index].etat,
                              style: TextStyle(
                                color:Color(0xFF225088) ,
                                fontSize: 14.0,
                              ),),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Rendez-vous est le "+reservations[index].dateReservation+" à "+reservations[index].timeslot+" HH ",
                              style: TextStyle(
                                color: Color(0xFF225088),
                                fontSize: 14.0,
                              ),),
                          ],
                        ),
                        widget.loginResponse.role=='User' ?
                         Row(
                          children: [
                            Text("Fournisseur  "+reservations[index].user.username,
                              style: TextStyle(
                                color: Color(0xFF225088),
                                fontSize: 14.0,
                              ),),
                            SizedBox(
                              width: 100,
                            ),

                          ],
                        ) :
                        Row(
                          children: [
                            Text("Utilisateur "+reservationsTemp[index].user.username,
                              style: TextStyle(
                                color: Color(0xFF225088),
                                fontSize: 14.0,
                              ),),
                            SizedBox(
                              width: 100,
                            ),

                          ],
                        ),
                      ],
                    ),
                  )
                ),
              ],
            ),
          );
        },
      )

      : Container(
        margin: const EdgeInsets.only(left: 16, right: 16,top: 5),
        decoration: BoxDecoration(
          //color: Color(0xFFa2dae9).withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child:Column(
          children: [
           /* Image.asset(
              'assets/images/reclam.png',
              width: 200,
              height: 200,
            ),*/
           SizedBox(
             height: 120,
           ),
            Text(
              "Vous n'avez pas de réservations",
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

