//
//  YJTextFieldView.m
//  TF
//
//  Created by 张杰 on 16/11/27.
//  Copyright © 2016年 JayZhang. All rights reserved.
//

#import "YJTextFieldView.h"

@interface YJTextFieldView()
@property(nonatomic,strong)UIView * bgView;


@end

@implementation YJTextFieldView{
    
    CGRect originalRect;//初始位置的尺寸
    CGRect currentRect;//当前位置的尺寸
    
    CGRect covertRect;//在屏幕中的相对尺寸
    CGRect targetRect;//键盘应该去的位置
    CGRect keyBoardRect;//键盘的frame
    
    BOOL isMoved;//自身是否移动过
    CGFloat offset_Y;//当前需要移动的偏移量
    
    BOOL isPoped;//是否是弹出过
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];

}

- (instancetype)init
{
    return  [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        originalRect = frame;
        currentRect = frame;
        [self funInitBaseControl];
        [self funAddKeyBoardObserve];
    }
    return self;
}

-(void)setBackgroundColor:(UIColor *)backgroundColor{
    
    _bgView.backgroundColor = backgroundColor;
    
}
-(void)setLeftImageView:(UIView *)leftImageView{
    
    _textField.leftView = leftImageView;
    
}

-(void)funInitBaseControl{
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, originalRect.size.width, originalRect.size.height)];
    [self addSubview:_bgView];
    CGFloat x = 15;
    CGFloat y = 5;
    CGFloat w = originalRect.size.width - x * 2;
    CGFloat h = originalRect.size.height - 2 * y;
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(x, y, w, h)];
//    UIImageView * imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, h, h)];
//    imageView.image = [UIImage imageNamed:@"pencil.jpg"];
//    _textField.leftView = imageView;
    _textField.borderStyle = UITextBorderStyleRoundedRect;
//    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.returnKeyType = UIReturnKeySend;
    [_bgView addSubview:_textField];
    
}
-(void)funAddKeyBoardObserve{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(funKeyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(funKeyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


-(void)funKeyBoardWillShow:(NSNotification *)noti{
    
    UIViewController * currentVC = [self currentViewController];//获取当前试图控制器
    covertRect = [self.superview convertRect:self.frame toView:currentVC.view];//在屏幕中的相对位置
    keyBoardRect  = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    offset_Y = CGRectGetMaxY(covertRect) - keyBoardRect.origin.y;
    if (offset_Y>0) {
        isMoved  = YES;
        currentRect = self.frame;
        targetRect = currentRect;
        targetRect.origin.y = currentRect.origin.y  - offset_Y;
        self.frame = targetRect;
    }else{
        
        if (isMoved) {
            currentRect = self.frame;
            targetRect = currentRect;
            targetRect.origin.y = currentRect.origin.y  - offset_Y;
            self.frame = targetRect;
        }
    
    }
}


-(void)funKeyBoardWillHide:(NSNotification *)noti{
    if (isMoved) {
        self.frame = originalRect;
    }
}


//获取当前视图控制器
-(UIViewController *)currentViewController{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    // modal展现方式的底层视图不同
    // 取到第一层时，取到的是UITransitionView，通过这个view拿不到控制器
    UIView *firstView = [keyWindow.subviews firstObject];
    UIView *secondView = [firstView.subviews firstObject];
    
    UIViewController *vc = [self getViewControllerWithView:secondView];
    
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)vc;
        if ([tab.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)tab.selectedViewController;
            return [nav.viewControllers lastObject];
        } else {
            return tab.selectedViewController;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        return [nav.viewControllers lastObject];
    } else {
        return vc;
    }
    return nil;
    
}

- (UIViewController *)getViewControllerWithView:(UIView *)view {
    if(view==nil) return nil;
    while (1) {
        if ([view.nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)view.nextResponder;
            break;
        }
        if(view==nil) return nil;
        view = view.superview;
    }
}


@end
