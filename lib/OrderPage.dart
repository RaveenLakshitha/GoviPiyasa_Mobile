
import 'package:blogapp/payment/gateway/PaymentScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:invoiceninja/invoiceninja.dart';
import 'package:invoiceninja/models/client.dart';
import 'package:invoiceninja/models/invoice.dart';
import 'package:invoiceninja/models/product.dart';
import 'package:url_launcher/url_launcher.dart';
import 'BankCardDetais/Add.dart';
import 'BankCardDetais/CardList.dart';

class OrderPage extends StatefulWidget {
  OrderPage({Key key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with WidgetsBindingObserver {
  List<Product> _products = [];

  String _email = '';
  Product _product;
  Invoice _invoice;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title:Text("Order Details"),
        actions: [
          IconButton(
              icon: Icon(FontAwesomeIcons.plus, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddScreen(),
                    ));
              }),
          IconButton(
              icon: Icon(FontAwesomeIcons.circle, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListScreen(),
                    ));
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      suffixIcon: Icon(Icons.email),
                    ),
                    onChanged: (value) => setState(() => _email = value),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  DropdownButtonFormField<Product>(
                    decoration: InputDecoration(
                      labelText: 'Product',
                    ),
                    onChanged: (value) => setState(() => _product = value),
                    items: _products
                        .map((product) => DropdownMenuItem(
                      child: Text(product.productKey),
                      value: product,
                    ))
                        .toList(),
                  ),
                  SizedBox(height: 16),
                  OutlineButton(
                    child: Text('Create Invoice'),
                    onPressed: (_email.isNotEmpty && _product != null)
                        ? () => _createInvoice()
                        : null,
                  ),
                  OutlineButton(
                    child: Text('View PDF'),
                    onPressed: (_invoice != null) ? () => _viewPdf() : null,
                  ),
                  OutlineButton(
                    child: Text('View Portal'),
                    onPressed: (_invoice != null) ? () => _viewPortal() : null,
                  ),
                  OutlineButton(
                    child: Text('checkout'),
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>   Payment(amount:"900",
                            cardNo:"411111111511",
                            expiredate:"09/26"),
                          ));
                    }
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}