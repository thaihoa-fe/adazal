import '../providers/orders.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final OrderItemProvider orderItem;

  OrderItem(this.orderItem);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  void toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('${widget.orderItem.amount} \$'),
            subtitle: Text(
                '${DateFormat.yMMMMEEEEd().format(widget.orderItem.dateTime)}'),
            trailing: IconButton(
              icon:
                  Icon(_expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              onPressed: toggleExpanded,
            ),
          ),
          if (_expanded)
            Container(
              height: (widget.orderItem.products.length * 40).toDouble(),
              child: ListView.builder(
                itemCount: widget.orderItem.products.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14.0,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            widget.orderItem.products[i].title,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text('${widget.orderItem.products[i].quantity}x'),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${widget.orderItem.products[i].price} \$',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
        ],
      ),
    );
  }
}
