import 'package:apartment_rentals/core/constant/app_routes.dart';
import 'package:apartment_rentals/modules/admin/apartment_form/view/apartment_form_view.dart';
import 'package:apartment_rentals/modules/admin/bookings/view/admin_bookings_view.dart';
import 'package:apartment_rentals/modules/admin/dashboard/view/admin_dashboard_view.dart';
import 'package:apartment_rentals/modules/admin/users/view/admin_users_view.dart';
import 'package:apartment_rentals/modules/auth/blocked/view/blocked_view.dart';
import 'package:apartment_rentals/modules/auth/chooseLanguage/view/choose_language_view.dart';
import 'package:apartment_rentals/modules/auth/choose_auth_method/view/choose_auth_method_view.dart';
import 'package:apartment_rentals/modules/auth/forget_password/view/forget_password_view.dart';
import 'package:apartment_rentals/modules/auth/on_boarding/view/on_boarding_view.dart';
import 'package:apartment_rentals/modules/auth/reset_password/view/reset_oassword_view.dart';
import 'package:apartment_rentals/modules/auth/sign_in/view/sign_in_view.dart';
import 'package:apartment_rentals/modules/auth/sign_up/view/sign_up_view.dart';
import 'package:apartment_rentals/modules/auth/splash/view/splash_view.dart';
import 'package:apartment_rentals/modules/auth/success_send_email/view/success_send_email_view.dart';
import 'package:apartment_rentals/modules/auth/verify_email/view/verify_email_view.dart';
import 'package:apartment_rentals/modules/main/view/main_view.dart';
import 'package:apartment_rentals/modules/navigation_items/profile/modules/edit_personal_info/view/edit_personal_info_view.dart';
import 'package:apartment_rentals/modules/navigation_items/profile/modules/tenant_card_edit/view/tenant_card_edit_view.dart';
import 'package:get/get.dart';

List<GetPage<dynamic>>? getPages = [
  //! Auth & Startup
  GetPage(name: AppRoutes.splash, page: () => const SplashView()),
  GetPage(name: AppRoutes.chooseLanguage, page: () => const ChooseLanguageView()),
  GetPage(name: AppRoutes.onBoarding, page: () => const OnBoardingView()),
  GetPage(name: AppRoutes.chooseAuthMethod, page: () => const ChooseAuthMethodView()),
  GetPage(name: AppRoutes.signIn, page: () => const SignInView()),
  GetPage(name: AppRoutes.signUp, page: () => const SignUpView()),
  GetPage(name: AppRoutes.forgetPassword, page: () => const ForgetPasswordView()),
  GetPage(name: AppRoutes.successSendEmail, page: () => const SuccessSendEmailView()),
  GetPage(name: AppRoutes.verifyEmail, page: () => const VerifyEmailView()),
  GetPage(name: AppRoutes.resetPassword, page: () => const ResetPasswordView()),
  GetPage(name: AppRoutes.mainView, page: () => const MainView()),
  GetPage(name: AppRoutes.tenantCardEdit, page: () => const TenantCardEditView()),
  GetPage(name: AppRoutes.editPersonalInfo, page: () => const EditPersonalInfoView()),

  //! Admin
  GetPage(name: AppRoutes.adminDashboard, page: () => const AdminDashboardView()),
  GetPage(name: AppRoutes.adminBookings, page: () => const AdminBookingsView()),
  GetPage(name: AppRoutes.adminApartmentForm, page: () => const ApartmentFormView()),
  GetPage(name: AppRoutes.adminUsers, page: () => const AdminUsersView()),

  GetPage(name: AppRoutes.blocked, page: () => const BlockedView()),
];