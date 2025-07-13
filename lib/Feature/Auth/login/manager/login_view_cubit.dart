import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/remote/diohelper.dart';
import '../../../../core/network/remote/encrupt.dart';
import '../data/model/customer_model.dart';
import 'login_view_state.dart';
class LoginViewCubit extends Cubit<LoginViewState> {
  LoginViewCubit() : super(InitializeLoginViewState());

  void userLogin({required String customerPhone, required String password}) {
    emit(LoginViewStateLoading());
    DioHelper.getData(
          url:
              '/api/Customer/Login?CustomerPhone=$customerPhone&passWord=$password&Token=1111',
        )
        .then((value) {
          //url: '/api/Customer/Login?CustomerPhone=94440596&passWord=123456&Token=$token').then((value) {

          final decryptedText = decrypt(value.data, privateKey, publicKey);
      //    dynamic jsonString = jsonEncode(decryptedText);

          if (value.data == "cXmUR9z1mAe20wCqm1ZR3Q==") {
            emit(LoginViewStateError(value.data));
          } else {
            Map<String, dynamic> customerMap = jsonDecode(decryptedText);

            // إنشاء كائن Customer من JSON
            Customer customer = Customer.fromJson(customerMap);


            emit(LoginViewStateSuccess(customer));

          }
        })
        .catchError((error) {
          emit(LoginViewStateError(error.toString()));
        });
  }

  bool isPassword = true;
  IconData subfix = Icons.visibility_off;
  void changIconPassword() {
    isPassword = !isPassword;
    subfix = isPassword ? Icons.visibility_off : Icons.visibility;
    emit(ChangeIconPasswordSuccess());
  }
}

// class CounterBox extends StatefulWidget {
//   const CounterBox({super.key, this.initialCount});
//   final int? initialCount;
//
//   @override
//   State<CounterBox> createState() => _CounterBoxState();
// }
//
// class _CounterBoxState extends State<CounterBox> {
//   late int _counter;
//
//   @override
//   void initState() {
//     super.initState();
//     _counter = widget.initialCount ?? 0;
//   }
//
//   void _increment() {
//     setState(() {
//       _counter++;
//     });
//   }
//
//   void _decrement() {
//     if (_counter > 0) {
//       setState(() {
//         _counter--;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
//       IntrinsicWidth(
//           child: AnimatedContainer(
//               duration: Duration(milliseconds: 200),
//               height: 25.h,
//               padding: EdgeInsets.symmetric(horizontal: _counter > 0 ? 6.w : 0),
//               decoration: BoxDecoration(
//                   color: AppColors.white,
//                   borderRadius: BorderRadius.circular(8.r),
//                   boxShadow: [
//                     BoxShadow(color: Colors.grey.shade300, blurRadius: 5)
//                   ]),
//               margin: EdgeInsets.only(bottom: 6.h),
//               child: Row(mainAxisSize: MainAxisSize.min, children: [
//                 if (_counter > 0)
//                   IconButton(
//                       padding: EdgeInsets.zero,
//                       constraints: BoxConstraints(),
//                       icon: Icon(Icons.remove,
//                           color: AppColors.primary, size: 15.sp),
//                       onPressed: _decrement),
//                 if (_counter > 0)
//                   Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 4.w),
//                       child: CustomText('$_counter', style: Styles.textStyle16_400)),
//                 IconButton(
//                     padding: EdgeInsets.zero,
//                     constraints: BoxConstraints(),
//                     icon:
//                     Icon(Icons.add, color: AppColors.primary, size: 15.sp),
//                     onPressed: _increment)
//               ]))),
//       Gap(12.w)
//     ]);
//   }
// }

// class CounterBox extends StatelessWidget {
//   final int productId;
//   final String nameAr;
//   final String nameEn;
//   final double priceBeforeDiscount;
//   final double priceAfterDiscount;
//   final String image;
//   final num customerQuantity;
//   final num stockQuantity;
//   final String barcode;
//
//
//   const CounterBox({
//     super.key,
//     required this.productId,
//     required this.nameAr,
//     required this.nameEn,
//     required this.priceBeforeDiscount,
//     required this.priceAfterDiscount,
//     required this.image,
//     required  this.customerQuantity,
//     required this.stockQuantity,
//     required this.barcode,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CartCubit, List<CartItem>>(
//       builder: (context, cart) {
//         int itemCount = context.read<CartCubit>().getItemCount(
//           customerQuantity:customerQuantity ,
//             barcode:barcode ,
//             stockQuantity:stockQuantity ,
//             nameEn:nameEn ,nameAr:nameAr ,price:priceBeforeDiscount
//             ,
//           image:image ,
//           priceAfterDiscount:priceAfterDiscount ,productId: productId,
//             );
//
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             IntrinsicWidth(
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 height: 30.h,
//
//                 padding: EdgeInsets.symmetric(horizontal: itemCount > 0 ? 6.w : 0),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8.r),
//                   boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
//                 ),
//                 margin: EdgeInsets.only(bottom: 6.h),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     if (itemCount > 0)
//                       IconButton(
//                         padding: EdgeInsets.zero,
//                         constraints: const BoxConstraints(),
//                         icon: Icon(Icons.remove, color: AppColors.mainAppColor, size: 15.sp),
//                         onPressed: () => context.read<CartCubit>().removeItem( barcode: barcode),
//                       ),
//                     if (itemCount > 0)
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 4.w),
//                         child: Text('$itemCount'),
//                       ),
//                     IconButton(
//                       padding: EdgeInsets.zero,
//                       constraints: const BoxConstraints(),
//                       icon: Icon(Icons.add, color: AppColors.mainAppColor, size: 15.sp),
//                       onPressed: () => context.read<CartCubit>().addItem(
//                         customerQuantity:stockQuantity ,
//                         barcode: barcode,
//                         stockQuantity: stockQuantity,
//                         image:image ,
//                         productId: productId,
//                         nameAr: nameAr,
//                         nameEn: nameEn,
//                         priceBeforeDiscount: priceBeforeDiscount,
//                         priceAfterDiscount: priceAfterDiscount,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
//
// class CartCubit extends Cubit<List<CartItem>> {
//   CartCubit() : super([]);
//
//
//   int getItemCount({ required int productId,
//       required String image,
//       required String nameAr,
//       required String nameEn,
//     required num customerQuantity,
//     required num stockQuantity,
//     required String barcode,
//       required double price,
//       required double priceAfterDiscount}) {
//     return state.firstWhere((item) => item.barcode== barcode, orElse: () => CartItem(
//       image: image,
//         stockQuantity: stockQuantity,
//         barcode:barcode ,
//         customerQuantity: customerQuantity,
//         productId: productId, nameAr: nameAr, nameEn: nameEn, quantity: 0, priceBeforeDiscount: price, priceAfterDiscount: priceAfterDiscount
//     )).quantity;
//   }
//   double calculateTotalPrice() {
//     double totalPrice = 0.0;
//     for (var item in state) {
//       totalPrice += item.quantity * item.priceAfterDiscount;
//     }
//     return totalPrice;
//   }
//   /// إضافة منتج إلى السلة أو زيادة الكمية
//   void addItem({
//     required int productId,
//     required String nameAr,
//     required String nameEn,
//     required num customerQuantity,
//     required num stockQuantity,
//     required String barcode,
//     required double priceBeforeDiscount,
//     required double priceAfterDiscount,
//     required String image,
//   }) {
//     final newState = List<CartItem>.from(state);
//     final index = newState.indexWhere((item) => item.barcode == barcode);
//
//     if (index != -1) {
//       // التأكد من عدم تجاوز الكمية المتاحة في المخزون
//       if (newState[index].quantity < stockQuantity) {
//         newState[index] = newState[index].copyWith(quantity: newState[index].quantity + 1);
//       } else {
//         print("لا يمكن إضافة المزيد، المخزون المتاح: $stockQuantity");
//       }
//     } else {
//       if (stockQuantity > 0) { // لا يسمح بإضافة المنتج إذا كان المخزون صفر
//         newState.add(CartItem(
//           image: image,
//           productId: productId,
//           nameAr: nameAr,
//           nameEn: nameEn,
//           quantity: 1,
//           stockQuantity: stockQuantity,
//           barcode: barcode,
//           customerQuantity: customerQuantity,
//           priceBeforeDiscount: priceBeforeDiscount,
//           priceAfterDiscount: priceAfterDiscount,
//         ));
//       } else {
//         print("لا يمكن إضافة المنتج، المخزون صفر");
//       }
//     }
//
//     emit(newState);
//   }
//
//   /// إزالة منتج من السلة أو تقليل الكمية
//   void removeItem({required var barcode}) {
//     final newState = List<CartItem>.from(state);
//     final index = newState.indexWhere((item) => item.barcode == barcode);
//
//     if (index != -1) {
//       if (newState[index].quantity > 1) {
//         newState[index] = newState[index].copyWith(quantity: newState[index].quantity - 1);
//       } else {
//         newState.removeAt(index);
//       }
//       emit(newState);
//     }
//   }
//
//   void clearCart() {
//     print("قبل التفريغ: ${state.length} عناصر");
//     emit([]);
//     print("بعد التفريغ: ${state.length} عناصر");
//   }
// }
// class CartItem {
//   final int productId;
//   final String image;
//   final String nameAr;
//   final String nameEn;
//   final int quantity;
//   final double priceBeforeDiscount;
//   final double priceAfterDiscount;
//   final num customerQuantity;
//   final num stockQuantity;
//   final String barcode;
//
//   CartItem({
//     required this.productId,
//     required this.nameAr,
//     required this.nameEn,
//     required this.quantity,
//     required this.priceBeforeDiscount,
//     required this.priceAfterDiscount,
//     required this.image,
//     required this.customerQuantity,
//     required this.stockQuantity,
//     required this.barcode,
//   });
//
//   CartItem copyWith({
//     int? quantity,
//     int? customerQuantity,
//     int? stockQuantity,
//     String? barcode,
//   }) {
//     return CartItem(
//       productId: productId,
//       nameAr: nameAr,
//       nameEn: nameEn,
//       image: image,
//       quantity: quantity ?? this.quantity,
//       priceBeforeDiscount: priceBeforeDiscount,
//       priceAfterDiscount: priceAfterDiscount,
//       customerQuantity: customerQuantity ?? this.customerQuantity,
//       stockQuantity: stockQuantity ?? this.stockQuantity,
//       barcode: barcode ?? this.barcode,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'ItemID': productId,
//       'Quantity': quantity,
//       'Price': priceAfterDiscount,
//     };
//   }
// }

// Future<void> signInWithGoogle() async {
//     try {
//       emit( AuthGoogleLoading());
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
//
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth?.accessToken,
//         idToken: googleAuth?.idToken,
//       );
//
//       final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
//     print(userCredential.additionalUserInfo!.profile);
//
//       try {
//         await googleAuthData.add(userCredential.additionalUserInfo!.profile);
//         int count = googleAuthData.length;
//         print('تم إضافة العنصر بنجاح. عدد العناصر في الصندوق: $count');
//
//       } catch (e) {
//         print('حدث خطأ أثناء إضافة العنصر: $e');
//       }
//
//
//
//       emit( AuthGoogleSuccess(userCredential.additionalUserInfo!.profile));
//     } catch (e) {
//       print(e.toString());
//       emit( AuthGoogleFailure(e.toString()));
//     }
//   }
//
//   Future<void> signInWithFacebook() async {
//     try {
//       emit(AuthFacebookLoading());
//
//
//       final LoginResult loginResult = await FacebookAuth.instance.login();
//
//       if (loginResult.status == LoginStatus.success) {
//         // الحصول على credential
//         final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
//
//         // تسجيل الدخول باستخدام FirebaseAuth
//         final userCredential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
//
//         emit(AuthFacebookSuccess(userCredential));
//       } else {
//         emit(AuthFacebookFailure('Facebook login failed'));
//       }
//     } catch (e) {
//       emit(AuthFacebookFailure(e.toString()));
//     }
//   }
//
