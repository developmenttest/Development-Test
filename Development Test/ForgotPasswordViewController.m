//
//  ForgotPasswordViewController.m
//  Development Test
//
//  Created by Development Test on 25/05/15.
//  Copyright (c) 2015 Development. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgvBG;

@property (weak, nonatomic) IBOutlet UILabel *lblReset;
@property (weak, nonatomic) IBOutlet UIView *viewReset;

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

@property (weak, nonatomic) IBOutlet UIScrollView *scrvReset;

@property (weak, nonatomic) IBOutlet UIButton *btnReset;

@property (strong, nonatomic) ZWTTextboxToolbarHandler *textboxHandler;;

@end

@implementation ForgotPasswordViewController

@synthesize imgvBG, lblReset, viewReset, txtEmail;
@synthesize textboxHandler, scrvReset, btnReset;

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
    [self prepareResetView];
    [self prepareTextFields];
}

- (void)prepareTextFields
{
    txtEmail.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    
    txtEmail.leftViewMode = UITextFieldViewModeAlways;
    
    textboxHandler = [[ZWTTextboxToolbarHandler alloc] initWithTextboxs:@[txtEmail] andScroll:scrvReset];
}

- (void)prepareResetView
{
    viewReset.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    viewReset.clipsToBounds = YES;
    
    viewReset.layer.cornerRadius = 10.0;
    
    CGRect frame = lblReset.frame;
    
    frame.origin.y = CGRectGetMinY(viewReset.frame) - CGRectGetHeight(frame);
    
    lblReset.frame = frame;
    
    scrvReset.contentSize = CGSizeMake(CGRectGetWidth(scrvReset.frame), CGRectGetMaxY(viewReset.frame));
    
    btnReset.titleLabel.textAlignment = NSTextAlignmentCenter;
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

#pragma mark - Helper Method
- (BOOL)validateEmail:(NSString *)emailString
{
    BOOL validEmail = NO;
    
    if(nil != emailString && [emailString length])
    {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}";
        
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        
        validEmail = [emailTest evaluateWithObject:emailString];
    }
    
    return validEmail;
}

#pragma mark - Event Method
- (IBAction)btnResetPasswordTap:(id)sender
{
    NSString *email = [txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([self validateEmail:email])
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        
        [PFUser requestPasswordResetForEmailInBackground:email block:^(BOOL succeeded, NSError *error)
        {
            if (error.code == 205)
            {
                NSDictionary *errorDict = error.userInfo;
                 
                [[[UIAlertView alloc] initWithTitle:Appname
                                            message:errorDict[@"error"]
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil, nil] show];
             }
             else if (succeeded)
             {
                 [[[UIAlertView alloc] initWithTitle:Appname
                                             message:@"Password reset link successfully sent to your email address."
                                            delegate:self
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil, nil] show];
                 
                 [self dismissViewControllerAnimated:YES completion:nil];
             }
             
             [SVProgressHUD dismiss];
         }];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:Appname
                                    message:@"Please Enter Valid Email address."
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
    }
    
}

- (IBAction)btnCancelTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end