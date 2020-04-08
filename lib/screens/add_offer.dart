import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:offerhuntbusiness/mixins.dart';
import 'package:offerhuntbusiness/models/models.dart';
import 'package:offerhuntbusiness/models/shop.dart';
import 'package:offerhuntbusiness/views/views.dart';

import '../pairs.dart';
import 'views/widget_fields.dart';

class AddOfferScreen extends StatelessWidget with ScreenUtilMixin {
  final _key = GlobalKey<FormBuilderState>();
  final Offer offer;
  final Shop shop;

  final _imageKey = GlobalKey<OfferImageFieldState>();

  AddOfferScreen(this.shop, {this.offer}) {
    offer.shopKey = shop.key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Offer'),
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
                  initialValue: offer?.toJson() ?? {},
                  child: Column(
                    children: <Widget>[
                      OfferImageField(key: _imageKey),
                      verticalGap(12),
                      StringField(
                        label: 'Title',
                        attribute: 't',
                        minLength: 4,
                        maxLength: 32,
                      ),
                      verticalGap(12),
                      StringField(
                        label: 'Subitle',
                        attribute: 's',
                        minLength: 4,
                        maxLength: 32,
                      ),
                      verticalGap(12),
                      StringField(
                        label: 'Description',
                        attribute: 'd',
                        maxLines: 4,
                        minLength: 12,
                        maxLength: 200,
                      ),
                      verticalGap(12),
                      DiscountField(),
                      verticalGap(12),
                      DateField(),
                      verticalGap(8),
                      CategoryField(
                        categories: shop.categories,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                RaisedButton(
                  onPressed: () {
                    if (_key.currentState.validate()) {
                      _key.currentState.save();
                      print(_key.currentState.value);
                     //_commitOffer(context);
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

  void _commitOffer(BuildContext context) async {
    final newOffer = Offer.fromJson(_key.currentState.value);
    offer.copyFrom(newOffer);
    final duo = await showDialog<Duo<ProgressState, dynamic>>(
        context: context,
        barrierDismissible: false,
        builder: (context) => ProgressDialog(
              task: () async {
                await offer.save(context,image: _imageKey.currentState.image);
              },
              startTitle: 'Add Shop',
              runningTitle: 'Adding Shop ... ',
              completedTitle: 'Shop Added Successfully',
              errorTitle: 'Something went wrong',
              button: 'Add',
            ));
    if (duo.first == ProgressState.completed) Navigator.of(context).pop();
  }
}
