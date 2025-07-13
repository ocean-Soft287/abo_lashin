import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constans/constants.dart';
import '../../../../core/network/remote/diohelper.dart';
import '../../../../core/network/remote/encrupt.dart';
import '../../../../core/network/remote/end_point.dart';
import '../model/add_item.dart';
import '../model/all_address_model.dart';
import '../model/discountCodeModel.dart';
import '../model/order_summry_model.dart';
import '../model/sales_basket.dart';
import 'add_order_state.dart';

class AddOrderCubit extends Cubit<AddOrderState> {
  AddOrderCubit() : super(InitializeAddOrder());

  OrderSummryModel? orderSummryModel;
  void addOrder({
    required String customName,
    required double total,
    required dynamic listItem,
    required dynamic districtName,
    required dynamic regionName,
    required String email,
    required String customerAddress,
    required num addition,
    required num discount,
    required String discountCode,
    required String notes,
  }) {
    emit(AddOrderLoading());

    final filteredOrderList = listItem.map((item) {
      return {
        "ItemID": item["productId"],
        "Quantity": item["quantity"],
        "Price": item["priceAfterDiscount"],
        "Barcode": item["barcode"],
      };
    }).toList();

    final rawData = {
      "OrderDate": DateFormat('yyyy-MM-dd', 'en').format(DateTime.now()),
      "CustomerPhone": customerPhone,
      "CustomerName": customName,
      "DistrictName": districtName,
      "PayID": 0,
      "RegionName": regionName,
      "TotalValue": total,
      "OrderAddress": customerAddress,
      "Discount": discount,
      "Additions": addition,
      "FinalValue": ((total - discount) + addition),
      "OnlineStoreId": -1,
      "OrderItems": filteredOrderList,
      "Details":notes,
    };
    try {
      final encryptedData = encryptData(rawData, privateKey, publicKey);
      print(jsonEncode(encryptedData));
      DioHelper.postData(url: '/api/Order', data: jsonEncode(encryptedData)).then((value) {
        try {
          final decryptedResponse = decrypt(value.data, privateKey, publicKey);
print(decryptedResponse);
          //   final decodedJson = jsonDecode(decryptedResponse);
          orderSummryModel = OrderSummryModel.fromJson(rawData);

          emit(AddOrderSuccess(orderSummryModel,filteredOrderList,decryptedResponse));
        } catch (e) {
          emit(AddOrderError(e.toString()));
        }
      });
    } catch (e) {
      emit(AddOrderError(e.toString()));
    }
  }






  int pageNumberSalesBasket = 1;
  bool salesBasketLoading = true;
  List<SalesBasket> salesBasketList = [];

  void getCustomerSalesBasket({bool fromPagination = true}) {
    items.clear();
    if (fromPagination) {
    } else {
      emit(GetCustomerSalesBasketLoading());
    }

    DioHelper.getData(
          url: '/api/Product/GetCustomerSalesBasket?CustomerID=$customerid',
        )
        .then((value) {
          final decryptedText = decrypt(value.data, privateKey, publicKey);

          List<dynamic> jsonList = jsonDecode(decryptedText);

          salesBasketLoading = false;
          pageNumberSalesBasket++;
          salesBasketList.addAll(
            jsonList.map((json) => SalesBasket.fromJson(json)),
          );

          for (var item in salesBasketList) {
            final newItem = CartItem(
              quantity: int.parse(item.salesQuantity.toString()),
              itemId: item.productID.toString(),
              price: double.parse(item.price.toString()),
            );
            items.add(newItem);
          }
          emit(GetCustomerSalesBasketSuccess());
        })
        .catchError((error) {
          emit(GetCustomerSalesBasketError());
        });
  }

  void addItem({required dynamic productId, context}) {
    emit(AddItemSalesBasketLoading());
    {}
    String encryptedData = encryptData(
      {"CustomerID": customerid, "ProductID": productId},
      privateKey,
      publicKey,
    );
 //   final decryptedText = decrypt(encryptedData, privateKey, publicKey);

    String jsonData = jsonEncode(encryptedData);

    DioHelper.postData(url: '/api/Product/AddSalesBasket', data: jsonData)
        .then((value) {
        //  final decryptedText = decrypt(value.data, privateKey, publicKey);
          getQuitity();
          // BlocProvider.of<HomeCubit>(context).addItem(productId: productId, quantity: 1, isVisibility: true);
          emit(AddItemSalesBasketSuccess());
        })
        .catchError((error) {
          emit(AddItemSalesBasketError());
        });
  }

  void decreaseItem({required dynamic productId}) {
    emit(DecreaseSalesBasketLoading());
    {}

    DioHelper.deleteData(
          url:
              '/api/Product/DeleteSalesBasket?CustomerID=$customerid&ProductId=$productId',
        )
        .then((value) {
          final decryptedText = decrypt(value.data, privateKey, publicKey);

          emit(DecreaseSalesBasketSuccess());
        })
        .catchError((error) {
          emit(DecreaseSalesBasketError());
        });
  }

  List<CartItem> items = [];

  void addItemCart({
    required int quantity,
    required String itemId,
    required double price,
  }) {
    bool itemFound = false;

    for (var item in items) {
      if (item.itemId == itemId) {
        item.quantity += quantity;
        emit(AddItemInCart());
        addItem(productId: item.itemId);
        itemFound = true;
        break;
      }
    }

    if (!itemFound) {
      final newItem = CartItem(
        quantity: quantity,
        itemId: itemId,
        price: price,
      );
      items.add(newItem);
      emit(AddItemInCart());
    }
  }

  void printCart() {
    if (items.isEmpty) {
      return;
    }

    for (var item in items) {}
  }

  void subtractItemCart({
    required int quantity,
    required String itemId,
    required int index,
  }) {
    for (var item in items) {
      if (item.itemId == itemId) {
        item.quantity -= quantity;

        if (item.quantity <= 0) {
          items.remove(item);
          salesBasketList.removeAt(index);

          emit(RemoveItemFromCart());
          decreaseItem(productId: itemId);
        } else {
          emit(SubtractItemFromCart());
          decreaseItem(productId: itemId);
        }
        return;
      }
    }
  }

  int getQuantity(String itemId) {
    for (var item in items) {
      if (item.itemId == itemId) {
        return item.quantity;
      }
    }
    return 1;
  }

  double totalPrice = 0.0;
  double calculateTotalPrice() {
    totalPrice = 0.0;

    for (var item in items) {
      totalPrice += item.quantity * item.price;
    }

    return totalPrice;
  }

  void getQuitity() {
    emit(ChangeQUtityCart());
  }

  List<dynamic> governoratesList = [];

  void getGovernorates() {
    emit(GetGovernoratesLoading());
    DioHelper.getData(url: Endpoints.governorates)
        .then((value) {
          if (value.statusCode == 200) {
            final decryptedText = decrypt(value.data, privateKey, publicKey);

        //    List<dynamic> jsonList = jsonDecode(decryptedText);

            // mainCategoryList =
            //     jsonList.map((json) => MainCategoryModel.fromJson(json)).toList();

            emit(GetGovernoratesSuccess());
          } else {
            emit(GetGovernoratesError());
          }
        })
        .catchError((error) {
          emit(GetGovernoratesError());
        });
  }

  List<AllAddressModel> allAddressList = [];
  void getAllAddress() {
    emit(GetGAllAddressLoading());
    DioHelper.getData(
          url: '/api/Customers/GetCustomerAddress?CustomerPhone=$customerPhone',
        )
        .then((value) {
          if (value.statusCode == 200) {
            final decryptedText = decrypt(value.data, privateKey, publicKey);

            List<dynamic> jsonList = jsonDecode(decryptedText);

            allAddressList =
                jsonList.map((json) => AllAddressModel.fromJson(json)).toList();

            emit(GetGAllAddressSuccess());
          } else {
            emit(GetGAllAddressError());
          }
        })
        .catchError((error) {
          emit(GetGAllAddressError());
        });
  }

  int selectAddress = 0;
  void changeSelectedAddress(int index) {
    selectAddress = index;
    emit(ChangeSelectedAddress());
  }

  List<DiscountCodeModel> discountList = [];
  void getDiscount({required var codeDiscount}) {
    emit(GetDiscountLoading());
    DioHelper.getData(url: Endpoints.couponsDiscountCode(codeDiscount))
        .then((value) {
          // print(value.data);
          if (value.statusCode == 200) {
            final decryptedText = decrypt(value.data, privateKey, publicKey);

            List<dynamic> jsonList = jsonDecode(decryptedText);

            discountList =
                jsonList
                    .map((json) => DiscountCodeModel.fromJson(json))
                    .toList();

            emit(GetDiscountSuccess());
          } else {
            emit(GetDiscountError());
          }
        })
        .catchError((error) {
          // print(
          //     'Error In Function Get Discount This Error ${error.toString()}');
          emit(GetDiscountError(error: error.toString()));
        });
  }

  Future<String> checkCustomerIsActive() async {
    try {
      final response = await DioHelper.getData(url: Endpoints.customerIsActive);

      if (response.statusCode == 200) {
        final decryptedText = decrypt(response.data, privateKey, publicKey);

        return decryptedText;
      } else {
        return "False";
      }
    } catch (error) {
      return "False";
    }
  }
}
