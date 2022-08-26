import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../config/constants.dart';

import '../../config/global_function.dart';
import '../../config/global_widgets/global_widget.dart';
import '../model/my_question.dart';
import '../my_result_page.dart';

class myTestController extends GetxController {
  static get to => Get.find<myTestController>();

  late PageController pageController;
  late PageController testPageController;

  bool isFirstLogin = false;
  bool isEdit = false;

  int pageIndex = 0;
  Duration pageDuration = const Duration(milliseconds: 500);
  Curve pageCurve = Curves.easeInOut;

  String buttonText = '다음';

  String job = '';
  String? jobErrorText;

  double pageRatio = 0.2;

  List<myQuestion> questionList = myQuestion.getRandomQuestionList();
  Map<int, int> answerMap = {};

  void fetchData(PageController tmpPageController, PageController tmpTestPageController){
    Map arguments = Get.arguments ?? {};
    isFirstLogin = arguments['isFirstLogin'] ?? false;

    pageController = tmpPageController;
    testPageController = tmpTestPageController;
  }

  void backFunc(PageController testPageController) {
    switch (pageIndex) {
      case 0:
      case 1:
        showCustomDialog(
          title: '테스트를 그만하시겠어요?',
          okText: '그만하기',
          okColor: nolColorOrange,
          isCancelButton: true,
          cancelText: '계속하기',
          okFunc: () {
            Get.back();//다이얼로그 종료
            Get.back();//테스트 페이지 종료
          },
        );
        break;
      case 2:
      case 3:
      case 4:
      case 5:
        pageRatio -= 0.2;
        testPageController.previousPage(duration: pageDuration, curve: pageCurve);
        break;
    }
    update(['bottom_button']);
  }

  bool isCanNext() {
    switch (pageIndex) {
      case 0:
        if (job.isNotEmpty && jobErrorText == null) {
          return true;
        } else {
          return false;
        }
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
        if (answerMap[pageIndex * 4 - 4] != null && answerMap[pageIndex * 4 - 3] != null && answerMap[pageIndex * 4 - 2] != null && answerMap[pageIndex * 4 - 1] != null) {
          return true;
        } else {
          return false;
        }
      default:
        return false;
    }
  }

  void bottomButtonFunc(PageController pageController, PageController testPageController) {
    switch (pageIndex) {
      case 0:
        pageController.nextPage(duration: pageDuration, curve: pageCurve);
        break;
      case 1:
      case 2:
      case 3:
      case 4:
        pageRatio += 0.2;
        testPageController.nextPage(duration: pageDuration, curve: pageCurve);
        break;
      case 5:
        resultFunc();
        break;
    }

    update(['bottom_button']);
  }

  void changeJobFunc(String val) {
    job = val;
    //직업명 규칙 체크
    jobErrorText = GlobalFunction.validJobErrorText(job);

    update(['job_input', 'job_example', 'bottom_button']);
  }

  void choseAnswer(int questionIndex, int answerIndex) {
    answerMap[questionIndex] = answerIndex;
    update(['test_page', 'bottom_button']);
  }

  void pageChangeFunc(int index) {
    pageIndex = index;
    update(['bottom_button']);
  }

  void testPageChangeFunc(int index) {
    pageIndex = index + 1;
    if (pageIndex == 5) {
      buttonText = '결과보기';
    } else {
      buttonText = '다음';
    }
    update(['progress_bar', 'bottom_button']);
  }

  void resultFunc() {
    int scoreEI = 0;
    int scoreSN = 0;
    int scoreTF = 0;
    int scoreJP = 0;

    for (int i = 0; i < questionList.length; i++) {
      int score = answerMap[i] ?? 0;
      score = score * -1 + 2;
      switch (questionList[i].type) {
        case myQuestion.myTypeE:
          scoreEI -= score;
          break;
        case myQuestion.myTypeI:
          scoreEI += score;
          break;
        case myQuestion.myTypeS:
          scoreSN -= score;
          break;
        case myQuestion.myTypeN:
          scoreSN += score;
          break;
        case myQuestion.myTypeT:
          scoreTF -= score;
          break;
        case myQuestion.myTypeF:
          scoreTF += score;
          break;
        case myQuestion.myTypeJ:
          scoreJP -= score;
          break;
        case myQuestion.myTypeP:
          scoreJP += score;
          break;
      }
    }

    String my = '';
    my += scoreEI > 0 ? 'e' : 'i';
    my += scoreSN > 0 ? 's' : 'n';
    my += scoreTF > 0 ? 't' : 'f';
    my += scoreJP > 0 ? 'j' : 'p';

    Map arguments = {};
    arguments['job'] = job;
    arguments['isEdit'] = isEdit;

    Get.toNamed('${myResultPage.route}/$my', arguments: arguments)?.then((value){
      //다시하기로 돌아왔을 때
      if(value != null){
        Map<String, bool> mapData = value[0];
        bool isReset = mapData['reset'] ?? false;
        if(isReset){
          reset();
        }
      }
    });
  }

  void reset(){
    answerMap.clear();

    pageController.jumpToPage(0);
    testPageController.jumpToPage(0);
    pageIndex = 0;
    pageRatio = 0.2;
    update(['test_page', 'progress_bar', 'bottom_button']);
  }
}
