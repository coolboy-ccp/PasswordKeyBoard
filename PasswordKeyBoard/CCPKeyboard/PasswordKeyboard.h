//
//  PasswordKeyboard.h
//  Overseas
//
//  Created by Ceair on 2017/10/19.
//  Copyright © 2017年 ceair. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordKeyboard : UIView

+ (instancetype) keyboard;

//输入完成后回调 password为保存的密码
@property (nonatomic, copy) void(^completeBlock)(NSString *password);

//显示
- (void)showKeyboard;

//隐藏
- (void)hideKeyboard;

@end
