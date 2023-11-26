import 'package:get/get.dart';
import 'package:treka/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:treka/services/call_sms.dart';
import '../helpers/style.dart';
import 'custom_text.dart';

class RiderWidget extends StatelessWidget {
  AppStateProvide appState = Get.put(AppStateProvide());

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        expand: true,
        initialChildSize: 0.1,
        minChildSize: 0.05,
        maxChildSize: 0.6,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(color: white,
//                        borderRadius: BorderRadius.only(
//                            topLeft: Radius.circular(20),
//                            topRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: grey.withOpacity(.8),
                      offset: Offset(3, 2),
                      blurRadius: 7)
                ]),
            child: ListView(
              controller: scrollController,
              children: [
                SizedBox(
                  height: 12,
                ),
                ListTile(
                  //TODO:Check this phone number but i have not seen one yet
                  leading: Container(
                    child: appState.riderModel.phone == null
                        ? CircleAvatar(
                            radius: 30,
                            child: Icon(
                              Icons.person_outline,
                              size: 25,
                            ),
                          )
                        : CircleAvatar(
                            radius: 30,
                            child: Icon(
                              Icons.person_outline,
                              size: 25,
                            ),
                            // backgroundImage: NetworkImage(appState.riderModel?.photo),
                          ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: appState.riderModel.name + "\n",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: appState.rideRequestModel.destination,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w300)),
                      ], style: TextStyle(color: black))),
                    ],
                  ),
                  trailing: Container(
                      decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20)),
                      child: IconButton(
                        onPressed: () {
                          print('${appState.riderModel.phone}pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp');
                          CallsAndMessagesService().call(appState.riderModel.phone);
                        },
                        icon: Icon(Icons.call),
                      )),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: CustomText(
                    text: "Ride details",
                    size: 18,
                    weight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 100,
                      width: 10,
                      child: Column(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: grey,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 9),
                            child: Container(
                              height: 45,
                              width: 2,
                              color: primary,
                            ),
                          ),
                          Icon(Icons.flag),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "\nPick up location \n",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      TextSpan(
                          text: "25th avenue, flutter street \n\n\n",
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 16)),
                      TextSpan(
                          text: "Destination \n",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      TextSpan(
                          text: "${appState.rideRequestModel.destination} \n",
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 16)),
                    ], style: TextStyle(color: black))),
                  ],
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ElevatedButton(
                    onPressed: () {},
                    // color: red,
                    child: CustomText(
                      text: "Cancel Ride",
                      color: white,
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
