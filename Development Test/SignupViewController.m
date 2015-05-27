//
//  SignupViewController.m
//  Development Test
//
//  Created by Development Test on 25/05/15.
//  Copyright (c) 2015 Development. All rights reserved.
//

#import "SignupViewController.h"
#import "ProfileViewController.h"

@interface SignupViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgvBG;

@property (weak, nonatomic) IBOutlet UILabel *lblCreateAccount;

@property (weak, nonatomic) IBOutlet UIView *viewCreateAccount;

@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;

@property (weak, nonatomic) IBOutlet UIScrollView *scrvSignup;

@property (strong, nonatomic) ZWTTextboxToolbarHandler *textboxHandler;

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *confirmPassword;

@end

@implementation SignupViewController

@synthesize imgvBG, lblCreateAccount, viewCreateAccount;
@synthesize txtUsername, txtPassword, txtConfirmPassword;
@synthesize textboxHandler, scrvSignup;
@synthesize userName, password, confirmPassword;

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
    viewCreateAccount.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
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

#pragma mark - Event Methods
- (IBAction)btnCreateAccountTap:(id)sender
{
    if ([self validateInfo])
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        
        [textboxHandler btnDoneTap];
        
        PFUser *newuser = [PFUser user];
        
        newuser.username = userName;
        newuser.password = password;
        
        [newuser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
        {
            dispatch_async(dispatch_get_main_queue(), ^
            {
                [SVProgressHUD dismiss];
            });
            
            if (!error)
            {
                NSLog(@"Sign Up SuccessFully");
                
                [DTUser saveUserName:userName];
                
                ProfileViewController *vcProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
                
                [self.navigationController pushViewController:vcProfile animated:YES];
            }
            else
            {
                NSString *errorString = [error userInfo][@"error"];
                 
                UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:Appname
                                                                    message:errorString
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertview show];
            }
        }];
    }
}

#pragma mark - Helper Methods
- (BOOL)validateInfo
{
    userName = [txtUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    password = txtPassword.text;
    
    confirmPassword = txtConfirmPassword.text;
    
    if (userName.length == 0)
    {
        UIAlertView *userNameAlert = [[UIAlertView alloc] initWithTitle:Appname
                                                                message:@"Please Enter Username."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
        [userNameAlert show];
        
        return NO;
    }
    else if (password.length == 0)
    {
        UIAlertView *userNameAlert = [[UIAlertView alloc] initWithTitle:Appname
                                                                message:@"Please Enter Password."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
        [userNameAlert show];
        
        return NO;
    }
    else if (confirmPassword.length == 0)
    {
        UIAlertView *userNameAlert = [[UIAlertView alloc] initWithTitle:Appname
                                                                message:@"Please Enter Confirm Password."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
        [userNameAlert show];
        
        return NO;
    }
    else if (![password isEqualToString:confirmPassword])
    {
        UIAlertView *userNameAlert = [[UIAlertView alloc] initWithTitle:Appname
                                                                message:@"Password and Confirm Password must match."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
        [userNameAlert show];
        
        return NO;
    }
    
    return YES;
}

@end