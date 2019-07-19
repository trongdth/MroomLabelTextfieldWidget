library label_textfield_widget;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LabelTextFieldWidget extends StatefulWidget {
  final String hintText;
  final TextStyle lblNormalStyle;
  final TextStyle lblHighlightStyle;
  final TextStyle txtStyle;
  final Function onTxtChanged;
  final bool showClearBtn;
  final bool showBorder;

  LabelTextFieldWidget(
    {Key key,
    @required this.hintText,
    this.lblNormalStyle = const TextStyle(fontSize: 13, color: Colors.grey),
    this.lblHighlightStyle = const TextStyle(fontSize: 13, color: Colors.blue),
    this.txtStyle = const TextStyle(fontSize: 16, color: Colors.black),
    this.onTxtChanged,
    this.showClearBtn = false,
    this.showBorder = true,
    }) : super(key: key);
  
  @override
  _LabelTextFieldWidgetState createState() => _LabelTextFieldWidgetState();
}

class _LabelTextFieldWidgetState extends State<LabelTextFieldWidget> {
  final _focusNode = new FocusNode();
  final TextEditingController txtController = TextEditingController();
  String overlapText;
  bool isShowHintText;

  @override
  void initState() {
    overlapText = widget.hintText;
    isShowHintText = true;
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          if (txtController.text.isEmpty) {
            isShowHintText = true;
          } else {
            isShowHintText = false;
          }
        });
      }
    });
    super.initState();
  }

  Widget _buildTextField(BuildContext context) {
    if (widget.showClearBtn) {
      return Row(
        children: <Widget>[
          Expanded(
            flex: 9,
            child: TextField(
              focusNode: _focusNode,
              style: widget.txtStyle,
              textAlign: TextAlign.left,
              controller: txtController,
              decoration: InputDecoration(
                border: (widget.showBorder) ? UnderlineInputBorder() : InputBorder.none,
                hintText: (isShowHintText) ? widget.hintText : '',
              ),
              onTap: () => _onTap(),
              onChanged: (value) => _onChanged(value),
              onEditingComplete: () => _onComplete(),
            ),
          ),
          (txtController.text.isNotEmpty) ? 
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                txtController.text = '';
                setState(() {});
              },
              child: Icon(Icons.close, color: Colors.grey,),
            ),
          ) :
          Container()
        ],
      );
    }

    return TextField(
      focusNode: _focusNode,
      style: widget.txtStyle,
      textAlign: TextAlign.left,
      controller: txtController,
      decoration: InputDecoration(
        border: (widget.showBorder) ? UnderlineInputBorder() : InputBorder.none,
        hintText: (isShowHintText) ? widget.hintText : '',
      ),
      onTap: () => _onTap(),
      onChanged: (value) => _onChanged(value),
      onEditingComplete: () => _onComplete(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              (isShowHintText) ? '' : overlapText,
              textAlign: TextAlign.start,
              style: (txtController.text.isEmpty) ? widget.lblNormalStyle : widget.lblHighlightStyle,
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: _buildTextField(context),  
          ),
          
        ],
      );
  }

  void _onTap() {
    setState(() {
      isShowHintText = false;
    });
  }

  void _onChanged(String value) {
    if (widget.onTxtChanged != null) {
      widget.onTxtChanged(value);
    }
    setState(() {});
  }

  void _onComplete() {
    setState(() {
      if (txtController.text.isEmpty) {
        isShowHintText = true;
      } else {
        isShowHintText = false;
      }
    });
  }
}
