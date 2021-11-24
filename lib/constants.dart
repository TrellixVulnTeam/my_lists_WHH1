import 'package:flutter/material.dart';

// Palette

// const kPrimaryColour = Color(0xFF9e9e9e);
// const kLightPrimaryColour = Color(0xFFBDBDBD);
// const kDarkPrimaryColour = Color(0xFF616161);
//
// const kInactiveColour = Color(0xFFeeeeee);

const kPrimaryColour = Colors.white;

const kAccentColour = Color(0xFF26a69a);
const kLightAccentColour = Color(0xFF80cbc4);
const kDarkAccentColour = Color(0xFF00897b);
const kSuperLightAccentColour = Color(0xFFb2dfdb);

const kPrimaryTextColour = Color(0xFF424242);
const kSecondaryTextColour = Color(0xFFffffff);

// Login and Registration screens TextFields
const kLoginTextFieldDecoration = InputDecoration(
  hintText: 'Hint text goes here',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kAccentColour, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kAccentColour, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kUsersTextFormFieldDecoration = InputDecoration(
  labelText: 'Label text goes here',
  contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kLightAccentColour, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kLightAccentColour, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
);
