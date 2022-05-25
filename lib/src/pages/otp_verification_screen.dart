import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../generated/l10n.dart';
import '../controllers/user_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../models/user.dart' as model;

class OtpVerificationScreen extends StatefulWidget{

  final model.User user;

  const OtpVerificationScreen({Key key, this.user}) : super(key: key);

  @override
  OtpVerificationScreenState createState() => OtpVerificationScreenState();
  
}
class OtpVerificationScreenState extends StateMVC<OtpVerificationScreen>{
  String mobileOTP = "";


  UserController _con;

  OtpVerificationScreenState() : super(UserController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      body: Container(
        alignment: Alignment.topCenter,
        height: MediaQuery.of(context).size.height * 1,
        width: MediaQuery.of(context).size.height * 1,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/bg_login.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.09),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.2),
                        child: Text(
                          'OTP Verification',
                          style: TextStyle(
                            color: Theme.of(context).buttonColor,
                            fontFamily: "Roboto",
                            fontSize: 25.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          'we have sent OTP code to your mobile number +${widget.user.phone}.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF454545),
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, right: 40, left: 40),
                        child: PinCodeTextField(
                          appContext: context,
                          length: 4,
                          obscureText: false,
                          autoFocus: true,
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(5),
                              fieldHeight: 48,
                              fieldWidth: 38,
                              activeFillColor: Colors.transparent,
                              activeColor: Theme.of(context).buttonColor,
                              borderWidth: 1,
                              selectedColor: Theme.of(context).buttonColor,
                              disabledColor: Theme.of(context).buttonColor,
                              inactiveColor: const Color(0xFF3D3D3D),
                              inactiveFillColor: Colors.transparent,
                              selectedFillColor: const Color(0xFFFFEDD2)),
                          cursorColor: Theme.of(context).buttonColor,
                          textStyle: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              height: 1.6,
                              color: Theme.of(context).buttonColor),
                          enableActiveFill: true,
                          enablePinAutofill: true,
                          keyboardType: TextInputType.number,
                          onCompleted: (v) {
                            setState(() {
                              mobileOTP = v.toString();
                            });
                          },
                          onChanged: (value) {},
                          beforeTextPaste: (text) {
                            return true;
                          },
                        ),
                      ),

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
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.2, vertical: 14),
                          shape: StadiumBorder(),
                          child: Text(
                            S.of(context).continues,
                            style: TextStyle(color: Theme.of(context).primaryColor),
                          ),
                          color: Theme.of(context).buttonColor,
                          onPressed: () async {
                            if (mobileOTP.isEmpty) {
                              await Flushbar(
                                flushbarPosition: FlushbarPosition.TOP,
                                message: "Please enter valid otp !",
                                duration: Duration(seconds: 2),
                              )..show(context);
                            }else{
                              _con.user.otp = mobileOTP;
                              _con.user.phone = widget.user.phone;
                              _con.user.verifiedPhone = true;
                              setState(() { });
                              _con.login();
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: 'Did not received OTP code?',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF454545),
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w300,
                              ),
                              children: [
                                TextSpan(
                                  text: ' \nResend Code',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async{
                                    print("resend Otp==>");
                                      _con.user.phone = widget.user.phone;
                                      _con.user.verifiedPhone = true;
                                      setState(() { });
                                      _con.resendOtp();
                                    },
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).buttonColor,
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
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