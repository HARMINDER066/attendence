import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../helpers/helper.dart';
import '../models/option.dart';

class OptionItemWidget extends StatefulWidget {
  final Option option;
  final VoidCallback onChanged;

  OptionItemWidget({
    Key key,
    this.option,
    this.onChanged,
  }) : super(key: key);

  @override
  _OptionItemWidgetState createState() => _OptionItemWidgetState();
}

class _OptionItemWidgetState extends State<OptionItemWidget> with SingleTickerProviderStateMixin {
  Animation animation;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // widget.option.checked = true;
        widget.onChanged();
        Navigator.pop(context, widget.option?.name);
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child:  CachedNetworkImage(
                      fit: BoxFit.cover,
                      height: 60,
                      width: 60,
                      imageUrl: widget.option.image.thumb,
                      placeholder: (context, url) => Image.asset(
                        'assets/img/loading.gif',
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error_outline),
                    ),
                  )
                ],
              ),
              SizedBox(width: 15),
              Flexible(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.option?.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.w400,)),
                          ),
                          Visibility(visible: widget.option.description != null && widget.option.description != "",
                            child: Text(
                              Helper.skipHtml(widget.option.description),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Helper.getPrice(widget.option.price, context,  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Theme.of(context).accentColor),),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Divider(
              color: Theme.of(context).dividerColor.withOpacity(0.15),
            ),
          ),
        ],
      ),
    );
  }
}
