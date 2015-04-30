# PZSlideMenu
一个抽屉效果
* 1.能过管理多个ViewController
* 2.支持滑动手势

##使用方法
```
    RootViewController * rootVC = [[RootViewController alloc] init];
    SecondViewController * secondVC = [[SecondViewController alloc] init];
    LeftViewController * leftVC = [[LeftViewController alloc] init];
    PZSlideMenu * menu = [[PZSlideMenu alloc] initWithLeftVC:leftVC viewControllers:@[rootVC, secondVC]];

//    menu.openOffset = 180;
//    menu.scale = 0.7;
    self.window.rootViewController = menu;
```
##方法介绍
```
/**
 @ 所管理的viewControllers
 */
@property (nonatomic, strong) NSArray * viewControllers;
/**
 @ 抽屉打开的最大距离，默认150；
 */
@property (nonatomic, assign) CGFloat openOffset;
/**
 @ 当打开菜单时，内容页缩放为原来的百分比，（0.5-1）
 @ 默认为0.85
 */
@property (nonatomic, assign) CGFloat scale;
/**
 @ 当前打开的ViewController序列
 */
@property (nonatomic, readonly, assign) NSInteger currentOpenedIndex;
/**
 @ 是否打开leftVC
 */
@property (nonatomic, assign) BOOL isOpened;
+ (instancetype)shareInstance;
/**
 @ 初始化
 @ leftVC:左侧菜单
 @ VCs:被管理的controllers，NSArray
 */
- (instancetype)initWithLeftVC:(UIViewController *)leftVC viewControllers:(NSArray *)VCs;
/**
 @ 打开菜单
 */
- (void)showLeftMenu;
/**
 @ 关闭菜单
 */
- (void)closeLeftMenu;
/**
 @ 切换到第几个controller
 */
- (void)openViewControllerAtIndex:(NSInteger)index;
```

#效果图
![效果图](http://7xil26.com1.z0.glb.clouddn.com/PZSlideMenu.gif)
