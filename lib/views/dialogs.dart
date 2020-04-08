import 'package:flutter/material.dart';
import 'package:offerhuntbusiness/mixins.dart';
import 'package:offerhuntbusiness/views/loading_spinner.dart';

import '../pairs.dart';

enum ProgressState { initial, running, completed, error }

class ProgressDialog<T> extends StatefulWidget {
  final Future<T> Function() task;
  final String startTitle, runningTitle, completedTitle, errorTitle;
  final String button;

  const ProgressDialog({
    this.button ='Add',
    @required this.task,
    @required this.startTitle,
    @required this.runningTitle,
    @required this.completedTitle,
    @required this.errorTitle,
  });

  @override
  _ProgressDialogState<T> createState() => _ProgressDialogState<T>();
}

class _ProgressDialogState<T> extends State<ProgressDialog<T>>
    with TextStyleMixin, ScreenUtilStateMixin {
  T _result;
  ProgressState _state = ProgressState.initial;

  @override
  void initState() {
    super.initState();
  }

  void _execute() async {
    _state = ProgressState.running;
    setState(() {
    });
    try {
      if (widget.task == null)
        _result = null;
      else
        _result = await widget.task();
      await Future.delayed(Duration(seconds: 2));
      _state = ProgressState.completed;
    } catch (e) {
      _state = ProgressState.error;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.symmetric(vertical: sh(20),horizontal: sw(12)),
      title: Padding(
        padding:  EdgeInsets.symmetric(vertical: sh(0),horizontal: sw(16)),
        child: Center(
          child: Text(_title()),
        ),
      ),
      children: <Widget>[
        verticalGap(16),
        _icon(),
        verticalGap(16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: _buttons(),
        ),
      ],
    );
  }

  List<Widget> _buttons() {
    switch (_state) {
      case ProgressState.initial:
        return [
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(Duo(_state,_result));
            },
          ),
          horizontalGap(4),
          RaisedButton(
            child: Text(widget.button),
            onPressed: _execute,
          ),
        ];
        break;
      case ProgressState.completed:
        return [FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop(_result);
          },
        )];
        break;
      case ProgressState.error:
        return [RaisedButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop(_result);
          },
        )];
        break;
      case ProgressState.running:
        return [];
        break;
    }
    return [];
  }

  Widget _icon() {
    switch (_state) {
      case ProgressState.initial:
        return SizedBox();
        break;
      case ProgressState.running:
        return LoadingSpinner();
        break;
      case ProgressState.completed:
        return CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.check),
          foregroundColor: Colors.white,
        );
        break;
      case ProgressState.error:
        return CircleAvatar(
          backgroundColor: Colors.red,
          child: Icon(Icons.error),
          foregroundColor: Colors.white,
        );
        break;
    }
    return SizedBox();
  }

  String _title() {
    switch (_state) {
      case ProgressState.initial:
        return widget.startTitle;
        break;
      case ProgressState.running:
        return widget.runningTitle;
        break;
      case ProgressState.completed:
        return widget.completedTitle;
        break;
      case ProgressState.error:
        return widget.errorTitle;
        break;
    }
    return '';
  }
}
