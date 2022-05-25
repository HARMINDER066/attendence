import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../elements/CircularLoadingWidget.dart';
import '../models/media.dart';
import '../controllers/gallery_controller.dart';

class GalleryWidget extends StatefulWidget{

  RouteArgument routeArgument;

  GalleryWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _GalleryWidgetState createState() {
    return _GalleryWidgetState();
  }
}
class _GalleryWidgetState extends StateMVC<GalleryWidget> {

  GalleryController _con;

  _GalleryWidgetState() : super(GalleryController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.media = widget.routeArgument.param['media'] as List<Media>;
    _con.heroTag = widget.routeArgument.heroTag ;
    _con.current = widget.routeArgument.param['current'] as Media;
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        title: Text(
          S.of(context).galleries,
          style: Theme.of(context).textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white70),
          onPressed: () => {Navigator.of(context).pop()},
        ),
        elevation: 0,
      ),
      body: SafeArea(
/*          !(controller.current.value.hasData)
              ? CircularLoadingWidget(height: 300)
              : SizedBox(),*/
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Hero(
                tag: _con.heroTag + _con.current.id,
                child: CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: false,
                    viewportFraction: 1.0,
                    height: double.infinity,
                    initialPage: _con.media.indexOf(_con.current),
                    onPageChanged: (index, reason) {
                      print(_con.media.length);
                      _con.current = _con.media.elementAt(index);
                    },
                  ),
                  items: _con.media.map((Media _media) {
                    return InteractiveViewer(
                      scaleEnabled: true,
                      panEnabled: true,
                      // Set it to false to prevent panning.
                      minScale: 0.5,
                      maxScale: 4,
                      child: Container(
                        width: double.infinity,
                        alignment: AlignmentDirectional.center,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: CachedNetworkImage(
                            width: double.infinity,
                            fit: BoxFit.contain,
                            imageUrl: _media.url,
                            placeholder: (context, url) => CircularLoadingWidget(height: 200),
                            errorWidget: (context, url, error) => Icon(Icons.error_outline),
                          ),
                        )
                      ),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                  child:Text(
                    _con.current.name ?? '',
                    maxLines: 2,
                    style: Theme.of(context).textTheme.bodyText2.merge(
                      TextStyle(
                        color: Theme.of(context).primaryColor,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 6.0,
                            color: Theme.of(context).hintColor.withOpacity(0.6),
                          ),
                        ],
                      ),
                    ),
                 ),
              ),
            ],
          ),
        ),
    );
  }
}
