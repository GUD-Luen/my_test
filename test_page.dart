import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nolilteo/config/constants.dart';
import 'controller/my_test_controller.dart';
import 'model/my_question.dart';

import '../config/global_assets.dart';
import '../config/global_function.dart';
import '../config/global_widgets/base_widget.dart';
import '../config/global_widgets/bottom_line_text_field.dart';
import '../config/global_widgets/global_widget.dart';

class myTestPage extends StatefulWidget {
  const myTestPage({Key? key, this.isEdit = false}) : super(key: key);

  final bool isEdit;

  static const String route = '/myTest';

  @override
  State<myTestPage> createState() => _myTestPageState();
}

class _myTestPageState extends State<myTestPage> {
  final PageController pageController = PageController();
  final PageController testPageController = PageController();
  final myTestController controller = Get.put(myTestController());
  final TextEditingController jobTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.isEdit = widget.isEdit;
    controller.fetchData(pageController, testPageController);
    jobTextEditingController.text = controller.job;
  }

  @override
  void dispose() {
    pageController.dispose();
    testPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      onWillPop: () {
        controller.backFunc(testPageController);
        return Future.value(false);
      },
      child: GestureDetector(
        onTap: () => GlobalFunction.unFocus(context),
        child: Scaffold(
          appBar: customAppBar(
            leading: controller.isFirstLogin
                ? null
                : GestureDetector(
                    onTap: () {
                      controller.backFunc(testPageController);
                    },
                    child: SizedBox(
                      width: 24 * sizeUnit,
                      height: 24 * sizeUnit,
                      child: Center(
                        child: SvgPicture.asset(GlobalAssets.svgArrowLeft),
                      ),
                    ),
                  ),
          ),
          body: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: controller.pageChangeFunc,
                  children: [
                    jobInputPage(),
                    testPage(),
                  ],
                ),
              ),
              GetBuilder<myTestController>(
                  id: 'bottom_button',
                  builder: (_) {
                    return nolBottomButton(
                        text: controller.buttonText,
                        isOk: controller.isCanNext(),
                        onTap: () {
                          GlobalFunction.unFocus(context);
                          if (controller.isCanNext()) {
                            controller.bottomButtonFunc(pageController, testPageController);
                          }
                        });
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget jobInputPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 24 * sizeUnit),
          SizedBox(
            height: 30 * sizeUnit,
            child: Text(
              '직장에서 나는 어떤 스타일일까?',
              style: STextStyle.headline4().copyWith(color: nolColorOrange),
            ),
          ),
          SizedBox(height: 8 * sizeUnit),
          Text(
            'my 테스트',
            style: STextStyle.headline2(),
          ),
          Text(
            '(Work Business Type Indicator)',
            style: STextStyle.body2(),
          ),
          SizedBox(height: 40 * sizeUnit),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 24 * sizeUnit),
                child: SizedBox(
                  height: 30 * sizeUnit,
                  child: Text(
                    'STEP 1. 직업을 적어주세요',
                    style: STextStyle.headline4(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24 * sizeUnit),
          SizedBox(
            width: 280 * sizeUnit,
            height: 72 * sizeUnit,
            child: GetBuilder<myTestController>(
                id: 'job_input',
                builder: (_) {
                  return BottomLineTextField(
                    controller: jobTextEditingController,
                    hintText: '예) 디자이너',
                    onChanged: controller.changeJobFunc,
                    textInputType: TextInputType.name,
                    errorText: controller.jobErrorText,
                    autofocus: controller.job.isEmpty,
                  );
                }),
          ),
          SizedBox(height: 16 * sizeUnit),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40 * sizeUnit),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [Text('테스트를 마치면 이렇게 결과가 나와요!', style: STextStyle.subTitle2().copyWith(color: nolColorOrange))],
                ),
                SizedBox(height: 16 * sizeUnit),
                GetBuilder<myTestController>(
                    id: 'job_example',
                    builder: (_) {
                      String job = controller.job.isEmpty ? '디자이너' : controller.job;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ex) 배려가 넘치는 $job',
                            style: STextStyle.body2().copyWith(color: nolColorOrange),
                          ),
                          SizedBox(height: 8 * sizeUnit),
                          Text(
                            'ex) 효율적인 해결사 $job',
                            style: STextStyle.body2().copyWith(color: nolColorOrange),
                          ),
                          SizedBox(height: 8 * sizeUnit),
                          Text(
                            'ex) 근면성실한 $job',
                            style: STextStyle.body2().copyWith(color: nolColorOrange),
                          ),
                        ],
                      );
                    }),
                SizedBox(height: 24 * sizeUnit),
                Text('*올바른 직업명이 아닐 경우 이용에 제한이 있을 수 있습니다.', style: STextStyle.body3()),
                SizedBox(height: 8 * sizeUnit),
                Text('ex) 마법사, 주술사, 도적', style: STextStyle.body3()),
                SizedBox(height: 8 * sizeUnit),
                Text('예외) 취준생, 알바생', style: STextStyle.body3()),
                SizedBox(height: 24 * sizeUnit),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget testPage() {
    return Column(
      children: [
        SizedBox(height: 24 * sizeUnit),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 24 * sizeUnit),
              child: SizedBox(
                height: 30 * sizeUnit,
                child: Text(
                  'STEP 2. 답변을 체크해주세요',
                  style: STextStyle.headline4(),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 24 * sizeUnit),
        GetBuilder<myTestController>(
          id: 'progress_bar',
          builder: (context) {
            return progressBar(controller.pageRatio);
          },
        ),
        Expanded(
          child: GetBuilder<myTestController>(
            id: 'test_page',
            builder: (_) {
              return PageView(
                controller: testPageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: controller.testPageChangeFunc,
                children: [
                  questionPage(0),
                  questionPage(1),
                  questionPage(2),
                  questionPage(3),
                  questionPage(4),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget progressBar(double ratio) {
    return Container(
      width: 240 * sizeUnit,
      height: 4 * sizeUnit,
      color: nolColorOrange.withOpacity(0.4),
      child: Row(
        children: [
          Container(
            width: 240 * ratio * sizeUnit,
            height: 4 * sizeUnit,
            color: nolColorOrange,
          ),
        ],
      ),
    );
  }

  Widget questionPage(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        questionBox(4 * index),
        questionBox(4 * index + 1),
        questionBox(4 * index + 2),
        questionBox(4 * index + 3),
      ],
    );
  }

  Widget questionBox(int index) {
    myQuestion question = controller.questionList[index];

    List answerList = [false, false, false, false, false];

    if (controller.answerMap[index] != null) {
      answerList[controller.answerMap[index]!] = true;
    }

    return SizedBox(
      width: 328 * sizeUnit,
      height: 85 * sizeUnit,
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              text: '${index + 1}. ${question.question1}\n',
              children: [TextSpan(text: question.question2)],
            ),
            style: STextStyle.body1_1().copyWith(height: 1.5),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8 * sizeUnit),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('비동의', style: STextStyle.body2().copyWith(color: nolColorOrange)),
              SizedBox(width: 16 * sizeUnit),
              checkableCircle(index, 0, answerList[0]),
              SizedBox(width: 16 * sizeUnit),
              checkableCircle(index, 1, answerList[1]),
              SizedBox(width: 16 * sizeUnit),
              checkableCircle(index, 2, answerList[2]),
              SizedBox(width: 16 * sizeUnit),
              checkableCircle(index, 3, answerList[3]),
              SizedBox(width: 16 * sizeUnit),
              checkableCircle(index, 4, answerList[4]),
              SizedBox(width: 16 * sizeUnit),
              Text('동의', style: STextStyle.body2().copyWith(color: nolColorOrange)),
            ],
          ),
        ],
      ),
    );
  }

  Widget checkableCircle(int questionIndex, int index, bool isCheck) {
    double size = 0;
    switch (index) {
      case 0:
      case 4:
        size = 34 * sizeUnit;
        break;
      case 1:
      case 3:
        size = 26 * sizeUnit;
        break;
      case 2:
        size = 16 * sizeUnit;
        break;
    }
    return GestureDetector(
      onTap: () {
        controller.choseAnswer(questionIndex, index);
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isCheck ? nolColorOrange : Colors.transparent,
          borderRadius: BorderRadius.circular(size / 2),
          border: isCheck ? null : Border.all(color: nolColorGrey, width: 2 * sizeUnit),
        ),
      ),
    );
  }
}
