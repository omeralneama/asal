import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/back_widget.dart';
import 'order_details_widget.dart';

class OrdersListDetails extends StatelessWidget {
  const OrdersListDetails({
    Key? key,
     required this.orderId,
  }) : super(key: key);
  final String orderId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').doc(orderId).collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data!.docs.isNotEmpty) {
              return Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:  snapshot.data!.docs.length,
                    itemBuilder: (ctx, index) {
                      return Column(
                        children: [
                          OrderDetailsWidget(
                            orderId: snapshot.data!.docs[index]['orderId'],
                            isPiece: snapshot.data!.docs[index]['isPiece'],
                            quantity: snapshot.data!.docs[index]['quantity'],
                            title: snapshot.data!.docs[index]['title'],
                            price: snapshot.data!.docs[index]['price'],
                            singleSalePrice: snapshot.data!.docs[index]['singleSalePrice'],
                            singlePrice:snapshot.data!.docs[index]['singlePrice'],
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                        ],
                      );
                    }),
              );
            } else {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text('Your store is empty'),
                ),
              );
            }
          }
          return const Center(
            child: Text(
              'Something went wrong',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          );
        },
      ),
    );
  }
}