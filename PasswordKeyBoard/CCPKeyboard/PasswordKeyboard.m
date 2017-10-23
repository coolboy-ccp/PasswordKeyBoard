//
//  PasswordKeyboard.m
//  Overseas
//
//  Created by Ceair on 2017/10/19.
//  Copyright © 2017年 ceair. All rights reserved.
//

#import "PasswordKeyboard.h"

#define main_bounds [UIScreen mainScreen].bounds
#define scale_w main_bounds.size.width/375.0

@interface UIView(keyboard)
- (CGFloat)getSupH;
@end
@implementation UIView(keyboard)
- (CGFloat)getSupH {
    NSMutableArray *svHs = [NSMutableArray array];
    for (UIView *sv in self.subviews) {
        [svHs addObject:@(CGRectGetMaxY(sv.frame))];
    }
    CGFloat max = [[svHs valueForKeyPath:@"@max.doubleValue"] floatValue];
    return max;
}
@end

@interface PasswordKeyboard()

//键盘视图
@property (weak, nonatomic) IBOutlet UIView *boardView;
//显示密码的视图
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *dotViews;
//键盘视图的y(用于动画)
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomY;
//键盘按钮的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyBtnH;
//密码显示视图的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordH;
//小菊花
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *hud;

@property (nonatomic, copy) NSMutableArray *numbers;

@end
@implementation PasswordKeyboard

+ (instancetype) keyboard {
    PasswordKeyboard *keyboard = [[NSBundle mainBundle] loadNibNamed:@"PasswordKeyboard" owner:nil options:nil].firstObject;
    keyboard.frame = main_bounds;
    keyboard.hidden = YES;
    keyboard.passwordH.constant *= scale_w;
    keyboard.keyBtnH.constant *= scale_w;
    keyboard.bottomY.constant = -[keyboard.boardView getSupH];
    return keyboard;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
}

- (void)showKeyboard {
    self.hidden = NO;
    _numbers = [NSMutableArray array];
    _bottomY.constant = 0;
    [self handleDot];
    [UIView animateWithDuration:.35 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)hideKeyboard {
    _bottomY.constant = -[_boardView getSupH];
    [UIView animateWithDuration:.35 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (IBAction)back:(id)sender {
    [self hideKeyboard];
}

- (IBAction)keyTap:(UIButton *)sender {
    NSString *str = [NSString stringWithFormat:@"%ld",sender.tag - 200];
    [_numbers addObject:str];
    [self handleDot];
    if (_numbers.count == _dotViews.count) {
        [_hud startAnimating];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_hud stopAnimating];
            [self hideKeyboard];
        });
        NSString *password = [_numbers componentsJoinedByString:@""];
        if (_completeBlock) {
            _completeBlock(password);
        }
    }
}


- (IBAction)deleteNum:(id)sender {
    if (_numbers.count > 0) {
        [_numbers removeObjectAtIndex:_numbers.count - 1];
        [self handleDot];
    }
}

- (void)handleDot {
    [_dotViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < _numbers.count) {
            obj.hidden = NO;
        }
        else {
            obj.hidden = YES;
        }
    }];
}

@end
