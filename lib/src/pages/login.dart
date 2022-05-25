import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/user_controller.dart';
import '../helpers/app_config.dart' as config;
import '../repository/user_repository.dart' as userRepo;

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends StateMVC<LoginWidget> {
  UserController _con;
  String countrycode = "91";

  _LoginWidgetState() : super(UserController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    if (userRepo.currentUser.value?.apiToken != null) {
      Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: _con.scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/img/bg_login.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.30, left: 30),
                    child: Text(
                      S.of(context).welcome_login,
                      style: TextStyle(fontSize: 30, color: Theme.of(context).buttonColor, fontWeight: FontWeight.bold),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 5, left: 30),
                    child: Container(
                      child: Text(
                        S.of(context).signin_to_continue,
                        style: TextStyle(fontSize: 18, color: const Color(0xFF818181), fontWeight: FontWeight.w200),
                      ),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15),
                    child: Form(
                      key: _con.loginFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          //mobile number
                          Container(
                            width: MediaQuery.of(context).size.width * 20,
                            height: MediaQuery.of(context).size.height * 0.07,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Row(
                              children: [
                                Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.center,
                                    height: MediaQuery.of(context).size.height * 0.078,
                                    child: Text("+"+countrycode, style: TextStyle(fontSize: 16, color: Theme.of(context).buttonColor, fontWeight: FontWeight.w500))),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0, top: 8, bottom: 8),
                                  child: VerticalDivider(
                                    color: Color(0xFFC9C6C6),
                                    width: 2,
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.phone,
                                    onSaved: (input) => _con.user.phone = countrycode + input,
                                    maxLength: 10,
                                    style: TextStyle(fontSize: 16, color:Theme.of(context).buttonColor, fontWeight: FontWeight.w500),
                                    // validator: (input) => input.length !=10 ? S.of(context).should_be_a_valid_mobile : null,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      counterText: '',
                                      contentPadding: EdgeInsets.all(12),
                                      hintText: 'Enter Mobile Number',
                                      hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.5)),
                                      suffixIcon: IconButton(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        icon: Icon(Icons.call, color: Theme.of(context).buttonColor),
                                        onPressed: () {},
                                      ),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //other field
                          // SizedBox(height: 30),
                          // TextFormField(
                          //   keyboardType: TextInputType.emailAddress,
                          //   onSaved: (input) => _con.user.email = input,
                          //   validator: (input) => !input.contains('@') ? S.of(context).should_be_a_valid_email : null,
                          //   decoration: InputDecoration(
                          //     labelText: S.of(context).email,
                          //     labelStyle: TextStyle(color: Theme.of(context).accentColor),
                          //     contentPadding: EdgeInsets.all(12),
                          //     hintText: 'johndoe@gmail.com',
                          //     hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                          //     prefixIcon: Icon(Icons.alternate_email, color: Theme.of(context).accentColor),
                          //     border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                          //     focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                          //     enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                          //   ),
                          // ),
                          // SizedBox(height: 30),
                          // TextFormField(
                          //   keyboardType: TextInputType.text,
                          //   onSaved: (input) => _con.user.password = input,
                          //   validator: (input) => input.length < 3 ? S.of(context).should_be_more_than_3_characters : null,
                          //   obscureText: _con.hidePassword,
                          //   decoration: InputDecoration(
                          //     labelText: S.of(context).password,
                          //     labelStyle: TextStyle(color: Theme.of(context).accentColor),
                          //     contentPadding: EdgeInsets.all(12),
                          //     hintText: '••••••••••••',
                          //     hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                          //     prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).accentColor),
                          //     suffixIcon: IconButton(
                          //       onPressed: () {
                          //         setState(() {
                          //           _con.hidePassword = !_con.hidePassword;
                          //         });
                          //       },
                          //       color: Theme.of(context).focusColor,
                          //       icon: Icon(_con.hidePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                          //     ),
                          //     border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                          //     focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                          //     enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                          //   ),
                          // ),
                          SizedBox(height: 30),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: MaterialButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              hoverElevation: 0,
                              focusElevation: 0,
                              highlightElevation: 0,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                              shape: StadiumBorder(),
                              child: Text(
                                S.of(context).send_otp,
                                style: TextStyle(color: Theme.of(context).primaryColor),
                              ),
                              color: Theme.of(context).buttonColor,
                              onPressed: () async {
                                _con.sendOtp();
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
                                },
                                child: Text(
                                  S.of(context).skip,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: config.Colors().accentDarkColor(1)),
                                )),
                          ),
//                      SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),

                  //signup and forgot password
                  Visibility(
                    visible: false,
                    child: Column(
                      children: <Widget>[
                        MaterialButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          elevation: 0,
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/ForgetPassword');
                          },
                          textColor: Theme.of(context).hintColor,
                          child: Text(S.of(context).i_forgot_password),
                        ),
                        MaterialButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          elevation: 0,
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/SignUp');
                          },
                          textColor: Theme.of(context).hintColor,
                          child: Text(S.of(context).i_dont_have_an_account),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
                onPressed: () => {
                  Navigator.pop(context),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
