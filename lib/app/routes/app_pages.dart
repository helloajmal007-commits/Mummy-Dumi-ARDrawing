import 'package:get/get.dart';
import 'package:sketch_flow/app/modules/ar_trace/bindings/ar_trace_binding.dart';
import 'package:sketch_flow/app/modules/ar_trace/views/ar_trace_view.dart';
import 'package:sketch_flow/app/modules/canvas/bindings/canvas_binding.dart';
import 'package:sketch_flow/app/modules/canvas/views/canvas_view.dart';
import 'package:sketch_flow/app/modules/categories/bindings/categories_binding.dart';
import 'package:sketch_flow/app/modules/categories/views/categories_view.dart';
import 'package:sketch_flow/app/modules/export/bindings/export_binding.dart';
import 'package:sketch_flow/app/modules/export/views/export_view.dart';
import 'package:sketch_flow/app/modules/gallery/bindings/gallery_binding.dart';
import 'package:sketch_flow/app/modules/gallery/view/gallery_view.dart';
import 'package:sketch_flow/app/modules/home/bindings/home_binding.dart';
import 'package:sketch_flow/app/modules/home/views/home_view.dart';
import 'package:sketch_flow/app/modules/language/bindings/language_binding.dart';
import 'package:sketch_flow/app/modules/language/views/language_confirm_view.dart';
import 'package:sketch_flow/app/modules/language/views/language_select_view.dart';
import 'package:sketch_flow/app/modules/layers/bindings/layers_binding.dart';
import 'package:sketch_flow/app/modules/layers/views/layers_view.dart';
import 'package:sketch_flow/app/modules/learn/bindings/learn_binding.dart';
import 'package:sketch_flow/app/modules/learn/views/learn_view.dart';
import 'package:sketch_flow/app/modules/learn/views/tutorial_steps_view.dart';
import 'package:sketch_flow/app/modules/onboarding/bindings/onboarding_binding.dart';
import 'package:sketch_flow/app/modules/onboarding/views/onboarding_view.dart';
import 'package:sketch_flow/app/modules/onboarding/views/splash_view.dart';
import 'package:sketch_flow/app/modules/paper_trace/bindings/paper_trace_binding.dart';
import 'package:sketch_flow/app/modules/paper_trace/views/paper_trace_view.dart';
import 'package:sketch_flow/app/modules/settings/bindings/sittings_binding.dart';
import 'package:sketch_flow/app/modules/settings/views/settings_view.dart';
import 'package:sketch_flow/app/modules/sketches/bindings/sketches_binding.dart';
import 'package:sketch_flow/app/modules/sketches/views/sketches_view.dart';
import 'package:sketch_flow/app/modules/tools/bindings/tools_binding.dart';
import 'package:sketch_flow/app/modules/tools/views/tools_view.dart';
import 'package:sketch_flow/app/widgets/asset_image_grid_view.dart';
import 'package:sketch_flow/app/routes/app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.canvas,
      page: () => const CanvasView(),
      binding: CanvasBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.layers,
      page: () => const LayersView(),
      binding: LayersBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: Routes.tools,
      page: () => const ToolsView(),
      binding: ToolsBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: Routes.export,
      page: () => const ExportView(),
      binding: ExportBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: Routes.gallery,
      page: () => const GalleryView(),
      binding: GalleryBinding(),
    ),
    GetPage(
      name: Routes.categories,
      page: () => const CategoriesView(),
      binding: CategoriesBinding(),
    ),
    GetPage(
      name: Routes.sketches,
      page: () => const SketchesView(),
      binding: SketchesBinding(),
    ),
    GetPage(
      name: Routes.arTrace,
      page: () => const ArTraceView(),
      binding: ArTraceBinding(),
    ),
    GetPage(
      name: Routes.paperTrace,
      page: () => const PaperTraceView(),
      binding: PaperTraceBinding(),
    ),
    GetPage(
      name: Routes.learn,
      page: () => const LearnView(),
      binding: LearnBinding(),
    ),
    GetPage(
      name: Routes.tutorialSteps,
      page: () => const TutorialStepsView(),
    ),
    GetPage(
      name: Routes.assetGrid,
      page: () => const AssetImageGridView(),
    ),
    GetPage(
      name: Routes.learn,
      page: () => const LearnView(),
      binding: LearnBinding(),
    ),
    GetPage(
      name: Routes.tutorialSteps,
      page: () => const TutorialStepsView(),
    ),
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.languageSelect,
      page: () => const LanguageSelectView(),
      binding: LanguageBinding(),
    ),
    GetPage(
      name: Routes.languageConfirm,
      page: () => const LanguageConfirmView(),
      binding: LanguageBinding(),
    ),
  ];
}
