// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import '../managers/firebase_manager.dart';
// import '../models/product_model.dart';
// import '../views/product_overview_screen.dart';
//
// class ProductController extends GetxController {
//   final RxList<Product> _products = RxList<Product>([]);
//   List<Product> get products => _products;
//
//   final RxList<Product> _myProducts = RxList<Product>([]);
//   List<Product> get myProducts => _myProducts;
//
//   final RxList<Product> _favProducts = RxList<Product>([]);
//   List<Product> get favProducts => _favProducts;
//
//   final productNameController = TextEditingController();
//   final productDescriptionController = TextEditingController();
//   final productPriceController = TextEditingController();
//   final productStockQuantityController = TextEditingController();
//   final productCategoryController = TextEditingController();
//
//   Rx<bool> isLoading = false.obs;
//   final addFormKey = GlobalKey<FormState>();
//
//   final Rx<File?> _pickedImage = Rx<File?>(null);
//   File? get posterPhoto => _pickedImage.value;
//
//   final Rx<String> _productNameRx = "".obs;
//   final Rx<String> _productDescriptionRx = "".obs;
//
//   String get productName => _productNameRx.value;
//   String get productDescription => _productDescriptionRx.value;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchProducts();
//     fetchFavoriteProducts(firebaseAuth.currentUser!.uid);
//   }
//
//   void fetchProducts() {
//     isLoading.value = true;
//     firestore.collection('products').get().then((querySnapshot) {
//       final products = querySnapshot.docs.map((doc) {
//         final productData = doc.data();
//         final product = Product.fromMap(productData);
//
//         if (product.ownerId == firebaseAuth.currentUser!.uid) {
//           _myProducts.add(product);
//         }
//         return product;
//       }).toList();
//
//       _products.value = products;
//     });
//   }
//
//   void toggleLoading() {
//     isLoading.value = !isLoading.value;
//   }
//
//   Future<String> _uploadToStorage(File image, String id) async {
//     Reference ref = firebaseStorage.ref().child('products').child(id);
//
//     UploadTask uploadTask = ref.putFile(image);
//     TaskSnapshot snap = await uploadTask;
//     String downloadUrl = await snap.ref.getDownloadURL();
//     return downloadUrl;
//   }
//
//   Future<String> getUniqueId() async {
//     var allDocs = await firestore.collection('products').get();
//     int len = allDocs.docs.length;
//     return len.toString();
//   }
//
//   void pickImage() async {
//     final pickedImage =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       Get.snackbar('Product Picture Added!',
//           'You have successfully added your product picture!');
//     }
//     _pickedImage.value = File(pickedImage!.path);
//     update();
//   }
//
//   Future<void> addProduct(
//       String name, String description, String price, String stockQty) async {
//     if (addFormKey.currentState!.validate()) {
//       addFormKey.currentState!.save();
//       toggleLoading();
//       String id = await getUniqueId();
//       String imageUrl = await _uploadToStorage(_pickedImage.value!, id);
//       name = name.toLowerCase();
//       Product product = Product(
//         id: id,
//         name: name,
//         description: description,
//         price: int.parse(price),
//         imageUrl: imageUrl,
//         stockQuantity: int.parse(stockQty),
//         ownerId: firebaseAuth.currentUser!.uid,
//       );
//       await firestore.collection('products').doc(id).set(product.toJson());
//       toggleLoading();
//       _myProducts.add(product);
//       Get.back();
//       Get.snackbar(
//         'Success!',
//         'Product added successfully.',
//       );
//       resetFields();
//     }
//   }
//
//   Future<String> _updateToStorage(File newImage, String id) async {
//     Reference ref = firebaseStorage.ref().child('products').child(id);
//
//     await ref.delete();
//
//     UploadTask uploadTask = ref.putFile(newImage);
//     TaskSnapshot snap = await uploadTask;
//     String downloadUrl = await snap.ref.getDownloadURL();
//     return downloadUrl;
//   }
//
//   Future<String> getImageFromStorage(String id) async {
//     Reference ref = firebaseStorage.ref().child('products').child(id);
//     String downloadUrl = await ref.getDownloadURL();
//     return downloadUrl;
//   }
//
//   Future<void> updateProduct(
//     String id,
//     String name,
//     String description,
//     String price,
//     String stockQty,
//     String oldImageUrl,
//     File? image,
//     ProductController controller,
//   ) async {
//     toggleLoading();
//     String imageUrl = "";
//     if (image != null) {
//       imageUrl = await _updateToStorage(image, id);
//     } else {
//       imageUrl = oldImageUrl;
//     }
//
//     Product product = Product(
//       id: id,
//       name: name,
//       description: description,
//       ownerId: firebaseAuth.currentUser!.uid,
//       imageUrl: imageUrl,
//       price: int.parse(price),
//       stockQuantity: int.parse(stockQty),
//     );
//
//     await firestore
//         .collection('products')
//         .doc(id)
//         .update(product.toJson())
//         .whenComplete(() {
//       _productNameRx.value = product.name;
//       _productDescriptionRx.value = product.description;
//
//       toggleLoading();
//       Get.offAll(
//           ProductOverviewScreen(product: product, controller: controller));
//       Get.snackbar(
//         'Product Updated.',
//         'You have successfully updated your product.',
//       );
//       resetFields();
//     });
//   }
//
//   Future<void> deleteProduct(String productId) async {
//     await firestore.collection('products').doc(productId).delete();
//     await firebaseStorage.ref().child('products').child(productId).delete();
//   }
//
//   Future<void> toggleFavoriteStatus(Product product) async {
//     try {
//       var userDocRef =
//           firestore.collection('favorites').doc(firebaseAuth.currentUser!.uid);
//       var userDoc = await userDocRef.get();
//
//       if (userDoc.exists) {
//         var productIds = userDoc.data()?['productIds'] ?? [];
//
//         if (productIds.contains(product.id)) {
//           productIds.remove(product.id);
//           Get.snackbar('Success!', 'Product removed from favorites.');
//         } else {
//           productIds.add(product.id);
//           Get.snackbar('Success!', 'Product added to favorites.');
//         }
//
//         await userDocRef.update({'productIds': productIds});
//       } else {
//         await userDocRef.set({
//           'productIds': [product.id]
//         });
//         Get.snackbar('Success!', 'Product added to favorites.');
//       }
//
//       fetchFavoriteProducts(firebaseAuth.currentUser!.uid);
//     } catch (error) {
//       Get.snackbar('Failure!', error.toString());
//     }
//   }
//
//   Future<bool> getFavoriteStatus(String productId) async {
//     try {
//       var userDocRef =
//           firestore.collection('favorites').doc(firebaseAuth.currentUser!.uid);
//       var userDoc = await userDocRef.get();
//
//       if (userDoc.exists) {
//         var favoritesData = userDoc.data();
//         var productIds = favoritesData?['productIds'] ?? [];
//
//         return productIds.contains(productId);
//       } else {
//         return false;
//       }
//     } catch (error) {
//       Get.snackbar('Error', error.toString());
//       return false;
//     }
//   }
//
//   Future<List<Product>> fetchFavoriteProducts(String userId) async {
//     try {
//       var userDocRef = firestore.collection('favorites').doc(userId);
//       var userDoc = await userDocRef.get();
//
//       if (userDoc.exists) {
//         var favoritesData = userDoc.data();
//         var productIds = favoritesData!['productIds'] as List<dynamic>;
//
//         var favoriteProducts = <Product>[];
//
//         for (var productId in productIds) {
//           var productDocRef = firestore.collection('products').doc(productId);
//           var productDoc = await productDocRef.get();
//
//           if (productDoc.exists) {
//             var productData = productDoc.data();
//             var product = Product.fromMap(productData!);
//             favoriteProducts.add(product);
//           }
//         }
//         isLoading.value = false;
//         return favoriteProducts;
//       } else {
//         isLoading.value = false;
//         return [];
//       }
//     } catch (error) {
//       isLoading.value = false;
//       Get.snackbar('Failure!', error.toString());
//       return [];
//     }
//   }
//
//   void resetFields() {
//     productCategoryController.clear();
//     productPriceController.clear();
//     productNameController.clear();
//     productDescriptionController.clear();
//     productStockQuantityController.clear();
//     _pickedImage.value = null;
//   }
// }


import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../managers/firebase_manager.dart';
import '../models/product_model.dart';
import '../views/product_overview_screen.dart';

class ProductController extends GetxController {
  final RxList<Product> _products = RxList<Product>([]);
  List<Product> get products => _products;

  final RxList<Product> _myProducts = RxList<Product>([]);
  List<Product> get myProducts => _myProducts;

  final RxList<Product> _favProducts = RxList<Product>([]);
  List<Product> get favProducts => _favProducts;

  final productNameController = TextEditingController();
  final productDescriptionController = TextEditingController();
  final productPriceController = TextEditingController();
  final productStockQuantityController = TextEditingController();
  final productCategoryController = TextEditingController();

  Rx<bool> isLoading = false.obs;
  final addFormKey = GlobalKey<FormState>();

  final Rx<File?> _pickedImage = Rx<File?>(null);
  File? get posterPhoto => _pickedImage.value;

  final Rx<String> _productNameRx = "".obs;
  final Rx<String> _productDescriptionRx = "".obs;

  String get productName => _productNameRx.value;
  String get productDescription => _productDescriptionRx.value;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    fetchFavoriteProducts(firebaseAuth.currentUser!.uid);
  }

  void fetchProducts() {
    isLoading.value = true;
    firestore.collection('products').get().then((querySnapshot) {
      final products = querySnapshot.docs.map((doc) {
        final productData = doc.data();
        final product = Product.fromMap(productData);

        if (product.ownerId == firebaseAuth.currentUser!.uid) {
          _myProducts.add(product);
        }
        return product;
      }).toList();

      _products.value = products;
      isLoading.value = false;
    });
  }

  void toggleLoading() {
    isLoading.value = !isLoading.value;
  }

  void pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _pickedImage.value = File(pickedImage.path);
       ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(
        content: Text('You have successfully added your product picture!'),
      ),
    );
      // Get.snackbar('Product Picture Added!', 'You have successfully added your product picture!');
      update();
    }
  }

  Future<String> uploadToCloudinary(File image) async {
    const cloudName = 'dbrosxja7';
    const uploadPreset = 'flutter_upload';

    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', image.path));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final data = json.decode(respStr);
        if (data['secure_url'] != null) {
          return data['secure_url'];
        } else {
          throw Exception('Cloudinary response missing secure_url');
        }
      } else {
        final respStr = await response.stream.bytesToString();
        debugPrint('Cloudinary Error: $respStr');
        throw Exception('Upload failed with status ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Upload Exception: $e');
      rethrow;
    }
  }

  Future<String> getUniqueId() async {
    var allDocs = await firestore.collection('products').get();
    return allDocs.docs.length.toString();
  }

  Future<void> addProduct(
      String name,
      String description,
      String price,
      String stockQty,
      ) async {
    if (addFormKey.currentState!.validate()) {
      addFormKey.currentState!.save();

      if (_pickedImage.value == null) {
         ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(
        content: Text('Please pick an image first'),
      ),
    );
        // Get.snackbar('Error', 'Please pick an image first');
        return;
      }

      toggleLoading();

      final user = firebaseAuth.currentUser;
      if (user == null) {
         ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(
        content: Text('user not logged in'),
      ),
    );
        // Get.snackbar('Error', 'User not logged in');
        toggleLoading();
        return;
      }

      try {
        String id = await getUniqueId();
        String imageUrl = await uploadToCloudinary(_pickedImage.value!);
        name = name.toLowerCase();

        Product product = Product(
          id: id,
          name: name,
          description: description,
          price: int.parse(price),
          imageUrl: imageUrl,
          stockQuantity: int.parse(stockQty),
          ownerId: user.uid,
        );

        await firestore.collection('products').doc(id).set(product.toJson());
        _myProducts.add(product);

        Get.back();
         ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(
        content: Text('Product added successfully'),
      ),
    );
        // Get.snackbar('Success!', 'Product added successfully.');
        resetFields();
      } catch (e) {
        Get.snackbar('Error', e.toString());
      } finally {
        toggleLoading();
      }
    }
  }

  Future<void> updateProduct(
      String id,
      String name,
      String description,
      String price,
      String stockQty,
      String oldImageUrl,
      File? image,
      ProductController controller,
      ) async {
    toggleLoading();
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
         ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(
        content: Text('User not logged in'),
      ),
    );
        // Get.snackbar('Error', 'User not logged in');
        toggleLoading();
        return;
      }

      String imageUrl = image != null
          ? await uploadToCloudinary(image)
          : oldImageUrl;

      Product product = Product(
        id: id,
        name: name,
        description: description,
        ownerId: user.uid,
        imageUrl: imageUrl,
        price: int.parse(price),
        stockQuantity: int.parse(stockQty),
      );

      await firestore.collection('products').doc(id).update(product.toJson());

      _productNameRx.value = product.name;
      _productDescriptionRx.value = product.description;

      Get.offAll(ProductOverviewScreen(product: product, controller: controller));
       ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(
        content: Text('You have successfully updated your product'),
      ),
    );
      // Get.snackbar('Product Updated', 'You have successfully updated your product.');
      resetFields();
    } catch (e) {
       ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(
        content: Text('Error occured while uploading product'),
      ),
    );
      // Get.snackbar('Error', e.toString());
    } finally {
      toggleLoading();
    }
  }

  Future<void> deleteProduct(String productId) async {
    await firestore.collection('products').doc(productId).delete();
  
  }

Future<void> toggleFavoriteStatus(Product product) async {
  try {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      return;
    }

    final userDocRef =
        firestore.collection('favorites').doc(user.uid);

    final userDoc = await userDocRef.get();

    List<dynamic> productIds =
        List<dynamic>.from(userDoc.data()?['productIds'] ?? []);

    String message = '';

    if (productIds.contains(product.id)) {
      productIds.remove(product.id);
      message = 'Product removed from favorites.';
    } else {
      productIds.add(product.id);
      message = 'Product added to favorites.';
    }

    await userDocRef.set({
      'productIds': productIds,
    });

    await fetchFavoriteProducts(user.uid);

    if (Get.context != null) {
      ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();

      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  } catch (error) {
    debugPrint('Favorite Error: $error');

    if (Get.context != null) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    }
  }
}
  // Future<void> toggleFavoriteStatus(Product product) async {
  //   try {
  //     final userId = firebaseAuth.currentUser!.uid;
  //     final userDocRef = firestore.collection('favorites').doc(userId);
  //     final userDoc = await userDocRef.get();

  //     List<dynamic> productIds = userDoc.data()?['productIds'] ?? [];

  //     if (productIds.contains(product.id)) {
  //       productIds.remove(product.id);
  //       Get.snackbar('Removed', 'Product removed from favorites.');
  //     } else {
  //       productIds.add(product.id);
  //       Get.snackbar('Added', 'Product added to favorites.');
  //     }

  //     await userDocRef.set({'productIds': productIds});
  //     fetchFavoriteProducts(userId);
  //   } catch (error) {
  //     Get.snackbar('Error', error.toString());
  //   }
  // }

  Future<bool> getFavoriteStatus(String productId) async {
    try {
      final userDoc = await firestore.collection('favorites')
          .doc(firebaseAuth.currentUser!.uid)
          .get();

      final productIds = userDoc.data()?['productIds'] ?? [];
      return productIds.contains(productId);
    } catch (error) {
       ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(
        content: Text('Something went wrong'),
      ),
    );
      // Get.snackbar('Error', error.toString());
      return false;
    }
  }

  Future<List<Product>> fetchFavoriteProducts(String userId) async {
    try {
      final userDoc = await firestore.collection('favorites').doc(userId).get();

      if (userDoc.exists) {
        final productIds = userDoc.data()?['productIds'] as List<dynamic>;
        List<Product> favoriteProducts = [];

        for (var productId in productIds) {
          final productDoc = await firestore.collection('products').doc(productId).get();
          if (productDoc.exists) {
            favoriteProducts.add(Product.fromMap(productDoc.data()!));
          }
        }
        _favProducts.value = favoriteProducts;
        return favoriteProducts;
      }
      return [];
    } catch (error) {
       ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(
        content: Text('An error occured'),
      ),
    );
      // Get.snackbar('Error', error.toString());
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  void resetFields() {
    productCategoryController.clear();
    productPriceController.clear();
    productNameController.clear();
    productDescriptionController.clear();
    productStockQuantityController.clear();
    _pickedImage.value = null;
    _productNameRx.value = '';
    _productDescriptionRx.value = '';
  }
}
