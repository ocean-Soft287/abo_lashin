import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CartWidget extends StatelessWidget {
  final String image;
  final String name;
  final double price;
  final VoidCallback onAdd;
  final VoidCallback onSubtract;
  final int quantity;


  const CartWidget({
    super.key,
    this.image = 'assets/images/default.png',
    this.name = 'تفاح طازج 10 كيلو',
    this.price = 0.0,
    this.onAdd = _defaultOnAdd,
    this.onSubtract = _defaultOnSubtract,
    this.quantity = 0,

  });

  static void _defaultOnAdd() {

  }

  static void _defaultOnSubtract() {

  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Image.asset(image),
            ),
            const SizedBox(width: 5),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      color: Color(0xff313131),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$price ',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff313131),
                              ),
                            ),
                            TextSpan(
                              text: 'currency'.tr(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff313131),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: onSubtract,
                            child: Container(
                              width: 30.0,
                              height: 30.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[300],
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.black,
                                  size: 20.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Text(
                            quantity.toString(),
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff707070),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          GestureDetector(
                            onTap: onAdd,
                            child: Container(
                              width: 30.0,
                              height: 30.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[300],
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.add,
                                  color: Colors.black,
                                  size: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class SkeletonizerCart extends StatelessWidget {
  const SkeletonizerCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return const CartWidget();
        },
      ),
    )
    ;
  }
}


