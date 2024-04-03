// import 'package:another_carousel_pro/another_carousel_pro.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:dompatners/AllWigtes/Dialog.dart';
// import 'package:dompatners/providers/houseProvider.dart';

// import 'package:dompatners/screens/theDetails.dart';
// import 'package:dompatners/services/firebaseService.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:share/share.dart';

// class HouseCards extends StatefulWidget {
//   const HouseCards({
//     Key? key,
//     required this.data,
//   }) : super(key: key);

//   final DocumentSnapshot data;
//   @override
//   State<HouseCards> createState() => _HouseCardsState();
// }

// List<NetworkImage> _listOfImages = <NetworkImage>[];

// class _HouseCardsState extends State<HouseCards> {
//   FirebaseService _service = FirebaseService();
//   DocumentSnapshot? renterDetails;
//   String renterName = '';
//   bool _isLiked = false;
//   final _format = NumberFormat('##,###,###');
//   List fav = [];
//   @override
//   void initState() {
//     getRenterDatas();
//     getFavourite();
//     super.initState();
//   }

//   getRenterDatas() {
//     _service.getRenterData(widget.data['ownerId']).then((value) {
//       renterName = value['displayName'];
//       renterDetails = value;
//     });
//   }

//   getFavourite() {
//     _service.house.doc(widget.data.id).get().then((value) {
//       setState(() {
//         fav = value['favourites'];
//       });
//       if (fav.contains(_service.user!.uid)) {
//         setState(() {
//           _isLiked = true;
//         });
//       } else {
//         setState(() {
//           _isLiked = false;
//         });
//       }
//     });
//   }

//   int selectedindex = 1;
//   @override
//   Widget build(BuildContext context) {
//     var _provider = Provider.of<HouseProvider>(context);

//     _listOfImages = [];

//     int i;
//     var size = 0;
//     for (i = 0; i < widget.data['imageUrlList'].length; i++) {
//       _listOfImages.add(NetworkImage(widget.data['imageUrlList'][i]));

//       size = i + 1;
//     }

//     String _formatedBeiKodi = '\Tsh ${_format.format(widget.data['beiKodi'])}';

//     var format = DateFormat('yyyy-MM-dd hh:mm');
//     var rentorbuy = widget.data['rentOrBuy'];
//     var purpose = widget.data['purpose'];

//     var location = widget.data['location'];

//     String id = widget.data['HouseId'];
//     String titles = "$purpose for $rentorbuy";
//     String description = "TSH  $_formatedBeiKodi, at $location";
//     String image = widget.data['imageUrlList'][0].toString();

//     String _formatedBeiKod = '\TZS ${_format.format(widget.data['beiKodi'])}';
//     var purposes = widget.data['rentOrBuy'];
//     var item = widget.data['purpose'];
//     var bedRooms = widget.data['BedRooms'];
//     var master = widget.data['masterOrSingle'];
//     var square = widget.data['squareMeter'].toString();
//     String landproject = 'Land/plots';

//     return Container(
//       child: Padding(
//         padding: const EdgeInsets.only(bottom: 12.0),
//         child: Card(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           elevation: 2,
//           child: InkWell(
//             onTap: () async {
//               Navigator.of(context)
//                   .push(MaterialPageRoute(builder: (BuildContext context) {
//                 return TheDetais();
//               }));
//             },
//             child: Column(
//               children: [
//                 Stack(
//                   children: [
//                     SizedBox(
//                         height: 200.0,
//                         width: double.infinity,
//                         child: Carousel(
//                           autoplay: true,
//                           autoplayDuration: Duration(minutes: 30),
//                           onImageChange: (prev, next) {
//                             setState(() {
//                               selectedindex = next + 1;
//                             });
//                           },
//                           images: widget.data['imageUrlList'].map((url) {
//                             return ClipRRect(
//                               borderRadius: BorderRadius.circular(10),
//                               child: CachedNetworkImage(
//                                 imageUrl: url,
//                                 placeholder: (context, url) => Center(
//                                   child: CircularProgressIndicator(),
//                                 ),
//                                 errorWidget: (context, url, error) =>
//                                     Icon(Icons.error),
//                                 fit: BoxFit.fill,
//                                 fadeInCurve: Curves.easeIn,
//                                 fadeInDuration: Duration(seconds: 2),
//                                 fadeOutCurve: Curves.easeOut,
//                                 fadeOutDuration: Duration(seconds: 2),
//                               ),
//                             );
//                           }).toList(),
//                           dotSize: 4.0,
//                           dotSpacing: 15.0,
//                           dotColor: Colors.black,
//                           animationDuration: Duration(milliseconds: 1000),
//                           animationCurve: Curves.fastOutSlowIn,
//                           indicatorBgPadding: 5.0,
//                           dotBgColor: Colors.grey.withOpacity(0.1),
//                           borderRadius: true,
//                         )),
//                     Positioned(
//                       bottom: 2,
//                       left: 1,
//                       child: Row(
//                         children: [
//                           Text(
//                             "$selectedindex / $size",
//                             style: TextStyle(color: Colors.white),
//                           )
//                         ],
//                       ),
//                     ),
//                     Positioned(
//                       top: 3,
//                       left: 2,
//                       child: widget.data['promote'] == true
//                           ? Container(
//                               decoration: BoxDecoration(
//                                   color: Color(0xFFe26f39),
//                                   borderRadius: BorderRadius.circular(5)),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(5.0),
//                                 child: Text('Verfied',
//                                     style: TextStyle(
//                                       fontSize: 10,
//                                       letterSpacing: 1,
//                                       color: Colors.white,
//                                     )),
//                               ),
//                             )
//                           : Container(),
//                     ),
//                   ],
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                     left: 6.0,
//                     bottom: 0.0,
//                     top: 8.0,
//                     right: 8.0,
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("$item for $purposes",
//                           style: TextStyle(
//                             overflow: TextOverflow.ellipsis,
//                             fontSize: 13,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFFe26f39),
//                           )
//                           // style: TextStyle(
//                           //   fontSize: 16,
//                           //   fontWeight: FontWeight.bold,
//                           // ),
//                           ),
//                       Center(
//                         child: IconButton(
//                           iconSize: 16,
//                           onPressed: () async {
//                             var dynamicLink = await _service.createDynamicLink(
//                                 userName: id,
//                                 title: titles,
//                                 description: description,
//                                 image: image);

//                             Share.share("$dynamicLink");
//                           },
//                           icon: Icon(
//                             Icons.share,
//                             color: Color(0xFFe26f39),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                     left: 8.0,
//                     bottom: 6.0,
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       widget.data['purpose'] == landproject
//                           ? Row(
//                               children: [
//                                 Text(widget.data['spmResult'][0]['sqm']
//                                     .toString()),
//                                 Text(' Sqm  '),
//                                 Text(widget.data['spmResult'][0]['price']
//                                     .toString()),
//                                 Text("TZS")
//                               ],
//                             )
//                           : Text(
//                               '$_formatedBeiKod /month',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               // style: TextStyle(
//                               //     fontSize: 13,
//                               //     fontWeight: FontWeight.bold,
//                               //     color: Color(0xFF3D3D3D)
//                               //     )
//                             ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                     left: 8.0,
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Icon(
//                         Icons.location_on,
//                         size: 13,
//                         color: Color(0xFFe26f39),
//                       ),
//                       Flexible(
//                         child: Text(widget.data['location'],
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               fontSize: 12,
//                             )),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: widget.data['purpose'] == landproject
//                         ? Row(
//                             children: [
//                               Row(
//                                 children: [
//                                   Icon(
//                                     MdiIcons.road,
//                                     size: 14,
//                                     color: Color(0xFFe26f39),
//                                   ),
//                                   Row(
//                                     children: [
//                                       Text(' Roads',
//                                           style: TextStyle(
//                                             fontSize: 12,
//                                           )),
//                                     ],
//                                   )
//                                 ],
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 8.0),
//                                 child: Row(
//                                   children: [
//                                     Icon(
//                                       MdiIcons.water,
//                                       size: 14,
//                                       color: Color(0xFFe26f39),
//                                     ),
//                                     Row(
//                                       children: [
//                                         Text(' Water',
//                                             style: TextStyle(
//                                               fontSize: 12,
//                                             )),
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 8.0),
//                                 child: Row(
//                                   children: [
//                                     Icon(
//                                       MdiIcons.square,
//                                       size: 14,
//                                       color: Color(0xFFe26f39),
//                                     ),
//                                     Row(
//                                       children: [
//                                         Text(' Measured',
//                                             style: TextStyle(
//                                               fontSize: 12,
//                                             )),
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           )
//                         : Row(
//                             children: [
//                               Row(
//                                 children: [
//                                   Icon(
//                                     MdiIcons.bed,
//                                     size: 14,
//                                     color: Color(0xFFe26f39),
//                                   ),
//                                   Row(
//                                     children: [
//                                       Text('  $bedRooms',
//                                           style: TextStyle(
//                                             color: Color(0xFF3D3D3D),
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 12,
//                                           )),
//                                       Text(' Beds',
//                                           style: TextStyle(
//                                             fontSize: 12,
//                                           )),
//                                     ],
//                                   )
//                                 ],
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 8.0),
//                                 child: Row(
//                                   children: [
//                                     Icon(
//                                       MdiIcons.bathtub,
//                                       size: 14,
//                                       color: Color(0xFFe26f39),
//                                     ),
//                                     Row(
//                                       children: [
//                                         Text('  $bedRooms',
//                                             style: TextStyle(
//                                               color: Color(0xFF3D3D3D),
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 12,
//                                             )),
//                                         Text(' Bath',
//                                             style: TextStyle(
//                                               fontSize: 12,
//                                             )),
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 8.0),
//                                 child: Row(
//                                   children: [
//                                     Icon(
//                                       MdiIcons.square,
//                                       size: 14,
//                                       color: Color(0xFFe26f39),
//                                     ),
//                                     Row(
//                                       children: [
//                                         Text('   $square',
//                                             style: TextStyle(
//                                               color: Color(0xFF3D3D3D),
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 12,
//                                             )),
//                                         Text(' sqm',
//                                             style: TextStyle(
//                                               fontSize: 12,
//                                             )),
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           )),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       left: 8.0, bottom: 8, top: 5, right: 8),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           RatingBarIndicator(
//                             rating: 4.0,
//                             itemBuilder: (context, index) => Icon(
//                               Icons.star,
//                               color: Color(0xFFe26f39),
//                             ),
//                             itemCount: 5,
//                             itemSize: 17.0,
//                             direction: Axis.horizontal,
//                           ),
//                           Container(
//                               decoration: BoxDecoration(
//                                   color: Color(0xFFe26f39),
//                                   borderRadius: BorderRadius.all(
//                                     Radius.circular(7.0),
//                                   )),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(4.0),
//                                 child: Text(
//                                   '3.0',
//                                   style: TextStyle(
//                                       fontSize: 12, color: Colors.white),
//                                 ),
//                               ))
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Icon(
//                             MdiIcons.clock,
//                             size: 16,
//                             color: Color(0xFFe26f39),
//                           ),
//                           Text(readTimestamp2(widget.data['PostedAt']),
//                               style: TextStyle(
//                                 fontSize: 12,
//                               )),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//                 // Padding(
//                 //   padding: const EdgeInsets.only(
//                 //       left: 8.0, bottom: 8, top: 5, right: 8),
//                 //   child: Row(
//                 //     mainAxisAlignment: MainAxisAlignment.start,
//                 //     children: [
//                 //       // Text('Listed by ' + widget.data['PostedByOwner'],
//                 //       //     style: TextStyle(
//                 //       //       fontSize: 12,
//                 //       //     )),
//                 //       Icon(
//                 //         MdiIcons.clock,
//                 //         size: 16,
//                 //       ),
//                 //       Text(readTimestamp(widget.data['PostedAt']),
//                 //           style: TextStyle(
//                 //             fontSize: 12,
//                 //           )),
//                 //     ],
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
