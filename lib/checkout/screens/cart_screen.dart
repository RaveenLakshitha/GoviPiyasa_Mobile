import 'package:blogapp/Pdf/pdf.dart';
import 'package:blogapp/checkout/models/orders.dart';
import 'package:blogapp/payment/gateway/PaymentScreen.dart';


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../mainpage.dart';
import '../models/cart.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyApp1()));
            }),
        backgroundColor: Colors.lightGreen,
        title: Text(
          'My Cart',
          style: TextStyle(fontSize: 20, color: Theme.of(context).accentColor),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (ctx, i) => CartPdt(
                    cart.items.values.toList()[i].id,
                    cart.items.keys.toList()[i],
                    cart.items.values.toList()[i].price,
                    cart.items.values.toList()[i].quantity,
                    cart.items.values.toList()[i].name)),
          ),
     /*     CheckoutButton(
            cart: cart,
          ),*/
          cart.items.length!=0?
          OutlinedButton(
            style:OutlinedButton.styleFrom(
              padding:const EdgeInsets.symmetric(horizontal: 40),
              shape:RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

            ),

            onPressed:(){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>   Payment(),
                  ));


            },
            child:Text("Checkout",style:TextStyle(
              fontSize: 16,
              letterSpacing: 2.2,
              color:Colors.black,
            )),

          ):
          FlatButton(
               onPressed: () {

                 Fluttertoast.showToast(
                   msg: "Cart is empty",
                   toastLength: Toast.LENGTH_SHORT,
                   gravity: ToastGravity.BOTTOM,
                   backgroundColor: Colors.red,
                   textColor: Colors.white,
                   fontSize: 16.0,
                 );
              },
             child: Text(
                'No More items',
                 style: TextStyle(color: Colors.blue, fontSize: 20),
             )),
          SizedBox(height: 10.0,),
        ],
      ),
    );
  }
}

class CheckoutButton extends StatefulWidget {
  final Cart cart;

  const CheckoutButton({@required this.cart});
  @override
  _CheckoutButtonState createState() => _CheckoutButtonState();
}

//Pdf(amount:"${widget.cart.totalAmount}")
class _CheckoutButtonState extends State<CheckoutButton> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text('Checkout'),
      onPressed: widget.cart.totalAmount <= 0
          ?   Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>    Payment(amount:"${widget.cart.totalAmount}"),
          ))
          : () async {
              await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cart.items.values.toList(), widget.cart.totalAmount);
              widget.cart.clear();
            },
    );
  }
}
