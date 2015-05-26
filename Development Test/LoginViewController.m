//
//  LoginViewController.m
//  Development Test
//
//  Created by Development Test on 25/05/15.
//  Copyright (c) 2015 Development. All rights reserved.
//

#import "LoginViewController.h"
#import "ProfileViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgvBG;

@property (weak, nonatomic) IBOutlet UILabel *lblLogin;
@property (weak, nonatomic) IBOutlet UIView *viewLogin;

@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@property (weak, nonatomic) IBOutlet UIButton *btnForgotPassowrd;

@property (weak, nonatomic) IBOutlet UIScrollView *scrvLogin;

@property (strong, nonatomic) ZWTTextboxToolbarHandler *textboxHandler;

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *passWord;

@end

@implementation LoginViewController

@synthesize imgvBG, lblLogin, viewLogin, txtUsername, txtPassword, btnForgotPassowrd, scrvLogin, textboxHandler;
@synthesize userName, passWord;

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
    
    textboxHandler = [[ZWTTextboxToolbarHandler alloc] initWithTextboxs:@[txtUsername, txtPassword] andScroll:scrvLogin];
}

- (void)prepareLoginView
{
    viewLogin.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    viewLogin.clipsToBounds = YES;
    
    viewLogin.layer.cornerRadius = 10.0;
    
    CGRect frame = lblLogin.frame;
    
    frame.origin.y = CGRectGetMinY(viewLogin.frame) - CGRectGetHeight(frame) - 10;
    
    lblLogin.frame = frame;
    
    scrvLogin.contentSize = CGSizeMake(CGRectGetWidth(scrvLogin.frame), CGRectGetMaxY(viewLogin.frame));
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

#pragma mark - Event Methos
- (IBAction)btnLoginTap:(id)sender
{
    if ([self validateInfo])
    {
        [textboxHandler btnDoneTap];
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        
        [PFUser logInWithUsernameInBackground:userName password:passWord block:^(PFUser *user, NSError *error)
        {
            if (user)
            {
                NSLog(@"Login SuccessFully");
                 
                ProfileViewController *vcProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
                
                [self.navigationController pushViewController:vcProfile animated:YES];
            }
            else
            {
                UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Developer Test"
                                                                    message:@"Wrong Username or Password"
                                                                delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertview show];
            }
            
            [SVProgressHUD dismiss];
        }];
    }
}

#pragma mark - Helper Methods
- (BOOL)validateInfo
{
    userName = [txtUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    passWord = [txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (userName.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Dev Test"
                                    message:@"Please Enter Username"
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
        return NO;
    }
    if (passWord.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Dev Test"
                                    message:@"Please Enter Passsword"
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
        return NO;
    }
    
    return YES;
}

@end