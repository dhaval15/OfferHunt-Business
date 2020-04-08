import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:offerhuntbusiness/colors.dart';
import 'package:offerhuntbusiness/mixins.dart';
import 'package:offerhuntbusiness/models/models.dart';
import 'package:offerhuntbusiness/screens/views/widget_fields.dart';
import '../api/auth.dart';
import '../views/views.dart' hide TextField;
import 'home.dart';

class AuthScreen extends StatefulWidget {
  static MaterialPageRoute builder({PhoneAuthStatus status}) =>
      MaterialPageRoute(builder: (context) => AuthScreen(status: status));
  final PhoneAuthStatus status;

  const AuthScreen({this.status = PhoneAuthStatus.initial});

  @override
  PhoneAuthState createState() => PhoneAuthState();
}

class PhoneAuthState extends State<AuthScreen>
    with ScreenUtilStateMixin, TextStyleMixin {
  final _phoneNumberController = TextEditingController();
  final _smsCodeController = TextEditingController();

  PhoneAuthAPI _api;

  PhoneAuthStatus status;
  String error;

  @override
  void initState() {
    super.initState();
    _api = AuthProvider.of(context).authApi;
    status = widget.status;
    _api.stream.listen(_onStatusChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      verticalGap(12),
                      AppTitle(),
                    ],
                  )),
            ),
            Flexible(
              flex: 2,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Align(
                  alignment: Alignment(0, 0.70),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _buildFromStatus(status),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFromStatus(PhoneAuthStatus status) {
    switch (status) {
      case PhoneAuthStatus.initial:
      case PhoneAuthStatus.invalidPhoneNumber:
        return _phoneBody();
      case PhoneAuthStatus.sendingCode:
        return _loadingIndicatorBody('Sending OTP To');
      case PhoneAuthStatus.codeSent:
      case PhoneAuthStatus.invalidCode:
        return _smsCodeBody();
      case PhoneAuthStatus.verifyingCode:
        return _loadingIndicatorBody('Verifying OTP');
      case PhoneAuthStatus.details:
        return [
          DetailsForm(
            onFormSaved: (doc) {
              AuthProvider.of(context).authApi.updateOwner(Owner.fromDoc(doc));
            },
          )
        ];
      case PhoneAuthStatus.updatingDetails:
        return _loadingIndicatorBody('Just A Minute');
      case PhoneAuthStatus.welcome:
        return _welcomeBody();
      default:
        return [];
    }
  }

  List<Widget> _phoneBody() {
    return [
      TextField(
        controller: _phoneNumberController,
        decoration: InputDecoration(
          labelText: 'Phone No',
          errorText: error,
        ),
        onChanged: (text) {
          if (error != null)
            setState(() {
              error = null;
            });
        },
      ),
      verticalGap(12),
      _Button(
        text: 'Send Code',
        onPressed: () {
          _api.sendCode('+91${_phoneNumberController.text}');
        },
      ),
    ];
  }

  List<Widget> _smsCodeBody() {
    return [
      TextField(
        controller: _smsCodeController,
        decoration: InputDecoration(
          labelText: 'SMS Code',
          errorText: error,
        ),
        onChanged: (text) {
          if (error != null)
            setState(() {
              error = null;
            });
        },
      ),
      verticalGap(12),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _Button(
            text: 'EDIT',
            onPressed: () {
              error = null;
              _smsCodeController.clear();
              _api.edit();
            },
          ),
          _Button(
            text: 'VERIFY',
            onPressed: () {
              _api.verifyCode(_smsCodeController.text);
            },
          ),
        ],
      ),
    ];
  }

  List<Widget> _welcomeBody() {
    return [
      FutureBuilder<String>(
        future: _api.displayName,
        builder: (context, snapshot) => snapshot.hasData
            ? Text(
                'Welcome ${snapshot.data}',
                style: headline6,
              )
            : verticalGap(20),
      ),
      verticalGap(24),
      FloatingActionButton(
        backgroundColor: brandColor,
        child: Icon(
          Icons.navigate_next,
          size: sw(36),
        ),
        onPressed: () {
          Navigator.of(context).pushReplacement(HomeScreen.builder);
        },
      ),
    ];
  }

  List<Widget> _loadingIndicatorBody(String message) {
    return [
      Text(
        message,
        style: TextStyle(fontSize: 18),
      ),
      verticalGap(24),
      LoadingSpinner(),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    _api.dispose();
  }

  void _onStatusChanged(PhoneAuthStatus status) {
    error = null;
    if (status == PhoneAuthStatus.successful) {
      Navigator.of(context).pushReplacement(HomeScreen.builder);
      return;
    }
    if (status == PhoneAuthStatus.invalidPhoneNumber) error = 'Invalid PhoneNo';
    if (status == PhoneAuthStatus.invalidCode) error = 'Invalid SMS Code';
    setState(() {
      this.status = status;
    });
  }
}

class _Button extends StatelessWidget {
  final GestureTapCallback onPressed;

  final String text;

  const _Button({this.onPressed, this.text});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(
        text,
      ),
      onPressed: onPressed,
    );
  }
}

class DetailsForm extends StatelessWidget with ScreenUtilMixin {
  final _key = GlobalKey<FormBuilderState>();
  final Function(Map doc) onFormSaved;
  final Owner owner;

  DetailsForm({this.owner, this.onFormSaved});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FormBuilder(
          initialValue: owner?.toJson() ?? {},
          child: Column(
            children: <Widget>[
              StringField(
                attribute: 'n',
                label: 'Name',
                minLength: 4,
                maxLength: 32,
              ),
              verticalGap(12),
              EmailField(),
              verticalGap(12),
              AddressField(),
            ],
          ),
          key: _key,
        ),
        verticalGap(12),
        RaisedButton(
          onPressed: () async {
            if (_key.currentState.validate()) {
              _key.currentState.save();
              onFormSaved(_key.currentState.value);
            }
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
