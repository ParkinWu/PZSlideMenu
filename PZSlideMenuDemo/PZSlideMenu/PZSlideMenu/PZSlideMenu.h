//
//  PZSlideMenu.h
//  PZSlideMenu
//
//  Created by parkin on 15/4/28.
//  Copyright (c) 2015年 parkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PZSlideMenu : UIViewController
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
@property (nonatomic, assign,readonly) BOOL isOpened;
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
 @ 切换到第几个controller
 */
- (void)openViewControllerAtIndex:(NSInteger)index;

@end
