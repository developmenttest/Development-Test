//
//  LoginViewController.m
//  Development Test
//
//  Created by Development Test on 25/05/15.
//  Copyright (c) 2015 Development. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgvBG;

@property (weak, nonatomic) IBOutlet UILabel *lblLogin;
@property (weak, nonatomic) IBOutlet UIView *viewLogin;

@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@property (weak, nonatomic) IBOutlet UIButton *btnForgotPassowrd;
@end

@implementation LoginViewController

@synthesize imgvBG, lblLogin, viewLogin, txtUsername, txtPassword, btnForgotPassowrd;

#pragma mark - UIViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareViews];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Views Methods
- (void)prepareViews
{
    [self setBackgroundImage];
    [self prepareLoginView];
    [self prepareTextFields];
    [self prepareForgotPassword];
}

- (void)prepareTextFields
{
    txtUsername.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    txtPassword.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    
    txtUsername.leftViewMode = UITextFieldViewModeAlways;
    txtPassword.leftViewMode = UITextFieldViewModeAlways;
}

- (void)prepareLoginView
{
    viewLogin.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    viewLogin.clipsToBounds = YES;
    
    viewLogin.layer.cornerRadius = 10.0;
    
    CGRect frame = lblLogin.frame;
    
    frame.origin.y = CGRectGetMinY(viewLogin.frame) - CGRectGetHeight(frame) - 10;
    
    lblLogin.frame = frame;
}

- (void)prepareForgotPassword
{
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:[btnForgotPassowrd titleForState:UIControlStateNormal]
                                                                attributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)}];
    
    [btnForgotPassowrd setAttributedTitle:title forState:UIControlStateNormal];
}

- (void)setBackgroundImage
{
    switch (DTGlobalObject.screenSizeType)
    {
        case DTScreenSizeTypeIPhone4:
        {
            imgvBG.image = [UIImage imageNamed:@"bg-480"];
            
            break;
        }
        case DTScreenSizeTypeIPhone5:
        {
            imgvBG.image = [UIImage imageNamed:@"bg-568"];
            
            break;
        }
        case DTScreenSizeTypeIPhone6:
        {
            imgvBG.image = [UIImage imageNamed:@"bg-667"];
            
            break;
        }
        case DTScreenSizeTypeIPhone6p:
        {
            imgvBG.image = [UIImage imageNamed:@"bg-736"];
            
            break;
        }
        default:
        {
            imgvBG.image = [UIImage imageNamed:@"bg-736"];
            
            break;
        }
    }
}

@end