import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(microseconds: 1000),
      curve: Curves.easeIn,
      height:
          _expanded ? min(widget.order.products.length * 20.0 + 200, 200) : 100,
      // height: _heightAnimation.value.height,
      constraints: BoxConstraints(
        minHeight: _expanded
            ? min(widget.order.products.length * 20.0 + 200, 200)
            : 100,
      ),

      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
              subtitle: Text(
                DateFormat('dd/MM/yyy-hh:mm').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(microseconds: 1000),
              curve: Curves.easeIn,
              height: _expanded
                  ? min(widget.order.products.length * 20.0 + 30, 200)
                  : 0,
              // height: _heightAnimation.value.height,
              constraints: BoxConstraints(
                minHeight: _expanded
                    ? min(widget.order.products.length * 20.0 + 30, 200)
                    : 0,
              ),

              // height: min(widget.order.products.length * 20.0 + 30, 150),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: ListView(
                children: widget.order.products
                    .map((prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: 200,
                              child: Text(
                                prod.title,
                                softWrap: true,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              '${prod.quantity}x \$${prod.price}',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            )
                          ],
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
