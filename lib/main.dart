import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

//main app entrance
//void main() => runApp(new ShoppingList(<Product>[
//      new Product(name: 'zy'),
//      new Product(name: 'zy1'),
//      new Product(name: 'zy2'),
//    ]));

void main() {
  runApp(new MaterialApp(
    title: 'test shopping list',
    home: new MyApp(),
    theme: new ThemeData(brightness: Brightness.dark,primaryColor: Colors.red,accentColor:Colors.red),
  ));
}

//ThemeData

//App主体
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'THIS IS A MATERIAL APP',
      home: new RandomWords(),
      theme: new ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.yellow,
        textTheme: new TextTheme(title: new TextStyle(color: Colors.blue)),
      ),
    );
  }
}

//home
class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RandomWordsState();
  }
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];

  final _alreadySaved = new Set<WordPair>();

  final _biggerFont = const TextStyle(fontSize: 18.0);

  void _pushSaved() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      final tiles = _alreadySaved.map((word) {
        return new ListTile(
          title: new Text(
            word.asPascalCase,
            style: _biggerFont,
          ),
        );
      });
      final divided =
          ListTile.divideTiles(context: context, tiles: tiles).toList();

      return new Scaffold(
        appBar: new AppBar(
          title: new Text('saved Suggestions'),
        ),
        body: new ListView(
          children: divided,
        ),
        floatingActionButton: new FloatingActionButton(
            tooltip: 'Add',
            child: new Icon(Icons.ring_volume),
            onPressed: null),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Title",style: Theme.of(context).textTheme.title,),
        leading: null,
        automaticallyImplyLeading: true,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return new Divider();
          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(1));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair suggestion) {
    final alreadySaved = _alreadySaved.contains(suggestion);
    return new ListTile(
      title: new Text(
        suggestion.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (_alreadySaved.contains(suggestion)) {
            _alreadySaved.remove(suggestion);
          } else {
            _alreadySaved.add(suggestion);
          }
        });
      },
    );
  }
}

// a counter widget and it's child widget
/*1.child widget counter-display*/
class CounterDisplay extends StatelessWidget {
  final int count;

  CounterDisplay({this.count});

  @override
  Widget build(BuildContext context) {
    return new Text('Count : $count');
  }
}

/*2.child widget counter-calculator*/
class CounterIncrementor extends StatelessWidget {
  final VoidCallback tapCallback;

  CounterIncrementor({this.tapCallback});

  @override
  Widget build(BuildContext context) {
    return new RaisedButton(
      onPressed: tapCallback,
      child: new Text('RaiseButton'),
    );
  }
}

//3. parent widget Counter
class Counter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new CounterState();
}

class CounterState extends State<Counter> {
  int _count = 0;

  void _increment() {
    setState(() {
      _count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new CounterIncrementor(tapCallback: _increment),
        new CounterDisplay(
          count: _count,
        )
      ],
    );
  }
}

/*** Shopping List Example**/

//Product class
class Product {
  final String name;

  const Product({this.name});
}

typedef void CartChangedCallback(Product product, bool inChart);

//Shopping Item
class ShoppingListItem extends StatelessWidget {
  final Product product;
  final bool isChart;
  final CartChangedCallback cartChangedCallback;

  ShoppingListItem(Product product, this.isChart, this.cartChangedCallback)
      : this.product = product,
        super(key: new ObjectKey(product));

  TextStyle _getTextStyle(BuildContext context) {
    if (!isChart) return null;
    return new TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different parts of the tree
    // can have different themes.  The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return isChart ? Colors.black54 : Theme.of(context).primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return new ListTile(
        onTap: () {
          cartChangedCallback(product, isChart);
        },
        leading: new CircleAvatar(backgroundColor: _getColor(context)),
        title: new Text(product.name, style: _getTextStyle(context)));
  }
}

//ShoppingListItem
class ShoppingList extends StatefulWidget {
  final List<Product> products;

  ShoppingList(List<Product> products) : this.products = products;

  @override
  State<StatefulWidget> createState() => new _ShoppingListState();
}

//ShoppingListState
class _ShoppingListState extends State<ShoppingList> {
  Set<Product> _shoppingCart = new Set<Product>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Shopping List'),
      ),
      body: new ListView(
        padding: new EdgeInsets.symmetric(vertical: 8.0),
        children: widget.products.map((Product product) {
          return new ShoppingListItem(product, _shoppingCart.contains(product),
              _handleCartStateChanged);
        }).toList(),
      ),
    );
  }


  @override
  void dispose() {
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
  }

  void _handleCartStateChanged(Product product, bool inCart) {
    setState(() {
      if (!inCart) {
        _shoppingCart.add(product);
      } else {
        _shoppingCart.remove(product);
      }
    });
  }
}
