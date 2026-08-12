import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/data/models/tutorial_model.dart';
import 'package:sketch_flow/app/localization/translation_keys.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';

class LearnController extends GetxController {
  final RxList<Tutorial> tutorials = <Tutorial>[
    Tutorial(
      id: 'draw-a-face',
      title: TKeys.tutFaceTitle.tr,
      description: TKeys.tutFaceDesc.tr,
      icon: Icons.face_outlined,
      color: AppColors.coral,
      difficulty: TKeys.difficultyBeginner.tr,
      steps: [
        TutorialStep(
          title: TKeys.tutFaceStep1Title.tr,
          instruction: TKeys.tutFaceStep1Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-face/step_1.webp',
        ),
        TutorialStep(
          title: TKeys.tutFaceStep2Title.tr,
          instruction: TKeys.tutFaceStep2Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-face/step_2.webp',
        ),
        TutorialStep(
          title: TKeys.tutFaceStep3Title.tr,
          instruction: TKeys.tutFaceStep3Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-face/step_3.webp',
        ),
        TutorialStep(
          title: TKeys.tutFaceStep4Title.tr,
          instruction: TKeys.tutFaceStep4Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-face/step_4.webp',
        ),
        TutorialStep(
          title: TKeys.tutFaceStep5Title.tr,
          instruction: TKeys.tutFaceStep5Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-face/step_5.webp',
        ),
        TutorialStep(
          title: TKeys.tutFaceStep6Title.tr,
          instruction: TKeys.tutFaceStep6Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-face/step_6.webp',
        ),
        TutorialStep(
          title: TKeys.tutFaceStep7Title.tr,
          instruction: TKeys.tutFaceStep7Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-face/step_7.webp',
        ),
        TutorialStep(
          title: TKeys.tutFaceStep8Title.tr,
          instruction: TKeys.tutFaceStep8Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-face/step_8.webp',
        ),
        TutorialStep(
          title: TKeys.tutFaceStep9Title.tr,
          instruction: TKeys.tutFaceStep9Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-face/step_9.webp',
        ),
      ],
    ),
    Tutorial(
      id: 'draw-a-cat',
      title: TKeys.tutCatTitle.tr,
      description: TKeys.tutCatDesc.tr,
      icon: Icons.pets_outlined,
      color: AppColors.mint,
      difficulty: TKeys.difficultyBeginner.tr,
      steps: [
        TutorialStep(
          title: TKeys.tutCatStep1Title.tr,
          instruction: TKeys.tutCatStep1Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-cat/step_1.png',
        ),
        TutorialStep(
          title: TKeys.tutCatStep2Title.tr,
          instruction: TKeys.tutCatStep2Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-cat/step_2.png',
        ),
        TutorialStep(
          title: TKeys.tutCatStep3Title.tr,
          instruction: TKeys.tutCatStep3Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-cat/step_3.png',
        ),
        TutorialStep(
          title: TKeys.tutCatStep4Title.tr,
          instruction: TKeys.tutCatStep4Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-cat/step_4.png',
        ),
      ],
    ),
    Tutorial(
      id: 'draw-a-house',
      title: TKeys.tutHouseTitle.tr,
      description: TKeys.tutHouseDesc.tr,
      icon: Icons.home_outlined,
      color: AppColors.accent,
      difficulty: TKeys.difficultyBeginner.tr,
      steps: [
        TutorialStep(
          title: TKeys.tutHouseStep1Title.tr,
          instruction: TKeys.tutHouseStep1Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-house/step_1.png',
        ),
        TutorialStep(
          title: TKeys.tutHouseStep2Title.tr,
          instruction: TKeys.tutHouseStep2Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-house/step_2.png',
        ),
        TutorialStep(
          title: TKeys.tutHouseStep3Title.tr,
          instruction: TKeys.tutHouseStep3Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-house/step_3.png',
        ),
        TutorialStep(
          title: TKeys.tutHouseStep4Title.tr,
          instruction: TKeys.tutHouseStep4Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-house/step_4.png',
        ),
        TutorialStep(
          title: TKeys.tutHouseStep5Title.tr,
          instruction: TKeys.tutHouseStep5Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-house/step_5.png',
        ),
        TutorialStep(
          title: TKeys.tutHouseStep6Title.tr,
          instruction: TKeys.tutHouseStep6Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-house/step_6.png',
        ),
        TutorialStep(
          title: TKeys.tutHouseStep7Title.tr,
          instruction: TKeys.tutHouseStep7Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-house/step_7.png',
        ),
      ],
    ),
    Tutorial(
      id: 'draw-a-tree',
      title: TKeys.tutTreeTitle.tr,
      description: TKeys.tutTreeDesc.tr,
      icon: Icons.park_outlined,
      color: AppColors.mint,
      difficulty: TKeys.difficultyBeginner.tr,
      steps: [
        TutorialStep(
          title: TKeys.tutTreeStep1Title.tr,
          instruction: TKeys.tutTreeStep1Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-tree/step_1.webp',
        ),
        TutorialStep(
          title: TKeys.tutTreeStep2Title.tr,
          instruction: TKeys.tutTreeStep2Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-tree/step_2.webp',
        ),
        TutorialStep(
          title: TKeys.tutTreeStep3Title.tr,
          instruction: TKeys.tutTreeStep3Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-tree/step_3.webp',
        ),
        TutorialStep(
          title: TKeys.tutTreeStep4Title.tr,
          instruction: TKeys.tutTreeStep4Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-tree/step_4.webp',
        ),
        TutorialStep(
          title: TKeys.tutTreeStep5Title.tr,
          instruction: TKeys.tutTreeStep5Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-tree/step_5.webp',
        ),
        TutorialStep(
          title: TKeys.tutTreeStep6Title.tr,
          instruction: TKeys.tutTreeStep6Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-tree/step_6.webp',
        ),
      ],
    ),
    Tutorial(
      id: 'draw-a-hand',
      title: TKeys.tutHandTitle.tr,
      description: TKeys.tutHandDesc.tr,
      icon: Icons.back_hand_outlined,
      color: AppColors.coral,
      difficulty: TKeys.difficultyIntermediate.tr,
      steps: [
        TutorialStep(
          title: TKeys.tutHandStep1Title.tr,
          instruction: TKeys.tutHandStep1Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-hand/step_1.webp',
        ),
        TutorialStep(
          title: TKeys.tutHandStep2Title.tr,
          instruction: TKeys.tutHandStep2Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-hand/step_2.webp',
        ),
        TutorialStep(
          title: TKeys.tutHandStep3Title.tr,
          instruction: TKeys.tutHandStep3Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-hand/step_3.webp',
        ),
        TutorialStep(
          title: TKeys.tutHandStep4Title.tr,
          instruction: TKeys.tutHandStep4Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-hand/step_4.webp',
        ),
        TutorialStep(
          title: TKeys.tutHandStep5Title.tr,
          instruction: TKeys.tutHandStep5Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-hand/step_5.webp',
        ),
        TutorialStep(
          title: TKeys.tutHandStep6Title.tr,
          instruction: TKeys.tutHandStep6Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-hand/step_6.webp',
        ),
        TutorialStep(
          title: TKeys.tutHandStep7Title.tr,
          instruction: TKeys.tutHandStep7Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-hand/step_7.webp',
        ),
      ],
    ),
    Tutorial(
      id: 'shading-basics',
      title: TKeys.tutShadingTitle.tr,
      description: TKeys.tutShadingDesc.tr,
      icon: Icons.gradient_outlined,
      color: AppColors.accent,
      difficulty: TKeys.difficultyIntermediate.tr,
      steps: [
        TutorialStep(
          title: TKeys.tutShadingStep1Title.tr,
          instruction: TKeys.tutShadingStep1Instruction.tr,
          imagePath: 'assets/tutorials/shading-basics/step_1.jpg',
        ),
        TutorialStep(
          title: TKeys.tutShadingStep2Title.tr,
          instruction: TKeys.tutShadingStep2Instruction.tr,
          imagePath: 'assets/tutorials/shading-basics/step_2.jpg',
        ),
      ],
    ),
  ].obs;
}
