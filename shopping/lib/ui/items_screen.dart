import 'package:flutter/material.dart';
import '../util/dbhelper.dart';
import '../models/list_items.dart';
import '../models/shopping_list.dart';
import '../ui/item_dialog.dart';

class ItemsScreen extends StatefulWidget {
  final ShoppingList shoppingList;

  ItemsScreen(this.shoppingList);

  @override
  _ItemsScreenState createState() => _ItemsScreenState(this.shoppingList);
}

class _ItemsScreenState extends State<ItemsScreen> {
  final ShoppingList shoppingList;
  DbHelper helper;
  List<ListItem> items;
  ItemsDialog itemsDialog;

  @override
  void initState() {
    itemsDialog = ItemsDialog();
    super.initState();
  }

  _ItemsScreenState(this.shoppingList);

  @override
  Widget build(BuildContext context) {
    helper = DbHelper();
    showData(this.shoppingList.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(shoppingList.name),
      ),
      body: ListView.builder(
        itemCount: (items != null) ? items.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(items[index].name),
            onDismissed: (direction) {
              String strName = items[index].name;
              helper.deleteItem(items[index]);

              setState(() {
                items.removeAt(index);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$strName deleted')),
              );
            },
            child: ListTile(
              title: Text(items[index].name),
              subtitle: Text(
                'Quantity: ${items[index].quantity} - Note: ${items[index].note}',
              ),
              onTap: () {},
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => itemsDialog.buildDialog(
                      context,
                      items[index],
                      false,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => itemsDialog.buildDialog(
              context,
              ListItem(0, this.shoppingList.id, '', '', ''),
              true,
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }

  Future<void> showData(int idList) async {
    await helper.openDb();
    items = await helper.getItems(idList);
    setState(() {
      items = items;
    });
  }
}
