import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';
import '../controllers/order_success_controller.dart';

class OrderSuccessView extends GetView<OrderSuccessController> {
  const OrderSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [

            Expanded(
              flex: 55,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Container(
                    width: 318,
                    height: 252,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/order_placed.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 45,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 32,
                  bottom: 12 + MediaQuery.paddingOf(context).bottom,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    const Text(
                      'Order Placed Successfully',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.textPrimaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'You will receive an email confirmation',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),

                    GestureDetector(
                      onTap: controller.seeOrderDetails,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        height: 56,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'See Order details',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
