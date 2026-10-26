abstract final class Endpoints {
  Endpoints._();

  static const String liveBaseUrl =
      'http://78.89.159.126:9393/TheOneAboLasheenAPI';
  static const String testBaseUrl = 'http://37.34.242.173:9292/TheOneAPI';
  static const String baseUrl = liveBaseUrl;

  static const String login = '/api/Customer/Login';
  static const String register = '/api/Customer/AddCustomer';
  static const String customerProfile = '/api/Customers/GetCustomer';
  static const String updateCustomer = '/api/Customer/UpdateCustomer';
  static const String changePassword = '/api/Customer/ChangePassword';
  static const String deleteAccount =
      '/api/Customer/DeleteCustomerByCustomerID';
  static const String customerIsActive = '/api/Customers/CustomerIsActive';

  static const String mainCategories = '/api/Category/GetMainCategory';
  static const String subCategories = '/api/Category/GetCategoryByParentId';
  static const String productsByCategory = '/api/Product/GetProductsByCategory';

  static const String bannerOne = '/api/Baner1';
  static const String bannerTwo = '/api/Baner2';
  static const String bannerThree = '/api/Baner3';
  static const String bannerProducts = '/api/BannerItems1';
  static const String news = '/api/News';
  static const String offerOne = '/api/Offer1';
  static const String offerTwo = '/api/Offers';
  static const String bestSeller = '/api/Product/GetProductsWithBestSeller';
  static const String biggestDiscount =
      '/api/Product/GetProductsWithBiggestDiscount';
  static const String newProducts = '/api/Product/GetNewProducts';

  static const String productById = '/api/Product/GetProductById';
  static const String searchProducts = '/api/Product/SearchProducts';

  static const String customerSalesBasket =
      '/api/Product/GetCustomerSalesBasket';
  static const String addSalesBasket = '/api/Product/AddSalesBasket';
  static const String deleteSalesBasket = '/api/Product/DeleteSalesBasket';

  static const String favorites = '/api/Customer/GetCustomerProductsByID';
  static const String addFavorite = '/api/Customer/AddCustomerProduct';
  static const String deleteFavorite = '/api/Customer/DeleteCustomerProduct';

  static const String governorates = '/api/Governorates';
  static const String areas = '/api/Areas/GetAreaByGovernorateId';
  static const String customerAddresses = '/api/Customers/GetCustomerAddress';
  static const String addAddress = '/api/Customer/AddCustomerAddress';

  static const String order = '/api/Order';
  static String coupon(String code) =>
      '/api/Coupons/GetByCode/${Uri.encodeComponent(code)}';
  static String orders(String phone) =>
      '/api/Order/GetByCustomerPhone/${Uri.encodeComponent(phone)}';
  static String currentOrders(String phone) =>
      '/api/Order/GetCurrentOrdersByCustomerPhone/${Uri.encodeComponent(phone)}';
  static String orderProducts(int orderId) =>
      '/api/Order/GetOrderProducts/$orderId';

  static const String aboutUs = '/api/AboutUs';
  static const String privacy = '/api/Privacy';
}
