import 'package:flutter/material.dart';
import 'package:hvz_flutter_app/utilities/loadingDialogManager.dart';
import 'package:hvz_flutter_app/utilities/apiManager.dart';
import 'package:hvz_flutter_app/models/player/tagLists.dart';

class PendingTagStunWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PendingTagStunState();
}

class _PendingTagStunState extends State<PendingTagStunWidget> {
  final LoadingDialogManager _loadingDialogManager = LoadingDialogManager();
  final APIManager _apiManager = APIManager();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getPendingTags();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text("Weeeee");
  }

  Future<TagLists> _getPendingTags() async {
    return _apiManager.getStunTags();
  }
}