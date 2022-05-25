import '../models/category.dart';
import '../repository/category_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class AllCategoriesController extends ControllerMVC {

  List<Category> categories = <Category>[];

  AllCategoriesController() {
    listenForCategories();
  }

  Future<void> listenForCategories() async {
    final Stream<Category> stream = await getCategories("");
    stream.listen((Category _category) {
      setState(() => categories.add(_category));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }


  Future<void> refreshAllCategoriesProduct() async {
    setState(() {
      categories = <Category>[];
    });
    await listenForCategories();
  }

}