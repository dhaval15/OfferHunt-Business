import 'package:flutter/material.dart' hide TextField;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:offerhuntbusiness/mixins.dart';
import 'package:offerhuntbusiness/models/shop.dart';
import 'package:offerhuntbusiness/pairs.dart';
import 'package:offerhuntbusiness/screens/views/widget_fields.dart';
import '../views/views.dart';

class AddShop extends StatelessWidget with ScreenUtilMixin {
  final _key = GlobalKey<FormBuilderState>();
  final Shop shop;

  final _imageKey = GlobalKey<OfferImageFieldState>();

  AddShop({this.shop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Shop'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                verticalGap(100),
                FormBuilder(
                  key: _key,
                  initialValue: shop?.toJson() ?? {},
                  child: Column(
                    children: <Widget>[
                      OfferImageField(key: _imageKey),
                      verticalGap(12),
                      StringField(
                        label: 'Shop Name',
                        attribute: 'n',
                        minLength: 4,
                        maxLength: 32,
                      ),
                      verticalGap(12),
                      PhoneField(),
                      verticalGap(12),
                      AddressField(),
                      verticalGap(12),
                      EmailField(),
                      verticalGap(8),
                      CategoryField(
                        categories: ['Fashion', 'Grocery', 'Mobiles'],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                RaisedButton(
                  onPressed: () {
                    if (_key.currentState.validate()) {
                      _key.currentState.save();
                      _commitShop(context);
                    }
                  },
                  child: Text('Submit'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _commitShop(BuildContext context) async {
    final newShop = Shop.fromJson(_key.currentState.value);
    shop.copyFrom(newShop);
    final duo =await showDialog<Duo<ProgressState,dynamic>>(
        context: context,
        barrierDismissible: false,
        builder: (context) => ProgressDialog(
              task: () async {
                await shop.save(context,image: _imageKey.currentState.image);
              },
              startTitle: 'Add Shop',
              runningTitle: 'Adding Shop ... ',
              completedTitle: 'Shop Added Successfully',
              errorTitle: 'Something went wrong',
              button: 'Add',
            ));
    if(duo.first == ProgressState.completed)
      Navigator.of(context).pop();
  }
}
