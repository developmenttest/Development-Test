//
//  SignupViewController.m
//  Development Test
//
//  Created by Development Test on 25/05/15.
//  Copyright (c) 2015 Development. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgvBG;

@property (weak, nonatomic) IBOutlet UILabel *lblCreateAccount;

@property (weak, nonatomic) IBOutlet UIView *viewCreateAccount;

@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;

@property (weak, nonatomic) IBOutlet UIScrollView *scrvSignup;

@property (strong, nonatomic) ZWTTextboxToolbarHandler *textboxHandler;

@end

@implementation SignupViewController

@synthesize imgvBG, lblCreateAccount, viewCreateAccount;
@synthesize txtUsername, txtPassword, txtConfirmPassword;
@synthesize textboxHandler, scrvSignup;

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
    [self prepareSignupView];
    [self prepareTextFields];
}

- (void)prepareTextFields
{
    NSArray *allTextFields = @[txtUsername, txtPassword, txtConfirmPassword];
    
    for(UITextField *textField in allTextFields)
    {
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.leftView     = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    }
    
    textboxHandler = [[ZWTTextboxToolbarHandler alloc] initWithTextboxs:allTextFields andScroll:scrvSignup];
}

- (void)prepareSignupView
{
    viewCreateAccount.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    viewCreateAccount.clipsToBounds = YES;
    
    viewCreateAccount.layer.cornerRadius = 10.0;
    
    CGRect frame = lblCreateAccount.frame;
    
    frame.origin.y = CGRectGetMinY(viewCreateAccount.frame) - CGRectGetHeight(frame) - 10;
    
    lblCreateAccount.frame = frame;
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