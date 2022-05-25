
import '../models/media.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class GalleryController extends ControllerMVC {
  var media = List<Media>();
  var current = Media();
  var heroTag = '';

  @override
  void initState() async {
    super.initState();
  }

}
