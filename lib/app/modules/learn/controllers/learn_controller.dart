import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/data/models/tutorial_model.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';

class LearnController extends GetxController {
  final RxList<Tutorial> tutorials = <Tutorial>[
    Tutorial(
      id: 'draw-a-face',
      title: 'How to Draw a Face',
      description: 'Learn face proportions step by step',
      icon: Icons.face_outlined,
      color: AppColors.coral,
      difficulty: 'Beginner',
      steps: const [
        TutorialStep(
          title: 'The guide oval',
          instruction: 'Start with a simple oval for the head shape.',
          imagePath: 'assets/tutorials/draw-a-face/step_1.webp',
        ),
        TutorialStep(
          title: 'Center lines',
          instruction:
              'Add a vertical and horizontal center line to line up features.',
          imagePath: 'assets/tutorials/draw-a-face/step_2.webp',
        ),
        TutorialStep(
          title: 'Jaw and chin',
          instruction: 'Refine the oval into a jaw and chin shape.',
          imagePath: 'assets/tutorials/draw-a-face/step_3.webp',
        ),
        TutorialStep(
          title: 'Eye placement',
          instruction:
              'Mark the eye line and space out five eye-widths across it.',
          imagePath: 'assets/tutorials/draw-a-face/step_4.webp',
        ),
        TutorialStep(
          title: 'Eyes and eyebrows',
          instruction:
              'Draw almond-shaped eyes on the second and fourth marks, then add eyebrows above.',
          imagePath: 'assets/tutorials/draw-a-face/step_5.webp',
        ),
        TutorialStep(
          title: 'The nose',
          instruction:
              'The nose bottom sits halfway between the eyes and chin.',
          imagePath: 'assets/tutorials/draw-a-face/step_6.webp',
        ),
        TutorialStep(
          title: 'The mouth',
          instruction:
              'The mouth sits a third of the way down from the nose to the chin.',
          imagePath: 'assets/tutorials/draw-a-face/step_7.webp',
        ),
        TutorialStep(
          title: 'Ears',
          instruction:
              'Ears span from the eyebrow line down to the bottom of the nose.',
          imagePath: 'assets/tutorials/draw-a-face/step_8.webp',
        ),
        TutorialStep(
          title: 'Hair',
          instruction: 'Finish with a hairline and a few strands for texture.',
          imagePath: 'assets/tutorials/draw-a-face/step_9.webp',
        ),
      ],
    ),
    Tutorial(
      id: 'draw-a-cat',
      title: 'How to Draw a Cat Face',
      description: 'Simple shapes to a full cat face sketch',
      icon: Icons.pets_outlined,
      color: AppColors.mint,
      difficulty: 'Beginner',
      steps: const [
        TutorialStep(
          title: 'The guide circle',
          instruction:
              'Start with a circle for the head, then add a center cross to line up features.',
          imagePath: 'assets/tutorials/draw-a-cat/step_1.png',
        ),
        TutorialStep(
          title: 'Add the ears',
          instruction:
              'Draw two triangular ears sitting on top of the circle, slightly angled outward.',
          imagePath: 'assets/tutorials/draw-a-cat/step_2.png',
        ),
        TutorialStep(
          title: 'Eyes and nose',
          instruction:
              'Place almond-shaped eyes on the center line, then a small triangle nose below.',
          imagePath: 'assets/tutorials/draw-a-cat/step_3.png',
        ),
        TutorialStep(
          title: 'Mouth and whiskers',
          instruction:
              'Finish the mouth with a curved line from the nose, then add whiskers and cheek fur.',
          imagePath: 'assets/tutorials/draw-a-cat/step_4.png',
        ),
      ],
    ),
    Tutorial(
      id: 'draw-a-house',
      title: 'How to Draw a House',
      description: 'Build a cozy cottage from basic shapes',
      icon: Icons.home_outlined,
      color: AppColors.accent,
      difficulty: 'Beginner',
      steps: const [
        TutorialStep(
          title: 'The base rectangle',
          instruction:
              'Start with a simple rectangle for the front wall, and a center line to keep things symmetrical.',
          imagePath: 'assets/tutorials/draw-a-house/step_1.png',
        ),
        TutorialStep(
          title: 'The roofline',
          instruction:
              'Add a peaked roof on top, meeting at a point above the center line.',
          imagePath: 'assets/tutorials/draw-a-house/step_2.png',
        ),
        TutorialStep(
          title: 'Door and windows',
          instruction:
              'Sketch a door in the middle and a window on each side of it.',
          imagePath: 'assets/tutorials/draw-a-house/step_3.png',
        ),
        TutorialStep(
          title: 'Add the chimney',
          instruction:
              'Draw a rectangular chimney rising from the back edge of the roof.',
          imagePath: 'assets/tutorials/draw-a-house/step_4.png',
        ),
        TutorialStep(
          title: 'Roof shingles',
          instruction:
              'Fill the roof with short overlapping shingle lines for texture.',
          imagePath: 'assets/tutorials/draw-a-house/step_5.png',
        ),
        TutorialStep(
          title: 'Shading the walls',
          instruction:
              'Add crosshatching to the walls and roof to suggest shadow and depth.',
          imagePath: 'assets/tutorials/draw-a-house/step_6.png',
        ),
        TutorialStep(
          title: 'Final details',
          instruction:
              'Finish with a doorknob, window panes, and a ground line beneath the house.',
          imagePath: 'assets/tutorials/draw-a-house/step_7.png',
        ),
      ],
    ),
    Tutorial(
      id: 'draw-a-tree',
      title: 'How to Draw a Tree',
      description: 'Grow a full oak from a simple oval guide',
      icon: Icons.park_outlined,
      color: AppColors.mint,
      difficulty: 'Beginner',
      steps: const [
        TutorialStep(
          title: 'The guide oval',
          instruction:
              'Sketch a loose oval for the canopy, then drop a trunk line straight down from its center.',
          imagePath: 'assets/tutorials/draw-a-tree/step_1.webp',
        ),
        TutorialStep(
          title: 'Trunk and branches',
          instruction:
              'Thicken the trunk and split it into a few main branches reaching up into the oval.',
          imagePath: 'assets/tutorials/draw-a-tree/step_2.webp',
        ),
        TutorialStep(
          title: 'Canopy outline',
          instruction:
              'Trace a bumpy, cloud-like outline around the oval to form the leafy canopy edge.',
          imagePath: 'assets/tutorials/draw-a-tree/step_3.webp',
        ),
        TutorialStep(
          title: 'Bark and roots',
          instruction:
              'Add texture lines down the trunk and a few root lines flaring out at the base.',
          imagePath: 'assets/tutorials/draw-a-tree/step_4.webp',
        ),
        TutorialStep(
          title: 'Leaf clusters',
          instruction:
              'Scatter small scalloped leaf clusters inside the canopy, following the branch lines.',
          imagePath: 'assets/tutorials/draw-a-tree/step_5.webp',
        ),
        TutorialStep(
          title: 'Shading',
          instruction:
              'Shade the underside of the canopy and one side of the trunk to give the tree form.',
          imagePath: 'assets/tutorials/draw-a-tree/step_6.webp',
        ),
      ],
    ),
    Tutorial(
      id: 'draw-a-hand',
      title: 'How to Draw a Hand',
      description: 'Break a raised hand down into simple shapes',
      icon: Icons.back_hand_outlined,
      color: AppColors.coral,
      difficulty: 'Intermediate',
      steps: const [
        TutorialStep(
          title: 'The palm shape',
          instruction:
              'Start with a rounded square for the palm, then add a short wrist line below it.',
          imagePath: 'assets/tutorials/draw-a-hand/step_1.webp',
        ),
        TutorialStep(
          title: 'Finger guide lines',
          instruction:
              'Add five straight guide lines fanning out from the top of the palm for each finger.',
          imagePath: 'assets/tutorials/draw-a-hand/step_2.webp',
        ),
        TutorialStep(
          title: 'Finger segments',
          instruction:
              'Build each finger as stacked tube segments along its guide line, tapering slightly toward the tip.',
          imagePath: 'assets/tutorials/draw-a-hand/step_3.webp',
        ),
        TutorialStep(
          title: 'Refine the outline',
          instruction:
              'Clean up the outer silhouette of the hand and fingers into one continuous line.',
          imagePath: 'assets/tutorials/draw-a-hand/step_4.webp',
        ),
        TutorialStep(
          title: 'Knuckle creases',
          instruction:
              'Add short curved creases at each knuckle joint to show where the fingers bend.',
          imagePath: 'assets/tutorials/draw-a-hand/step_5.webp',
        ),
        TutorialStep(
          title: 'Palm lines',
          instruction:
              'Erase the construction lines and add a few soft creases across the palm.',
          imagePath: 'assets/tutorials/draw-a-hand/step_6.webp',
        ),
        TutorialStep(
          title: 'Shading',
          instruction:
              'Shade the base of the palm and the sides of the fingers to give the hand volume.',
          imagePath: 'assets/tutorials/draw-a-hand/step_7.webp',
        ),
      ],
    ),
    Tutorial(
      id: 'shading-basics',
      title: 'Shading Basics',
      description: 'Light, shadow, and form with simple shapes',
      icon: Icons.gradient_outlined,
      color: AppColors.accent,
      difficulty: 'Intermediate',
      steps: const [
        TutorialStep(
          title: 'Light source',
          instruction:
              'Pick one light direction and keep it consistent across the whole drawing.',
          imagePath: 'assets/tutorials/shading-basics/step_1.jpg',
        ),
        TutorialStep(
          title: 'Core shadow',
          instruction:
              'The darkest shadow sits just past the terminator line, not at the very edge of the form.',
          imagePath: 'assets/tutorials/shading-basics/step_2.jpg',
        ),
      ],
    ),
  ].obs;
}
