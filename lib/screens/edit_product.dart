import 'package:adazal_app/providers/product.dart';
import 'package:adazal_app/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static final routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _editingProduct = Product.empty();
  var _showLoading = false;

  @override
  void initState() {
    super.initState();

    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  String get title {
    return _editingProduct.id == null ? 'Add new product' : 'Edit product';
  }

  void _saveProduct() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    final productsProvider = Provider.of<ProductsProvider>(
      context,
      listen: false,
    );
    setState(() {
      _showLoading = true;
    });
    try {
      if (_editingProduct.id == null) {
        await productsProvider.addProduct(_editingProduct);
      } else {
        await productsProvider.editProduct(_editingProduct);
      }
    } catch (error) {
      setState(() {
        _showLoading = false;
      });
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error occurred!'),
            content: Text('Something went wrong'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okey'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        _showLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    String productId = ModalRoute.of(context).settings.arguments;
    if (productId == null) {
      return;
    }
    final productsProvider = Provider.of<ProductsProvider>(
      context,
      listen: false,
    );
    final product = productsProvider.findById(productId);

    _editingProduct = product.copyWith();
    _imageUrlTextController.text = _editingProduct.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveProduct,
          )
        ],
      ),
      body: _showLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      initialValue: _editingProduct.title,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editingProduct =
                            _editingProduct.copyWith(title: value);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      focusNode: _priceFocusNode,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      initialValue: '${_editingProduct.price}',
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editingProduct = _editingProduct.copyWith(
                          price: double.parse(value),
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a value that greater than zero';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      focusNode: _descriptionFocusNode,
                      decoration: InputDecoration(labelText: 'Description'),
                      textInputAction: TextInputAction.next,
                      initialValue: _editingProduct.description,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      onSaved: (value) {
                        _editingProduct =
                            _editingProduct.copyWith(description: value);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        if (value.length < 10) {
                          return 'Please enter minimum 10 characters long';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          child: _imageUrlTextController.text.isEmpty
                              ? Align(
                                  alignment: Alignment.center,
                                  child: Text('No image'),
                                )
                              : Container(
                                  margin: const EdgeInsets.all(8.0),
                                  child: FittedBox(
                                    child: Image.network(
                                        _imageUrlTextController.text),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          decoration: BoxDecoration(
                              border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          )),
                          margin: const EdgeInsets.only(top: 8, right: 8),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _imageUrlTextController,
                            decoration: InputDecoration(labelText: 'Image Url'),
                            keyboardType: TextInputType.url,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) => _saveProduct(),
                            onSaved: (value) {
                              _editingProduct = _editingProduct.copyWith(
                                imageUrl: value,
                              );
                            },
                            validator: _checkImageUrl,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  String _checkImageUrl(String value) {
    if (value.isEmpty) {
      return 'Please provide a value';
    }
    var urlPattern =
        r"(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
    var result = new RegExp(urlPattern, caseSensitive: false).firstMatch(value);
    if (result == null) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
  }
}
