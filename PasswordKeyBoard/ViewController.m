//
//  ViewController.m
//  PasswordKeyBoard
//
//  Created by Ceair on 2017/10/20.
//  Copyright © 2017年 Ceair. All rights reserved.
//

#import "ViewController.h"
#import "PasswordKeyboard.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (nonatomic, strong) PasswordKeyboard *keyboard;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _keyboard = [PasswordKeyboard keyboard];
    [self.view addSubview:_keyboard];
    __weak typeof(self)wk = self;
    _keyboard.completeBlock = ^(NSString *password) {
        wk.pwdTF.text = [NSString stringWithFormat:@"password is %@.",password];
    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)pay:(id)sender {
    [_keyboard showKeyboard];
}

@end
