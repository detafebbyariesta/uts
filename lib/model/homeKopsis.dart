import 'package:flutter/material.dart';
import 'package:uts/model/entryformKopsis.dart';
import 'package:uts/dbhelper/dbhelperKopsis.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import '../model/itemKopsis.dart'; //pendukung program asinkron

class HomeKopsis extends StatefulWidget {
  @override
  HomeKopsisState createState() => HomeKopsisState();
}

class HomeKopsisState extends State<HomeKopsis> {
  DbHelperKopsis dbHelperKopsis = DbHelperKopsis();
  int count = 0;
  List<ItemKopsis> itemKopsisList;
  @override
  Widget build(BuildContext context) {
    updateListView();
    if (itemKopsisList == null) {
      itemKopsisList = List<ItemKopsis>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Center(child:
        Text('Nama Penjual Kopsis')),
      ),
      body: Column(children: [
        Expanded(
          child: createListView(),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: double.infinity,
            child: RaisedButton(
              child: Text("Tambah Nama"),
              onPressed: () async {
                var itemKopsis = await navigateToEntryForm(context, null);
                if (itemKopsis != null) {
//TODO 2 Panggil Fungsi untuk Insert ke DB
                  int result = await dbHelperKopsis.insert(itemKopsis);
                  if (result > 0) {
                    updateListView();
                  }
                }
              },
            ),
          ),
        ),
      ]),
    );
  }

  Future<ItemKopsis> navigateToEntryForm(BuildContext context, ItemKopsis itemkopsis) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return EntryForm(itemkopsis);
    }));
    return result;
  }

  ListView createListView() {
    TextStyle textStyle = Theme.of(context).textTheme.headline5;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.ad_units),
            ),
            title: Text(
              this.itemKopsisList[index].namaKopsis,
              style: textStyle,
            ),
            subtitle: Text(
              "Tanggal : " + this.itemKopsisList[index].tanggal.toString()),
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () async {
//TODO 3 Panggil Fungsi untuk Delete dari DB berdasarkan Item
              dbHelperKopsis.delete(this.itemKopsisList[index].id);
              updateListView();
              },
            ),
            onTap: () async {
              var itemKopsis =
                  await navigateToEntryForm(context, this.itemKopsisList[index]);
//TODO 4 Panggil Fungsi untuk Edit data
              int result = await 
              dbHelperKopsis.update(itemKopsis);
              updateListView();
            },
          ),
        );
      },
    );
  }

//update List item
  void updateListView() {
    final Future<Database> dbFuture = dbHelperKopsis.initDb();
    dbFuture.then((database) {
//TODO 1 Select data dari DB
      Future<List<ItemKopsis>> itemKopsisListFuture = dbHelperKopsis.getItemKopsisList();
      itemKopsisListFuture.then((itemKopsisList) {
        setState(() {
          this.itemKopsisList = itemKopsisList;
          this.count = itemKopsisList.length;
        });
      });
    });
  }
}