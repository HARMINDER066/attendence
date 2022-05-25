import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/profile_controller.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends StateMVC<DrawerWidget> {
  _DrawerWidgetState() : super(ProfileController()) {}

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              currentUser.value.apiToken != null ? Navigator.of(context).popAndPushNamed('/Profile') : Navigator.of(context).pushNamed('/Login');
            },
            child: currentUser.value.apiToken != null
        ?DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withOpacity(0.1),
              ),
              child: Row(
                children: <Widget>[
                  Stack(
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(80)),
                          child: CachedNetworkImage(
                            height: 80,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            imageUrl: currentUser.value.image.thumb,
                            placeholder: (context, url) => Image.asset(
                              'assets/img/loading.gif',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 80,
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error_outline),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: currentUser.value.verifiedPhone ?? false
                            ? Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                              child: Icon(
                          Icons.check_circle,
                          color: Theme.of(context).accentColor,
                          size: 24,
                        ),
                            )
                            : SizedBox(),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          currentUser.value.name,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          currentUser.value.phone,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ): Container(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor.withOpacity(0.1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(S.of(context).welcome, style: Theme.of(context).textTheme.headline4.merge(TextStyle(color: Theme.of(context).accentColor))),
                        SizedBox(height: 5),
                        Text(S.of(context).loginAccountOrCreateNewOneForFree, style: Theme.of(context).textTheme.bodyText2),
                        SizedBox(height: 15),
                        Wrap(
                          spacing: 10,
                          children: <Widget>[
                            MaterialButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              elevation: 0,
                              onPressed: () {
                                Navigator.of(context).pushNamed('/Login');
                              },
                              color: Theme.of(context).buttonColor,
                              height: 35,
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: Wrap(
                                runAlignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 9,
                                children: [
                                  Icon(Icons.exit_to_app_outlined, color: Theme.of(context).primaryColor, size: 24),
                                  Text(
                                    S.of(context).login,
                                    style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(color: Theme.of(context).primaryColor)),
                                  ),
                                ],
                              ),
                              shape: StadiumBorder(),
                            ),
                           Visibility(
                             visible: false,
                             child:  MaterialButton(
                               splashColor: Colors.transparent,
                               highlightColor: Colors.transparent,
                             elevation: 0,
                             color: Theme.of(context).focusColor.withOpacity(0.2),
                             height: 40,
                             onPressed: () {
                               Navigator.of(context).pushNamed('/SignUp');
                             },
                             child: Wrap(
                               runAlignment: WrapAlignment.center,
                               crossAxisAlignment: WrapCrossAlignment.center,
                               spacing: 9,
                               children: [
                                 Icon(Icons.person_add_outlined, color: Theme.of(context).hintColor, size: 24),
                                 Text(
                                   S.of(context).register,
                                   style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(color: Theme.of(context).hintColor)),
                                 ),
                               ],
                             ),
                             shape: StadiumBorder(),
                           ),)
                          ],
                        ),
                      ],
                    ),
                  )

          ),
          ListTile(
            visualDensity: VisualDensity(horizontal: 0, vertical: -3),
            horizontalTitleGap: 2,
            contentPadding: EdgeInsets.only(left: 5),
            onTap: () {
              Navigator.of(context).pushNamed('/Pages', arguments: 2);
            },
            leading: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Image.asset('assets/img/icon_home.png', width: 20, height: 20,),
              color: Theme.of(context).focusColor.withOpacity(0.5),
              onPressed: () {},
            ),
            title: Text(
              S.of(context).home,
              // style:  TextStyle(fontSize: 17.0, fontWeight: FontWeight.w400, color: config.Colors().secondColor(1), height: 1.2),
              style:  Theme.of(context).textTheme.subtitle1.merge(TextStyle(fontWeight: FontWeight.w400)),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.only(left: 5),
            visualDensity: VisualDensity(horizontal: 0, vertical: -3),
            horizontalTitleGap: 2,
            onTap: () {
              Navigator.of(context).pushNamed('/Pages', arguments: 4);
            },
            leading: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Image.asset('assets/img/icon_notifications.png', width: 20, height: 20,),
              color: Theme.of(context).focusColor.withOpacity(1),
              onPressed: () {},
            ),
            title: Text(
              S.of(context).notifications,
              style:  Theme.of(context).textTheme.subtitle1.merge(TextStyle(fontWeight: FontWeight.w400)),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.only(left: 5),
            visualDensity: VisualDensity(horizontal: 0, vertical: -3),
            horizontalTitleGap: 2,
            onTap: () {
              Navigator.of(context).pushNamed('/Pages', arguments: 3);
            },
            leading: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Image.asset('assets/img/icon_my_orders.png', width: 20, height: 20,),
              color: Theme.of(context).focusColor.withOpacity(1),
              onPressed: () {},
            ),
            title: Text(
              S.of(context).my_orders,
              style:  Theme.of(context).textTheme.subtitle1.merge(TextStyle(fontWeight: FontWeight.w400)),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.only(left: 5),
            visualDensity: VisualDensity(horizontal: 0, vertical: -3),
            horizontalTitleGap: 2,
            onTap: () {
              if (currentUser.value.apiToken != null) {
                Navigator.of(context).popAndPushNamed('/DeliveryAddresses');
              } else {
                Navigator.of(context).pushNamed('/Login');
              }

            },
            leading: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Image.asset('assets/img/icon_bottom_location_unselect.png', width: 20, height: 20,),
              color: Theme.of(context).focusColor.withOpacity(1),
              onPressed: () {},
            ),
            title: Text(
              S.of(context).address_book,
              style:  Theme.of(context).textTheme.subtitle1.merge(TextStyle(fontWeight: FontWeight.w400)),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.only(left: 5),
            visualDensity: VisualDensity(horizontal: 0, vertical: -3),
            horizontalTitleGap: 2,
            onTap: () {
              Navigator.of(context).popAndPushNamed('/Favorites');
            },
            leading: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Image.asset('assets/img/icon_fav_product.png', width: 20, height: 20,),
              color: Theme.of(context).focusColor.withOpacity(1),
              onPressed: () {},
            ),
            title: Text(
              S.of(context).favorite_products,
              style:  Theme.of(context).textTheme.subtitle1.merge(TextStyle(fontWeight: FontWeight.w400)),
            ),
          ),

          ListTile(
            contentPadding: EdgeInsets.only(left: 5),
            visualDensity: VisualDensity(horizontal: 0, vertical: -3),
            horizontalTitleGap: 2,
            onTap: () {
              if (currentUser.value.apiToken != null) {
                Navigator.of(context).popAndPushNamed('/MyMembership');
              } else {
                Navigator.of(context).pushNamed('/Login');
              }
            },
            leading: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Image.asset('assets/img/icon_membership.png', width: 20, height: 20,),
              color: Theme.of(context).focusColor.withOpacity(1),
              onPressed: () {},
            ),
            title: Text(
              S.of(context).my_membership,
              style:  Theme.of(context).textTheme.subtitle1.merge(TextStyle(fontWeight: FontWeight.w400)),
            ),
          ),

          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushNamed('/Pages', arguments: 4);
          //   },
          //   leading: Icon(
          //     Icons.chat_outlined,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title: Text(
          //     S.of(context).messages,
          //     style:  Theme.of(context).textTheme.subtitle1.merge(TextStyle(fontWeight: FontWeight.w400)),
          //   ),
          // ),
          ListTile(
            contentPadding: EdgeInsets.only(left: 20),
            dense: true,
            title: Text(
              S.of(context).application_preferences,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.only(left: 5),
            visualDensity: VisualDensity(horizontal: 0, vertical: -3),
            horizontalTitleGap: 2,
            onTap: () {
              Navigator.of(context).popAndPushNamed('/Help');
            },
            leading: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Image.asset('assets/img/icon_help_support.png', width: 20, height: 20,),
              color: Theme.of(context).focusColor.withOpacity(1),
              onPressed: () {},
            ),
            title: Text(
              S.of(context).help__support,
              style:  Theme.of(context).textTheme.subtitle1.merge(TextStyle(fontWeight: FontWeight.w400)),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.only(left: 5),
            visualDensity: VisualDensity(horizontal: 0, vertical: -3),
            horizontalTitleGap: 2,
            onTap: () {
              if (currentUser.value.apiToken != null) {
                Navigator.of(context).popAndPushNamed('/Settings');
              } else {
                Navigator.of(context).pushNamed('/Login');
              }
            },
            leading: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Image.asset('assets/img/icon_settings.png', width: 20, height: 20,),
              color: Theme.of(context).focusColor.withOpacity(1),
              onPressed: () {},
            ),
            title: Text(
              S.of(context).settings,
              style:  Theme.of(context).textTheme.subtitle1.merge(TextStyle(fontWeight: FontWeight.w400)),
            ),
          ),

          // ListTile(
          //   contentPadding: EdgeInsets.only(left: 5),
          //   visualDensity: VisualDensity(horizontal: 0, vertical: -3),
          //   horizontalTitleGap: 2,
          //   onTap: () {
          //     Navigator.of(context).popAndPushNamed('/Languages');
          //   },
          //   leading: IconButton(
          //     icon: Image.asset('assets/img/icon_language.png', width: 20, height: 20,),
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //     onPressed: () {},
          //   ),
          //   title: Text(
          //     S.of(context).languages,
          //     style:  Theme.of(context).textTheme.subtitle1.merge(TextStyle(fontWeight: FontWeight.w400)),
          //   ),
          // ),

          // ListTile(
          //   contentPadding: EdgeInsets.only(left: 5),
          //   visualDensity: VisualDensity(horizontal: 0, vertical: -3),
          //   horizontalTitleGap: 2,
          //   onTap: () {
          //     if (Theme.of(context).brightness == Brightness.dark) {
          //       setBrightness(Brightness.light);
          //       setting.value.brightness.value = Brightness.light;
          //     } else {
          //       setting.value.brightness.value = Brightness.dark;
          //       setBrightness(Brightness.dark);
          //     }
          //     setting.notifyListeners();
          //   },
          //   leading: IconButton(
          //     icon: Image.asset('assets/img/icon_dark_mode.png', width: 20, height: 20,),
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //     onPressed: () {},
          //   ),
          //   title: Text(
          //     Theme.of(context).brightness == Brightness.dark ? S.of(context).light_mode : S.of(context).dark_mode,
          //     style:  Theme.of(context).textTheme.subtitle1.merge(TextStyle(fontWeight: FontWeight.w400)),
          //   ),
          // ),
          ListTile(
            contentPadding: EdgeInsets.only(left: 5),
            visualDensity: VisualDensity(horizontal: 0, vertical: -3),
            horizontalTitleGap: 2,
            onTap: () {
              if (currentUser.value.apiToken != null) {
                logout().then((value) {
                  Navigator.of(context).pushNamedAndRemoveUntil('/Pages', (Route<dynamic> route) => false, arguments: 2);
                });
              } else {
                Navigator.of(context).pushNamed('/Login');
              }
            },
            leading: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Image.asset('assets/img/icon_logout.png', width: 20, height: 20,),
              color: Theme.of(context).focusColor.withOpacity(1),
              onPressed: () {},
            ),
            title: Text(
              currentUser.value.apiToken != null ? S.of(context).log_out : S.of(context).login,
              style:  Theme.of(context).textTheme.subtitle1.merge(TextStyle(fontWeight: FontWeight.w400)),
            ),
          ),
          // currentUser.value.apiToken == null
          //     ? ListTile(
          //         onTap: () {
          //           Navigator.of(context).pushNamed('/SignUp');
          //         },
          //         leading: Icon(
          //           Icons.person_add_outlined,
          //           color: Theme.of(context).focusColor.withOpacity(1),
          //         ),
          //         title: Text(
          //           S.of(context).register,
          //           style:  Theme.of(context).textTheme.subtitle1.merge(TextStyle(fontWeight: FontWeight.w400)),
          //         ),
          //       )
          //     : SizedBox(height: 0),
          // setting.value.enableVersion
          //     ? ListTile(
          //         dense: true,
          //         title: Text(
          //           S.of(context).version + " " + setting.value.appVersion,
          //           style: Theme.of(context).textTheme.bodyText2,
          //         ),
          //         trailing: Icon(
          //           Icons.remove,
          //           color: Theme.of(context).focusColor.withOpacity(0.3),
          //         ),
          //       )
          //     : SizedBox(),
        ],
      ),
    );
  }
}
