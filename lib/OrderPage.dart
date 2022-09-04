
import 'dart:convert';

import 'package:blogapp/payment/gateway/PaymentScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:invoiceninja/invoiceninja.dart';
import 'package:invoiceninja/models/client.dart';
import 'package:invoiceninja/models/invoice.dart';
import 'package:invoiceninja/models/product.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'BankCardDetails/Add.dart';
import 'BankCardDetails/Model.dart';
import 'BankCardDetails/dbCard.dart';


class OrderPage extends StatefulWidget {
  final String total;
  OrderPage(
      {
        @required this.total});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with WidgetsBindingObserver {
  String _value;
  List<Product> _products = [];
  FlutterSecureStorage storage = FlutterSecureStorage();
  DatabaseHandler handler;
  Future<List<todo>> _todo;
  TextEditingController _address = TextEditingController();
  TextEditingController _contact1 = TextEditingController();
  TextEditingController _contact = TextEditingController();
  sendtoOrder(String address,String contact,String contact1)async{

    String token = await storage.read(key: "token");
    print(token);
    print(address);
    print(contact);
    final body = {
      "contactNumber": contact,
      "address":address,
      "additionalPhoneNumber":contact1,

    };
    http.post("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/cartItems/sendCartitemsToShopOrders",body:jsonEncode(body),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },

    ).then((response) {
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        // Do the rest of job here
      }
    });
  }
  String _email = '';
  Product _product;
  Invoice _invoice;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    handler = DatabaseHandler();
    handler.initializeDB().whenComplete(() async {
      setState(() {
        _todo = getList();
      });
    });
    InvoiceNinja.configure(
      'KEY', // Set your company key or use 'KEY' to test
      url: 'https://demo.invoiceninja.com', // Set your selfhost app URL
      debugEnabled: true,
    );

    InvoiceNinja.products.load().then((products) {
      setState(() {
        _products = products;
      });
    });
  }
  Future<List<todo>> getList() async {
    return await handler.todos();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _todo = getList();
    });
  }

  void _createInvoice() async {
    if (_product == null) {
      return;
    }
    var client = Client.forContact(email: _email);
    client = await InvoiceNinja.clients.save(client);

    var invoice = Invoice.forClient(client, products: [_product]);
    invoice = await InvoiceNinja.invoices.save(invoice);

    setState(() {
      _invoice = invoice;
    });
  }

  void _viewPdf() {
    if (_invoice == null) {
      return;
    }


    launch(
      'https://docs.google.com/gview?embedded=true&url=${_invoice.pdfUrl}',
      forceWebView: true,
    );
  }

  void _viewPortal() {
    if (_invoice == null) {
      return;
    }

    final invitation = _invoice.invitations.first;
    launch(invitation.url);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (_invoice == null || state != AppLifecycleState.resumed) {
      return;
    }

    final invoice = await InvoiceNinja.invoices.findByKey(_invoice.key);

    if (invoice.isPaid) {
      // ...
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:Text("Total:${widget.total}"),
          actions: [
            IconButton(
                icon: Icon(Icons.credit_card, color: Colors.blue),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddScreen(),
                      ));
                }),
            /*  IconButton(
              icon: Icon(Icons.credit_card, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListScreen(),
                    ));
              }),*/
          ],
        ),
        body:  new Builder(
            builder: (BuildContext context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: FutureBuilder<List<todo>>(
                      future: _todo,
                      builder: (BuildContext context, AsyncSnapshot<List<todo>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return new Center(
                            child: new CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return new Text('Error: ${snapshot.error}');
                        } else {
                          final items = snapshot.data ?? <todo>[];
                          return new Scrollbar(
                            child: RefreshIndicator(
                              onRefresh: _onRefresh,
                              child: ListView.builder(

                                itemCount: items.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Dismissible(
                                    direction: DismissDirection.startToEnd,
                                    background: Container(
                                      margin: EdgeInsets.all(10),
                                      color: Colors.red,
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                      child: const Icon(Icons.delete_forever),
                                    ),
                                    key: ValueKey<int>(items[index].id),
                                    onDismissed: (DismissDirection direction) async {
                                      await handler.deletetodo(items[index].id);
                                      setState(() {
                                        items.remove(items[index]);
                                      });
                                    },
                                    child: Container(
                                      height: 200,
                                      margin: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                            image: NetworkImage("https://source.unsplash.com/random?sig=$index"),
                                            fit:BoxFit.cover
                                        ),
                                      ),
                                      child: Card(
                                          color: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15.0),
                                          ),
                                          child: ListTile(
                                            trailing:Radio(
                                                value:"${items[index].title}\n${items[index].description.toString()}",
                                                groupValue: _value,
                                                onChanged: (value){
                                                  setState(() {
                                                    _value=value;
                                                   // changePayment(_cartitems[index]['_id'],"Takeway");
                                                  });
                                                  print(_value.substring(19,25)); //selected value
                                                }
                                            ),
                                            contentPadding: const EdgeInsets.all(8.0),
                                            title: Text(items[index].title,style: TextStyle(color:Colors.white),),
                                            subtitle: Text(items[index].description.toString(),style: TextStyle(color:Colors.white)),
                                          )),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child:   Stepper(
                      steps: _mySteps(),
                      currentStep: this._currentStep,
                      onStepTapped: (step){
                        setState(() {
                          this._currentStep = step;
                        });},
                      onStepContinue: (){
                        setState(() {
                          if(this._currentStep < this._mySteps().length - 1){
                            this._currentStep = this._currentStep + 1;
                          }else{
                            setState(() {
                            //  sendtoOrder(_address.text,_contact.text,_contact1.text);
                            });

                            //Logic to check if everything is completed
                           Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Payment(amount:"${widget.total}",cardNo:"${_value.substring(0,19)}",expiredate:"${_value.substring(19,25)}"),
                            ));
                            print('Completed, check fields.');
                          }
                        });
                      },
                      onStepCancel: () {
                        setState(() {
                          if(this._currentStep > 0){
                            this._currentStep = this._currentStep - 1;
                          }else{
                            this._currentStep = 0;
                          }
                        });
                      },
                    ),
                  ),

                ],
              );
            }
        )
    );









  }
  List<Step> _mySteps(){
    List<Step> _steps = [
      Step(
        title: Text('Step 1'),
        content: TextField(
          controller: _address,
          decoration: InputDecoration(
            hintText: "Address",
          ),
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: Text('Step 2'),
        content: TextField(
          controller: _contact,
          decoration: InputDecoration(
            hintText: "ContactNo",
          ),
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: Text('Step 3'),
        content: TextField(

          decoration: InputDecoration(
            hintText: "Addtional Contact No",
          ),
          controller: _contact1,
        ),
        isActive: _currentStep >= 2,
      )
    ];
    return _steps;
  }
}