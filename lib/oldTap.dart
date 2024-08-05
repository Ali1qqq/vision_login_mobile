/*SingleChildScrollView(
              physics: ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 20),
              child: SizedBox(
                height:max(900, Get.height-40),
                child: TabContainer(
                    textDirection: Get.locale.toString() != "en_US"
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    controller: tabController,
                    tabEdge: Get.locale.toString() != "en_US"
                        ? TabEdge.right
                        : TabEdge.left,
                    tabsEnd: 1,
                    tabsStart: 0.0,
                    tabMaxLength: controller.isDrawerOpen ? 60 : 60,
                    tabExtent: controller.isDrawerOpen ? 180 : 60,
                    borderRadius: BorderRadius.circular(10),
                    tabBorderRadius: BorderRadius.circular(20),
                    childPadding: const EdgeInsets.all(0.0),
                    selectedTextStyle: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 15.0,
                    ),
                    unselectedTextStyle: AppStyles.headLineStyle1.copyWith(
                      color: primaryColor,
                      fontSize: 13.0,
                    ),
                    colors: List.generate(allData.length, (index) => bgColor),
                    tabs: List.generate(
                      allData.length,
                      (index) {
                        return DrawerListTile(
                          index: index,
                          title: allData[index].name.toString().tr,
                          svgSrc: allData[index].img,
                          press: () {
                            setState(() {});
                          },
                        );
                      },
                    ),
                    child: allData[int.parse(
                            HiveDataBase.getUserData().currentScreen)]
                        .widget),
              ),
            )*/


/*
@override
void initState() {
  print(HiveDataBase.getAccountManagementModel()!.type);
  tabController = TabController(length: allData.length, vsync: this);
  tabController.addListener(() {
    // html.window.history.pushState(null, '', "/#/"+allData[tabController.index].widget.toString());
    HiveDataBase.setCurrentScreen(tabController.index.toString());

    setState(() {});
  });
  super.initState();
  WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then(
        (value) {
      tabController.animateTo(int.parse(HiveDataBase.getUserData().currentScreen));
      setState(() {});
    },
  );
}*/
