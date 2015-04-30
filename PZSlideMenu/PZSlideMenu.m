//
//  PZSlideMenu.m
//  PZSlideMenu
//
//  Created by parkin on 15/4/28.
//  Copyright (c) 2015年 parkin. All rights reserved.
//

#import "PZSlideMenu.h"
static PZSlideMenu * menu = nil;
@interface PZSlideMenu () {
    UIViewController * _currentVC;
    CGFloat _currentOffset;
}
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UIViewController * leftVC;

@end

@implementation PZSlideMenu

+ (instancetype)shareInstance {
    NSAssert(menu, @"menu未初始化");
    return menu;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**
 @ 初始化
 @ leftVC:左侧菜单
 @ VCs:被管理的controllers，NSArray
 */
- (instancetype)initWithLeftVC:(UIViewController *)leftVC viewControllers:(NSArray *)VCs {
    self = [super init];
    if (self) {
        [self.view addSubview:leftVC.view];
        [self addChildViewController:leftVC];
        [self setupGesture];
        
        self.viewControllers = VCs;
        self.leftVC = leftVC;
        self.leftVC.view.frame = [[UIScreen mainScreen] bounds];
        
        
        _currentVC = [self.viewControllers firstObject];
        [self.contentView addSubview:_currentVC.view];
        
        for (UIViewController *vc in VCs) {
            [self addChildViewController:vc];
            vc.view.frame = [[UIScreen mainScreen] bounds];
        }
        
        _currentOpenedIndex = [self.viewControllers indexOfObject:_currentVC];
    }
    menu = self;
    return self;
}
/**
 @ 打开菜单
 */
- (void)showLeftMenu {
    [self openLeftVCWithAnimation];
}
- (void)closeLeftMenu {
    [self closeLeftVCWithAnimation];
}
/**
 @ 切换到第几个controller
 */
- (void)openViewControllerAtIndex:(NSInteger)index {
    [self switchToIndex:index];
    [self closeLeftVCWithAnimation];
}
- (void)switchToIndex:(NSInteger)index {

    NSAssert(index < self.viewControllers.count, @"index 越界!");
    if (_currentOpenedIndex != index) {
        UIViewController * newVC = [self.viewControllers objectAtIndex:index];
        [self transitionFromViewController:_currentVC toViewController:newVC duration:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        } completion:^(BOOL finished) {

            if (finished) {
                newVC.view.frame = _currentVC.view.frame;
                _currentOpenedIndex = index;
                _currentVC = newVC;
            }
        }];
    }
}
- (void)setupGesture {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.delegate = self;
    [self.contentView addGestureRecognizer:tap];
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.contentView addGestureRecognizer:pan];
}
- (void)tap:(UITapGestureRecognizer *)tapGesture {
    
    if (_currentOffset > 0) {
        [self closeLeftVCWithAnimation];
    }
}
- (void)pan:(UIPanGestureRecognizer *)panGesture {

    
    CGPoint offsetPoint = [panGesture translationInView:self.view];
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        [self transitionViewWithOffset:_currentOffset + offsetPoint.x];
    } else {
        _currentOffset = offsetPoint.x + _currentOffset;
        _currentOffset = _currentOffset < 0 ? 0: _currentOffset;
        _currentOffset = _currentOffset > self.openOffset? self.openOffset : _currentOffset;
        //手势结束后矫正位置
        
        if (_currentOffset > self.openOffset / 2) {
            [self openLeftVCWithAnimation];
        } else{
            [self closeLeftVCWithAnimation];
        }
    }
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (_currentOffset > 0) {
        return YES;
    } else {
        return NO;
    }
}
- (void)openLeftVCWithAnimation {

    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self transitionViewWithOffset:self.openOffset];
    } completion:nil];
    

    _currentOffset = self.openOffset;
}
- (void)closeLeftVCWithAnimation {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self transitionViewWithOffset:0];
    } completion:nil];

    _currentOffset = 0;
}
- (void)transitionViewWithOffset:(CGFloat)offset {
    if (offset < 0) {
        return;
    }
    //大小
    CGFloat ratio = 1 - ((1 - self.scale) / self.openOffset * offset);
    ratio = MAX(ratio, self.scale);
    offset = MIN(offset, self.openOffset);
    
    self.contentView.transform = CGAffineTransformMakeScale(ratio, ratio);
    _currentVC.view.transform = CGAffineTransformMakeScale( ratio, ratio);
    
    for (UIViewController * vc in self.viewControllers) {
        vc.view.transform = CGAffineTransformMakeScale( ratio, ratio);
    }
    
    _contentView.transform = CGAffineTransformMakeTranslation(offset, 0);
    
    
}
- (BOOL)isOpened {
    
    return _currentOffset > 0;
}
- (CGFloat)openOffset {
    if (_openOffset <= 0) {
        return 150;
    }
    return _openOffset;
}
- (CGFloat)scale {
    if (_scale > 1 || _scale < 0.5) {
        return 0.85;
    }
    return _scale;
}
- (UIView *)contentView {
    if (_contentView == nil) {
        self.contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [self.view addSubview:_contentView];
    }
    return _contentView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
