import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/data/models/tutorial_model.dart';
import 'package:sketch_flow/app/localization/translation_keys.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';

class LearnController extends GetxController {
  final RxList<Tutorial> tutorials = <Tutorial>[
    Tutorial(
      id: 'draw-a-face',
      titleResolver: () => TKeys.tutFaceTitle.tr,
      descriptionResolver: () => TKeys.tutFaceDesc.tr,
      icon: Icons.face_outlined,
      color: AppColors.coral,
      difficultyResolver: () => TKeys.difficultyBeginner.tr,
      steps: [
        TutorialStep(
          titleResolver: () => TKeys.tutFaceStep1Title.tr,
          instructionResolver: () => TKeys.tutFaceStep1Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-face/step_1.webp',
        ),
        TutorialStep(
          titleResolver: () => TKeys.tutFaceStep2Title.tr,
          instructionResolver: () => TKeys.tutFaceStep2Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-face/step_2.webp',
        ),
        TutorialStep(
          titleResolver: () => TKeys.tutFaceStep3Title.tr,
          instructionResolver: () => TKeys.tutFaceStep3Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-face/step_3.webp',
        ),
        TutorialStep(
          titleResolver: () => TKeys.tutFaceStep4Title.tr,
          instructionResolver: () => TKeys.tutFaceStep4Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-face/step_4.webp',
        ),
        TutorialStep(
          titleResolver: () => TKeys.tutFaceStep5Title.tr,
          instructionResolver: () => TKeys.tutFaceStep5Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-face/step_5.webp',
        ),
        TutorialStep(
          titleResolver: () => TKeys.tutFaceStep6Title.tr,
          instructionResolver: () => TKeys.tutFaceStep6Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-face/step_6.webp',
        ),
        TutorialStep(
          titleResolver: () => TKeys.tutFaceStep7Title.tr,
          instructionResolver: () => TKeys.tutFaceStep7Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-face/step_7.webp',
        ),
        TutorialStep(
          titleResolver: () => TKeys.tutFaceStep8Title.tr,
          instructionResolver: () => TKeys.tutFaceStep8Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-face/step_8.webp',
        ),
        TutorialStep(
          titleResolver: () => TKeys.tutFaceStep9Title.tr,
          instructionResolver: () => TKeys.tutFaceStep9Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-face/step_9.webp',
        ),
      ],
    ),
    Tutorial(
      id: 'draw-a-cat',
      titleResolver: () => TKeys.tutCatTitle.tr,
      descriptionResolver: () => TKeys.tutCatDesc.tr,
      icon: Icons.pets_outlined,
      color: AppColors.mint,
      difficultyResolver: () => TKeys.difficultyBeginner.tr,
      steps: [
        TutorialStep(
          titleResolver: () => TKeys.tutCatStep1Title.tr,
          instructionResolver: () => TKeys.tutCatStep1Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-cat/step_1.png',
        ),
        TutorialStep(
          titleResolver: () => TKeys.tutCatStep2Title.tr,
          instructionResolver: () => TKeys.tutCatStep2Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-cat/step_2.png',
        ),
        TutorialStep(
          titleResolver: () => TKeys.tutCatStep3Title.tr,
          instructionResolver: () => TKeys.tutCatStep3Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-cat/step_3.png',
        ),
        TutorialStep(
          titleResolver: () => TKeys.tutCatStep4Title.tr,
          instructionResolver: () => TKeys.tutCatStep4Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-cat/step_4.png',
        ),
      ],
    ),
    Tutorial(
      id: 'draw-a-house',
      titleResolver: () => TKeys.tutHouseTitle.tr,
      descriptionResolver: () => TKeys.tutHouseDesc.tr,
      icon: Icons.home_outlined,
      color: AppColors.accent,
      difficultyResolver: () => TKeys.difficultyBeginner.tr,
      steps: [
        TutorialStep(
          titleResolver: () => TKeys.tutHouseStep1Title.tr,
          instructionResolver: () => TKeys.tutHouseStep1Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-house/step_1.png',
        ),
        TutorialStep(
          titleResolver: () => TKeys.tutHouseStep2Title.tr,
          instructionResolver: () => TKeys.tutHouseStep2Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-house/step_2.png',
        ),
        TutorialStep(
          titleResolver: () => TKeys.tutHouseStep3Title.tr,
          instructionResolver: () => TKeys.tutHouseStep3Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-house/step_3.png',
        ),
        TutorialStep(
          titleResolver: () => TKeys.tutHouseStep4Title.tr,
          instructionResolver: () => TKeys.tutHouseStep4Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-house/step_4.png',
        ),
        TutorialStep(
          titleResolver: () => TKeys.tutHouseStep5Title.tr,
          instructionResolver: () => TKeys.tutHouseStep5Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-house/step_5.png',
        ),
        TutorialStep(
          titleResolver: () => TKeys.tutHouseStep6Title.tr,
          instructionResolver: () => TKeys.tutHouseStep6Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-house/step_6.png',
        ),
        TutorialStep(
          titleResolver: () => TKeys.tutHouseStep7Title.tr,
          instructionResolver: () => TKeys.tutHouseStep7Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-house/step_7.png',
        ),
      ],
    ),
    Tutorial(
      id: 'draw-a-tree',
      titleResolver: () => TKeys.tutTreeTitle.tr,
      descriptionResolver: () => TKeys.tutTreeDesc.tr,
      icon: Icons.park_outlined,
      color: AppColors.mint,
      difficultyResolver: () => TKeys.difficultyBeginner.tr,
      steps: [
        TutorialStep(
          titleResolver: () => TKeys.tutTreeStep1Title.tr,
          instructionResolver: () => TKeys.tutTreeStep1Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-tree/step_1.webp',
        ),
        TutorialStep(
          titleResolver: () => TKeys.tutTreeStep2Title.tr,
          instructionResolver: () => TKeys.tutTreeStep2Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-tree/step_2.webp',
        ),
        TutorialStep(
          titleResolver: () => TKeys.tutTreeStep3Title.tr,
          instructionResolver: () => TKeys.tutTreeStep3Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-tree/step_3.webp',
        ),
        TutorialStep(
          titleResolver: () => TKeys.tutTreeStep4Title.tr,
          instructionResolver: () => TKeys.tutTreeStep4Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-tree/step_4.webp',
        ),
        TutorialStep(
          titleResolver: () => TKeys.tutTreeStep5Title.tr,
          instructionResolver: () => TKeys.tutTreeStep5Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-tree/step_5.webp',
        ),
        TutorialStep(
          titleResolver: () => TKeys.tutTreeStep6Title.tr,
          instructionResolver: () => TKeys.tutTreeStep6Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-tree/step_6.webp',
        ),
      ],
    ),
    Tutorial(
      id: 'draw-a-hand',
      titleResolver: () => TKeys.tutHandTitle.tr,
      descriptionResolver: () => TKeys.tutHandDesc.tr,
      icon: Icons.back_hand_outlined,
      color: AppColors.coral,
      difficultyResolver: () => TKeys.difficultyIntermediate.tr,
      steps: [
        TutorialStep(
          titleResolver: () => TKeys.tutHandStep1Title.tr,
          instructionResolver: () => TKeys.tutHandStep1Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-hand/step_1.webp',
        ),
        TutorialStep(
          titleResolver: () => TKeys.tutHandStep2Title.tr,
          instructionResolver: () => TKeys.tutHandStep2Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-hand/step_2.webp',
        ),
        TutorialStep(
          titleResolver: () => TKeys.tutHandStep3Title.tr,
          instructionResolver: () => TKeys.tutHandStep3Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-hand/step_3.webp',
        ),
        TutorialStep(
          titleResolver: () => TKeys.tutHandStep4Title.tr,
          instructionResolver: () => TKeys.tutHandStep4Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-hand/step_4.webp',
        ),
        TutorialStep(
          titleResolver: () => TKeys.tutHandStep5Title.tr,
          instructionResolver: () => TKeys.tutHandStep5Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-hand/step_5.webp',
        ),
        TutorialStep(
          titleResolver: () => TKeys.tutHandStep6Title.tr,
          instructionResolver: () => TKeys.tutHandStep6Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-hand/step_6.webp',
        ),
        TutorialStep(
          titleResolver: () => TKeys.tutHandStep7Title.tr,
          instructionResolver: () => TKeys.tutHandStep7Instruction.tr,
          imagePath: 'assets/tutorials/draw-a-hand/step_7.webp',
        ),
      ],
    ),
    Tutorial(
      id: 'shading-basics',
      titleResolver: () => TKeys.tutShadingTitle.tr,
      descriptionResolver: () => TKeys.tutShadingDesc.tr,
      icon: Icons.gradient_outlined,
      color: AppColors.accent,
      difficultyResolver: () => TKeys.difficultyIntermediate.tr,
      steps: [
        TutorialStep(
          titleResolver: () => TKeys.tutShadingStep1Title.tr,
          instructionResolver: () => TKeys.tutShadingStep1Instruction.tr,
          imagePath: 'assets/tutorials/shading-basics/step_1.jpg',
        ),
        TutorialStep(
          titleResolver: () => TKeys.tutShadingStep2Title.tr,
          instructionResolver: () => TKeys.tutShadingStep2Instruction.tr,
          imagePath: 'assets/tutorials/shading-basics/step_2.jpg',
        ),
      ],
    ),
  ].obs;
}
