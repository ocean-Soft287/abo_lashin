import '../../constans/constants.dart';

class Endpoints {
  // Test http://15.235.51.177/TheOneAPI    &&& Live  http://78.89.159.126:9393/TheOneAboLasheenAPI
  // live
 static const String baseUrl = "http://78.89.159.126:9393/TheOneAboLasheenAPI";

//test
// static const baseUrl="http://78.89.159.126:9393/TheOneAboLasheenAPITest";

  static const String getMainCategory = "$baseUrl/api/Category/GetMainCategory";
  static const String register = "$baseUrl/api/Customer/AddCustomer";
  static const String getSubCategory = "$baseUrl/api/Category/GetCategoryByParentId";
  static const String updateUser = "$baseUrl/user/update";
  static const String aboutUS = "$baseUrl/api/AboutUs";
  static const String privacyAndPlo = "$baseUrl/api/Privacy";
  static const String governorates = "$baseUrl/api/Governorates";
  static const String addNewAddress = "$baseUrl/api/Customer/AddCustomerAddress";
  static  String offerOne = "$baseUrl/api/Offer1?CustomerPhone=$customerPhone";
  static  String offerTwo = "$baseUrl/api/Offers?CustomerPhone=$customerPhone";
  static  String bannerOne = "$baseUrl/api/Baner1";
  static  String newsMarquee = "$baseUrl/api/News";
  static  String bannerTwo= "$baseUrl/api/Baner2";
  static  String bannerThree = "$baseUrl/api/Baner3";
  static  String biggestDiscount = "$baseUrl/api/Product/GetProductsWithBiggestDiscount?pageNumber=1&pageSize=100&CustomerPhone=$customerPhone";
  static String bestSeller = "$baseUrl/api/Product/GetProductsWithBestSeller?pageNumber=1&pageSize=10000000&CustomerPhone=$customerPhone";
  static String newProduct = "$baseUrl/api/Product/GetNewProducts?pageNumber=1&pageSize=100&CustomerPhone=$customerid";
  static String previousTrackingOrdersByPhone = "/api/Order/GetCurrentOrdersByCustomerPhone/$customerPhone";
  static String previousOrdersByPhone = "/api/Order/GetByCustomerPhone/$customerPhone";
  static String customerIsActive = "/api/Customers/CustomerIsActive?CustomerPhone=$customerPhone";

  static String changePassword ({required String oldPassword,required String newPassword }) => "/api/Customer/ChangePassword?CustomerPhone=$customerPhone&OldpassWord=$oldPassword&NewpassWord=$newPassword";




  static String updateProfileData = "/api/Customer/UpdateCustomer";
  static String profileData = "/api/Customers/GetCustomer?CustomerPhone=$customerPhone";
static String deleteAccount = "/api/Customer/DeleteCustomerByCustomerID?CustomerID=$customerid";


  static String previousOrdersItem({required int itemId}) => "/api/Order/GetOrderProducts/$itemId?CustomerPhone=$customerPhone";
   static String addFavorite= "/api/Customer/AddCustomerProduct";
  static String getFavorite= "/api/Customer/GetCustomerProductsByID?CustomerID=$customerid";
  static String deleteFavorite({required int productId, required String barcode}) =>
    "/api/Customer/DeleteCustomerProduct?CustomerPhone=$customerPhone&ProductID=$productId&BarCode=$barcode";

  static String couponsDiscountCode(var discountCode) => "$baseUrl/api/Coupons/GetByCode/$discountCode?CustomerPhone=$customerPhone";
  static String bannerProductByIdImage({required int id }) => "$baseUrl/api/BannerItems1?ImageName=$id&CustomerID=$customerPhone'";




}





