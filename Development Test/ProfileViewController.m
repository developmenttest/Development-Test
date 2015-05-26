//
//  ProfileViewController.m
//  Development Test
//
//  Created by Development Test on 25/05/15.
//  Copyright (c) 2015 Development. All rights reserved.
//

static NSInteger ASTagProfileImage = 101;

static NSString *ASTitleFromAlbum  = @"From Album";
static NSString *ASTitleFromCamera = @"From Camera";
static NSString *ASTitleFromCancel = @"Cancel";

#import "ProfileViewController.h"
#import "DTDBManager.h"

@interface ProfileViewController ()
<UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
ZWTTextboxToolbarHandlerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtDateOfBirth;

@property (weak, nonatomic) IBOutlet UIButton *btnProfileImage;
@property (weak, nonatomic) IBOutlet UIButton *btnGender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrvProfile;
@property (weak, nonatomic) IBOutlet UIDatePicker *dpBirthDate;

@property (strong, nonatomic) ZWTTextboxToolbarHandler *textboxHandler;

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *birthDate;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSData *imageData;

@property (strong, nonatomic) DTDBManager *dbManager;

@end

@implementation ProfileViewController

@synthesize btnGender, btnProfileImage, dbManager;
@synthesize txtFirstName, txtLastName, txtDateOfBirth;
@synthesize scrvProfile, textboxHandler, dpBirthDate;
@synthesize firstName, lastName, birthDate, gender, imageData;

#pragma mark - UIViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareViews];

    dbManager = [[DTDBManager alloc] initDatabasewithName:@"users"];
    
    [self loadProfileDetail];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Views Methods
- (void)prepareViews
{
    [self prepareProfileView];
    [self prepareTextFields];
}

- (void)prepareProfileView
{
    btnProfileImage.layer.cornerRadius = 5.0;
    
    btnProfileImage.clipsToBounds = YES;
    
    scrvProfile.contentSize = CGSizeMake(CGRectGetWidth(scrvProfile.frame), CGRectGetMaxY(btnGender.frame));
}

- (void)prepareTextFields
{
    NSArray *allTextFields = @[txtFirstName, txtLastName, txtDateOfBirth];
    
    for(UITextField *textField in allTextFields)
    {
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.leftView     = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    }
    
    textboxHandler = [[ZWTTextboxToolbarHandler alloc] initWithTextboxs:allTextFields andScroll:scrvProfile];
    
    textboxHandler.delegate = self;
    
    txtDateOfBirth.inputView = self.dpBirthDate;
}

#pragma mark - Enents Methods
- (IBAction)btngenderTap:(UIButton *)sender
{
    if(btnGender.isSelected)
    {
        [btnGender setImage:[UIImage imageNamed:@"switch_gender_male"] forState:UIControlStateNormal];
        
        btnGender.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        btnGender.selected = NO;
    }
    else
    {
        [btnGender setImage:[UIImage imageNamed:@"switch_gender_female"] forState:UIControlStateNormal];
        
        btnGender.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        btnGender.selected = YES;
    }
}

- (IBAction)dpBirthDateChange:(UIDatePicker *)sender
{
    NSDate *selectedDate = dpBirthDate.date;
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    
    [df setDateFormat:@"dd-MM-yyyy"];
    
    NSString *selectedDateString = [df stringFromDate:selectedDate];
    
    txtDateOfBirth.text = selectedDateString;
}

- (IBAction)btnProfileTap:(UIButton *)sender
{
    UIActionSheet *videoActionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Picture"
                                                                  delegate:self
                                                         cancelButtonTitle:ASTitleFromCamera
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:ASTitleFromAlbum, ASTitleFromCamera, nil];
    videoActionSheet.tag = ASTagProfileImage;
    
    [videoActionSheet showInView:self.view];
}

- (IBAction)swipeDown:(UISwipeGestureRecognizer *)sender
{
    if([self validateUserProfile])
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        
        if([dbManager fetchData])
        {
            [dbManager updateDataForfirstName:firstName lastName:lastName dateOfBirth:birthDate gender:gender image:imageData];
        }
        else
        {
            [dbManager saveProfile:firstName lastName:lastName date:birthDate data:imageData gender:gender];
        }
        
        [self saveInParse];
    }
}

#pragma mark - Helper Methods
- (void)loadProfileDetail
{
    
}

- (void)saveInParse
{
    PFFile *imageFile = [PFFile fileWithName:@"Image.png" data:imageData];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (!error)
        {
            [[PFUser currentUser] setObject:imageFile   forKey:userImage];
            [[PFUser currentUser] setObject:firstName   forKey:userFirstName];
            [[PFUser currentUser] setObject:lastName    forKey:userLastName];
            [[PFUser currentUser] setObject:birthDate   forKey:userBirthDate];
            [[PFUser currentUser] setObject:gender      forKey:userGender];
            
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
            {
                if (!error)
                {
                    NSLog(@"Saved");
                    
                    [[[UIAlertView alloc] initWithTitle:@"Development Test"
                                                message:@"Profile Saved."
                                               delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil, nil] show];
                }
                else
                {
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
                
                [SVProgressHUD dismiss];
            }];
        }
    }];
}

- (BOOL)validateUserProfile
{
    firstName = [txtFirstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    lastName  = [txtLastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    birthDate = txtDateOfBirth.text;
    imageData = [NSData dataWithData:UIImagePNGRepresentation([btnProfileImage imageForState:UIControlStateNormal])];
    gender    = (btnGender.isSelected) ? @"Female" : @"Male";
    
    if (firstName.length == 0)
    {
        NSLog(@"Please Enter FirstName.");
        
        return NO;
    }
    else if (lastName.length == 0)
    {
        NSLog(@"Please Enter LastName.");
        
        return NO;
    }
    else if (birthDate.length == 0)
    {
        NSLog(@"Please Enter Birthdate.");
        
        return NO;
    }
    else if (imageData.length == 0)
    {
        NSLog(@"Please Select Image");
        
        return NO;
    }
    else if (gender.length == 0)
    {
        NSLog(@"Please Select Gender");
        
        return NO;
    }
    
    return YES;
}

#pragma mark - UIActionSheetDelegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if(actionSheet.tag == ASTagProfileImage && ![buttonTitle isEqualToString:ASTitleFromCancel])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        
        controller.delegate      = self;
        controller.allowsEditing = YES;
        
        if([buttonTitle isEqualToString:ASTitleFromCamera])
        {
            controller.sourceType   = UIImagePickerControllerSourceTypeCamera;
        }
        else if ([buttonTitle isEqualToString:ASTitleFromAlbum])
        {
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary ;
        }
        
        controller.navigationBar.tintColor = [UIColor blackColor];
        
        [self presentViewController:controller animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    [btnProfileImage setImage:[info objectForKey:UIImagePickerControllerEditedImage] forState:UIControlStateNormal];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ZWTTextboxToolbarHandlerDelegate Methods
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == txtDateOfBirth)
    {
        [self dpBirthDateChange:dpBirthDate];
    }
}

@end