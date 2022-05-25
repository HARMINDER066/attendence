import 'dart:io';
import 'package:flutter/material.dart';
import '../models/media.dart';
import '../repository/upload_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../generated/l10n.dart';
import '../controllers/settings_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/MobileVerificationBottomSheetWidget.dart';
import '../elements/PaymentSettingsDialog.dart';
import '../elements/ProfileSettingsDialog.dart';
import '../helpers/helper.dart';
import '../repository/user_repository.dart';
import 'package:image_picker/image_picker.dart';
import '../repository/user_repository.dart' as userRepo;

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({Key key}) : super(key: key);
  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends StateMVC<SettingsWidget> {
  SettingsController _con;
  PickedFile image;
  String uuid;
  UploadRepository _uploadRepository;
  OverlayEntry loader;
  _SettingsWidgetState() : super(SettingsController()) {
    _con = controller;
    _uploadRepository = new UploadRepository();
  }

  Future pickImage(ImageSource source, ValueChanged<String> uploadCompleted) async {
    ImagePicker imagePicker = ImagePicker();
    final pickedImage = await imagePicker.getImage(
      source: source,
      imageQuality: 80,
    );
    if (pickedImage != null) {
      try {
        setState((){
          image = pickedImage;
        });
        loader = Helper.overlayLoader(context);
        FocusScope.of(context).unfocus();
        Overlay.of(context).insert(loader);
        uuid = await _uploadRepository.uploadImage(File(image.path), 'avatar');
        uploadCompleted(uuid);
        userRepo.currentUser.value.image = new Media(id: uuid);
        _con.update(userRepo.currentUser.value);
        Helper.hideLoader(loader);
      }
      catch (e) {
      }
    } else {
    }
  }

  GlobalKey<FormState> _profileSettingsFormKey = new GlobalKey<FormState>();

  @override
  void initState() {
    _con.listenForUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con.scaffoldKey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          centerTitle: true,
          leading: new IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
            onPressed: () => {
              Navigator.of(context).pop(),
            },
          ),
          title: Text(
            S.of(context).settings,
            style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
          ),
          bottom: PreferredSize(
              child: Container(
                color: Theme.of(context).hintColor.withOpacity(0.2),
                height: 0.5,
              ),
              preferredSize: Size.fromHeight(4.0)),
        ),
      bottomNavigationBar:  Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            //cancel button
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.height * 0.07,
              margin: const EdgeInsets.only(
                  top: 20, right: 20, bottom:20),
              decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius:
                  BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.white)),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  S.of(context).cancel,
                  style: Theme.of(context)
                      .primaryTextTheme
                      .subtitle1
                      .copyWith(color: Colors.white),
                ),
              ),
            ),

            //save button
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.height * 0.07,
              margin: const EdgeInsets.only(
                  top: 20, left: 20, bottom:20),
              decoration: BoxDecoration(
                color: Theme.of(context).highlightColor,
                borderRadius:
                BorderRadius.all(Radius.circular(10)),
              ),
              child: TextButton(
                onPressed: () {
                  if(!currentUser.value.email.contains('@')){
                    ScaffoldMessenger.of(_con.scaffoldKey?.currentContext).showSnackBar(SnackBar(
                        content: Text("Please enter valid email address."),
                        behavior: SnackBarBehavior.floating,
                      ));
                  }else if (_profileSettingsFormKey.currentState.validate()) {
                    setState(() {_profileSettingsFormKey.currentState.save();});
                    _con.update(currentUser.value);
                  }
                },
                child: Text(
                  S.of(context).save,
                  style: Theme.of(context)
                      .primaryTextTheme
                      .subtitle1
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
        body:
        currentUser.value.id == null
            ? CircularLoadingWidget(height: 500):
            Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      //profile pic
                      SizedBox(
                          width: 90,
                          height: 90,
                          child: InkWell(
                              borderRadius: BorderRadius.circular(300),
                              child: Stack(
                                  children: [
                                    SizedBox(
                                      width: 90,
                                      height: 90,
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(currentUser.value.image.thumb),
                                      ),
                                    ),
                                    Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Image.asset('assets/img/icon_edit_profile.png', width: 25, height: 25)
                                    )
                                  ]

                              ),
                              onTap: () async{
                                await pickImage(ImageSource.gallery, (uuid) {userRepo.currentUser.value.image = new Media(id: uuid);});
                              }
                          )
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
                        child: Form(
                          key: _profileSettingsFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              //full name
                              Text(
                                S.of(context).full_name,
                                style: TextStyle(color: Theme.of(context).focusColor),
                              ),

                              Container(
                                margin: EdgeInsets.only(top: 10),
                                width: MediaQuery.of(context).size.width * 20,
                                height: MediaQuery.of(context).size.height * 0.07,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(color: Theme.of(context).focusColor.withOpacity(0.2)),
                                  color: Theme.of(context).primaryColor,),
                                alignment: Alignment.center,
                                child: Container(
                                  margin: EdgeInsets.only(left: 15, right: 15),
                                  child: TextFormField(
                                    initialValue: currentUser.value.name,
                                      textInputAction: TextInputAction.next,
                                      style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(color: Theme.of(context).accentColor.withOpacity(0.8))),
                                    maxLines: 1,
                                    // validator: (input) => input.trim().length < 3 ? S.of(context).not_a_valid_full_name : null,
                                    onSaved: (input) => currentUser.value.name = input,
                                    decoration: InputDecoration(
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.zero),
                                    keyboardType: TextInputType.text,
                                    textAlign: TextAlign.left,
                                    //controller: mobileTFController,
                                  ),
                                ),
                              ),

                              //email
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Text(
                                  S.of(context).email_address,
                                  style: TextStyle(color: Theme.of(context).focusColor),
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(top: 10),
                                width: MediaQuery.of(context).size.width * 20,
                                height: MediaQuery.of(context).size.height * 0.07,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(color: Theme.of(context).focusColor.withOpacity(0.2)),
                                  color: Theme.of(context).primaryColor,),
                                alignment: Alignment.center,
                                child: Container(
                                  margin: EdgeInsets.only(left: 15, right: 15),
                                  child: TextFormField(
                                    initialValue: currentUser.value.email,
                                    textInputAction: TextInputAction.next,
                                    style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(color: Theme.of(context).accentColor.withOpacity(0.8))),
                                    maxLines: 1,
                                    // validator: (input) => !input.contains('@') ? S.of(context).not_a_valid_email : null,
                                    // onSaved: (input){
                                    //   currentUser.value.email = input;
                                    //   setState(() { });
                                    // },
                                    onChanged: (value) {
                                      currentUser.value.email = value;
                                      setState(() { });
                                    },
                                    decoration: InputDecoration(
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.zero),
                                    keyboardType: TextInputType.emailAddress,
                                    textAlign: TextAlign.left,
                                    //controller: mobileTFController,
                                  ),
                                ),
                              ),

                              //phone
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Text(
                                  S.of(context).phoneNumber,
                                  style: TextStyle(color: Theme.of(context).focusColor),
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(top: 10),
                                width: MediaQuery.of(context).size.width * 20,
                                height: MediaQuery.of(context).size.height * 0.07,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(color: Theme.of(context).focusColor.withOpacity(0.2)),
                                  color: Theme.of(context).primaryColor,),
                                alignment: Alignment.center,
                                child: Container(
                                  margin: EdgeInsets.only(left: 15, right: 15),
                                  child: TextFormField(
                                    initialValue: currentUser.value.phone,
                                    textInputAction: TextInputAction.next,
                                    style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(color: Theme.of(context).accentColor.withOpacity(0.8))),
                                    maxLines: 1,
                                    maxLength: 10,
                                    focusNode: new AlwaysDisabledFocusNode(),
                                    enableInteractiveSelection: false,
                                    validator: (input) => input.trim().length < 3 ? S.of(context).not_a_valid_phone : null,
                                    onSaved: (input) => currentUser.value.phone = input,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                      counterText: '',
                                        enabledBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.zero),
                                    keyboardType: TextInputType.phone,
                                    textAlign: TextAlign.left,
                                    //controller: mobileTFController,
                                  ),
                                ),
                              ),

                              //address
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Text(
                                  S.of(context).address,
                                  style: TextStyle(color: Theme.of(context).focusColor),
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(top: 10),
                                width: MediaQuery.of(context).size.width * 20,
                                height: MediaQuery.of(context).size.height * 0.1,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(color: Theme.of(context).focusColor.withOpacity(0.2)),
                                  color: Theme.of(context).primaryColor,),
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.only(left: 15, right: 15),
                                  child: TextFormField(
                                    initialValue: currentUser.value.address,
                                    textInputAction: TextInputAction.next,
                                    style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(color: Theme.of(context).accentColor.withOpacity(0.8))),
                                    onSaved: (input) => currentUser.value.address = input,
                                    // validator: (input) => input.trim().length < 3 ? S.of(context).not_a_valid_address : null,
                                    decoration: InputDecoration(
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.zero),
                                    keyboardType: TextInputType.text,
                                    textAlign: TextAlign.left,
                                    //controller: mobileTFController,
                                  ),
                                ),
                              ),

                              //about
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Text(
                                  S.of(context).about,
                                  style: TextStyle(color: Theme.of(context).focusColor),
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(top: 10),
                                width: MediaQuery.of(context).size.width * 20,
                                height: MediaQuery.of(context).size.height * 0.07,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(color: Theme.of(context).focusColor.withOpacity(0.2)),
                                  color: Theme.of(context).primaryColor,),
                                alignment: Alignment.center,
                                child: Container(
                                  margin: EdgeInsets.only(left: 15, right: 15),
                                  child: TextFormField(
                                    initialValue: currentUser.value.bio,
                                    textInputAction: TextInputAction.next,
                                    style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(color: Theme.of(context).accentColor.withOpacity(0.8))),
                                    maxLines: 1,
                                    // validator: (input) => input.trim().length < 3 ? S.of(context).not_a_valid_biography : null,
                                    onSaved: (input) => currentUser.value.bio = input,
                                    decoration: InputDecoration(
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.zero),
                                    keyboardType: TextInputType.text,
                                    textAlign: TextAlign.left,
                                    //controller: mobileTFController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      //old flow
                      Visibility(
                        visible: false,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              child: Row(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        currentUser.value.name,
                                        textAlign: TextAlign.left,
                                        style: Theme.of(context).textTheme.headline3,
                                      ),
                                      Text(
                                        currentUser.value.email,
                                        style: Theme.of(context).textTheme.caption,
                                      )
                                    ],
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                  ),
                                  SizedBox(
                                      width: 55,
                                      height: 55,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(300),
                                          child: Stack(
                                            children: [
                                              SizedBox(
                                                width: 55,
                                                height: 55,
                                                child: CircleAvatar(
                                                  backgroundImage: NetworkImage(currentUser.value.image.thumb),
                                                ),
                                              ),
                                              Positioned(
                                                top: 0,
                                                right: 0,
                                                child:Icon(
                                                  Icons.add_a_photo,
                                                  color: Theme.of(context).hintColor,
                                                  size: 16,
                                                )
                                              )
                                            ]

                                          ),
                                          onTap: () async{
                                             await pickImage(ImageSource.gallery, (uuid) {userRepo.currentUser.value.image = new Media(id: uuid);});
                                         }
                                      )
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
                              ),
                              child: ListView(
                                shrinkWrap: true,
                                primary: false,
                                children: <Widget>[
                                  ListTile(
                                    leading: Icon(Icons.person_outline),
                                    title: Text(
                                      S.of(context).profile_settings,
                                      style: Theme.of(context).textTheme.bodyText1,
                                    ),
                                    trailing: ButtonTheme(
                                      padding: EdgeInsets.all(0),
                                      minWidth: 50.0,
                                      height: 25.0,
                                      child: ProfileSettingsDialog(
                                        user: currentUser.value,
                                        onChanged: () {
                                          var bottomSheetController = _con.scaffoldKey.currentState.showBottomSheet(
                                                (context) => MobileVerificationBottomSheetWidget(scaffoldKey: _con.scaffoldKey, user: currentUser.value),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: new BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                            ),
                                          );
                                          bottomSheetController.closed.then((value) {
                                            _con.update(currentUser.value);
                                          });
                                          //setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {},
                                    dense: true,
                                    title: Text(
                                      S.of(context).full_name,
                                      style: Theme.of(context).textTheme.bodyText2,
                                    ),
                                    trailing: Text(
                                      currentUser.value.name,
                                      style: TextStyle(color: Theme.of(context).focusColor),
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {},
                                    dense: true,
                                    title: Text(
                                      S.of(context).email,
                                      style: Theme.of(context).textTheme.bodyText2,
                                    ),
                                    trailing: Text(
                                      currentUser.value.email,
                                      style: TextStyle(color: Theme.of(context).focusColor),
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {},
                                    dense: true,
                                    title: Wrap(
                                      spacing: 8,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        Text(
                                          S.of(context).phone,
                                          style: Theme.of(context).textTheme.bodyText2,
                                        ),
                                        if (currentUser.value.verifiedPhone ?? false)
                                          Icon(
                                            Icons.check_circle_outline,
                                            color: Theme.of(context).accentColor,
                                            size: 22,
                                          )
                                      ],
                                    ),
                                    trailing: Text(
                                      currentUser.value.phone,
                                      style: TextStyle(color: Theme.of(context).focusColor),
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {},
                                    dense: true,
                                    title: Text(
                                      S.of(context).address,
                                      style: Theme.of(context).textTheme.bodyText2,
                                    ),
                                    trailing: Text(
                                      Helper.limitString(currentUser.value.address ?? S.of(context).unknown),
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                      style: TextStyle(color: Theme.of(context).focusColor),
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {},
                                    dense: true,
                                    title: Text(
                                      S.of(context).about,
                                      style: Theme.of(context).textTheme.bodyText2,
                                    ),
                                    trailing: Text(
                                      Helper.limitString(currentUser.value.bio),
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                      style: TextStyle(color: Theme.of(context).focusColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
                              ),
                              child: ListView(
                                shrinkWrap: true,
                                primary: false,
                                children: <Widget>[
                                  ListTile(
                                    leading: Icon(Icons.credit_card),
                                    title: Text(
                                      S.of(context).payments_settings,
                                      style: Theme.of(context).textTheme.bodyText1,
                                    ),
                                    trailing: ButtonTheme(
                                      padding: EdgeInsets.all(0),
                                      minWidth: 50.0,
                                      height: 25.0,
                                      child: PaymentSettingsDialog(
                                        creditCard: _con.creditCard,
                                        onChanged: () {
                                          _con.updateCreditCard(_con.creditCard);
                                          //setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    dense: true,
                                    title: Text(
                                      S.of(context).default_credit_card,
                                      style: Theme.of(context).textTheme.bodyText2,
                                    ),
                                    trailing: Text(
                                      _con.creditCard.number.isNotEmpty ? _con.creditCard.number.replaceRange(0, _con.creditCard.number.length - 4, '...') : '',
                                      style: TextStyle(color: Theme.of(context).focusColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
                              ),
                              child: ListView(
                                shrinkWrap: true,
                                primary: false,
                                children: <Widget>[
                                  ListTile(
                                    leading: Icon(Icons.settings_outlined),
                                    title: Text(
                                      S.of(context).app_settings,
                                      style: Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Navigator.of(context).pushNamed('/Languages');
                                    },
                                    dense: true,
                                    title: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.translate,
                                          size: 22,
                                          color: Theme.of(context).focusColor,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          S.of(context).languages,
                                          style: Theme.of(context).textTheme.bodyText2,
                                        ),
                                      ],
                                    ),
                                    trailing: Text(
                                      S.of(context).english,
                                      style: TextStyle(color: Theme.of(context).focusColor),
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Navigator.of(context).pushNamed('/DeliveryAddresses');
                                    },
                                    dense: true,
                                    title: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.place_outlined,
                                          size: 22,
                                          color: Theme.of(context).focusColor,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          S.of(context).delivery_addresses,
                                          style: Theme.of(context).textTheme.bodyText2,
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Navigator.of(context).pushNamed('/Help');
                                    },
                                    dense: true,
                                    title: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.help_outline,
                                          size: 22,
                                          color: Theme.of(context).focusColor,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          S.of(context).help_support,
                                          style: Theme.of(context).textTheme.bodyText2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
            ));
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
