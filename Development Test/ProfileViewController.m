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
ZWTTextboxToolbarHandlerDelegate,
UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtDateOfBirth;
@property (weak, nonatomic) IBOutlet UITextField *txtEmailAddress;

@property (weak, nonatomic) IBOutlet UIButton *btnProfileImage;
@property (weak, nonatomic) IBOutlet UIButton *btnGender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrvProfile;
@property (weak, nonatomic) IBOutlet UIDatePicker *dpBirthDate;

@property (weak, nonatomic) IBOutlet UIView *viewAllContent;

@property (strong, nonatomic) ZWTTextboxToolbarHandler *textboxHandler;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *birthDate;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSData *imageData;

@property (strong, nonatomic) DTDBManager *dbManager;

@property (nonatomic) BOOL isChange;
@property (nonatomic) BOOL isLoadTime;
@property (nonatomic) BOOL showActivityIndicator;

@end

@implementation ProfileViewController

@synthesize btnGender, btnProfileImage, dbManager;
@synthesize txtFirstName, txtLastName, txtDateOfBirth, txtEmailAddress;
@synthesize scrvProfile, textboxHandler, dpBirthDate;
@synthesize firstName, lastName, birthDate, gender, imageData, email;
@synthesize isChange, activityIndicator, showActivityIndicator, isLoadTime, viewAllContent;

#pragma mark - UIViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isLoadTime = YES;
    dbManager = [[DTDBManager alloc] initDatabasewithName:@"users"];
    
    [self prepareViews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (isLoadTime)
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        
        [self loadProfileDetail];
        
        isLoadTime = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [textboxHandler btnDoneTap];
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
    
    scrvProfile.contentSize = CGSizeMake(CGRectGetWidth(scrvProfile.frame), CGRectGetHeight(viewAllContent.frame) + 60);
}

- (void)prepareTextFields
{
    NSArray *allTextFields = @[txtFirstName, txtLastName, txtEmailAddress, txtDateOfBirth];
    
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
    
    isChange = YES;
}

- (IBAction)dpBirthDateChange:(UIDatePicker *)sender
{
    NSDate *selectedDate = dpBirthDate.date;
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    
    [df setDateFormat:@"dd-MM-yyyy"];
    
    NSString *selectedDateString = [df stringFromDate:selectedDate];
    
    txtDateOfBirth.text = selectedDateString;
    
    isChange = YES;
}

- (IBAction)btnProfileTap:(UIButton *)sender
{
    UIActionSheet *videoActionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Picture"
                                                                  delegate:self
                                                         cancelButtonTitle:ASTitleFromCancel
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:ASTitleFromAlbum, ASTitleFromCamera, nil];
    videoActionSheet.tag = ASTagProfileImage;
    
    [videoActionSheet showInView:self.view];
}

- (void)swipeDown
{
    if(isChange)
    {
        if([self validateUserProfile])
        {
            NSDictionary *userDict = @{
                                       userFirstName : firstName,
                                       userLastName  : lastName,
                                       userEmail     : email,
                                       userBirthDate : birthDate,
                                       userImage     : [btnProfileImage imageForState:UIControlStateNormal],
                                       userGender    : gender,
                                       userModifiedDate : [DTGlobal stringForDate:[NSDate date]]
                                       };
            
            DTUser *userToSave = [[DTUser alloc] initWithDictionary:userDict];
            
            [self saveUserInDatabase:userToSave];
            
            if ([DTGlobal reachable])
            {
                [self saveInParse:userToSave];
            }
            else
            {
                [self hideActivityIndicator];
            }
            
            isChange = NO;
        }
    }
    else
    {
        [self loadProfileDetail];
    }
}

#pragma mark - Helper Methods
- (void)saveUserInDatabase:(DTUser *)userToSave
{
    if([dbManager fetchData])
    {
        [dbManager updateUser:userToSave];
    }
    else
    {
        [dbManager saveUser:userToSave];
    }
}

- (void)loadProfileDetail
{
    if([DTGlobal reachable])
    {
        [self loadUserFromParse:^(DTUser *remoteUser)
        {
            DTUser *localUser = [dbManager fetchData];
            
            if([remoteUser.modifiedDate compare:localUser.modifiedDate] == NSOrderedAscending)//Local user is latest
            {
                [self displayUser:localUser];
                [self saveInParse:localUser];
            }
            else if([remoteUser.modifiedDate compare:localUser.modifiedDate] == NSOrderedDescending)//Remote user is latest
            {
                [self displayUser:remoteUser];
                [self saveUserInDatabase:remoteUser];
            }
            else
            {
                if(localUser == nil && remoteUser)
                {
                    [self displayUser:remoteUser];
                    [self saveUserInDatabase:remoteUser];
                }
                else if (remoteUser == nil && localUser)
                {
                    [self displayUser:localUser];
                    [self saveInParse:localUser];
                }
                else
                {
                    [self displayUser:remoteUser];
                    [SVProgressHUD dismiss];
                }
            }
        }];
    }
    else
    {
        DTUser *user = [dbManager fetchData];
        
        [self displayUser:user];
    }
}

- (void)displayUser:(DTUser *)user
{
    [SVProgressHUD dismiss];
    
    isChange = NO;
    
    txtFirstName.text       = user.firstName;
    txtLastName.text        = user.lastName;
    txtDateOfBirth.text     = user.birthDate;
    txtEmailAddress.text    = user.email;
    
    if([user.gender isEqualToString:@"Male"])
    {
        [btnGender setImage:[UIImage imageNamed:@"switch_gender_male"] forState:UIControlStateNormal];
        
        btnGender.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        btnGender.selected = NO;
    }
    else if([user.gender isEqualToString:@"Female"])
    {
        [btnGender setImage:[UIImage imageNamed:@"switch_gender_female"] forState:UIControlStateNormal];
        
        btnGender.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        btnGender.selected = YES;
    }
    
    [btnProfileImage setImage:user.image forState:UIControlStateNormal];
    
    [self hideActivityIndicator];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    NSDate *date = [dateFormatter dateFromString:user.birthDate];
    
    [dpBirthDate setDate:date];
}

- (void)loadUserFromParse:(void(^)(DTUser *userDetail))parseUser
{
    [[PFUser currentUser] fetchInBackgroundWithBlock:^(PFObject *object, NSError *error)
    {
        if(!error)
        {
            PFUser *fetcheduser = (PFUser *)object;
             
            PFFile *imageFile = [fetcheduser objectForKey:userImage];
             
            NSURL *imgURL = [NSURL URLWithString:[imageFile url]];
            
            NSData *dataImage = [[NSData alloc] initWithContentsOfURL:imgURL];
            
            UIImage *profileImage = [UIImage imageWithData:dataImage];
            
            NSString *modifiedDate = [fetcheduser objectForKey:userModifiedDate];
            
            NSMutableDictionary *userInfo = @{}.mutableCopy;
            
            if([fetcheduser objectForKey:userFirstName])
            {
                [userInfo setObject:[fetcheduser objectForKey:userFirstName] forKey:userFirstName];
            }
            
            if([fetcheduser objectForKey:userLastName])
            {
                [userInfo setObject:[fetcheduser objectForKey:userLastName] forKey:userLastName];
            }
           
            if ([fetcheduser objectForKey:userEmail])
            {
                [userInfo setObject:[fetcheduser objectForKey:userEmail] forKey:userEmail];
            }
            
            if([fetcheduser objectForKey:userBirthDate])
            {
                [userInfo setObject:[fetcheduser objectForKey:userBirthDate] forKey:userBirthDate];
            }
            
            if([fetcheduser objectForKey:userGender])
            {
                [userInfo setObject:[fetcheduser objectForKey:userGender] forKey:userGender];
            }
            
            if(profileImage)
            {
                [userInfo setObject:profileImage forKey:userImage];
            }
            else
            {
                [userInfo setObject:[UIImage imageNamed:@"placeholder_profilepicture"] forKey:userImage];
            }
            
            if(modifiedDate)
            {
                [userInfo setObject:modifiedDate forKey:userModifiedDate];
            }
            else
            {
                [userInfo setObject:[NSDate dateWithTimeIntervalSince1970:0] forKey:userModifiedDate];
            }
            
            DTUser *currentUser = [[DTUser alloc]initWithDictionary:userInfo];
            
            parseUser(currentUser);
        }
        else
        {
            [SVProgressHUD dismiss];
        }
     }];
}

- (void)saveInParse:(DTUser *)userToSave
{
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:UIImageJPEGRepresentation(userToSave.image, 0.8)];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (!error)
        {
            NSString *dateTime = [DTGlobal stringForDate:[NSDate date]];
            
            [[PFUser currentUser] setObject:imageFile              forKey:userImage];
            [[PFUser currentUser] setObject:userToSave.firstName   forKey:userFirstName];
            [[PFUser currentUser] setObject:userToSave.lastName    forKey:userLastName];
            [[PFUser currentUser] setObject:userToSave.birthDate   forKey:userBirthDate];
            [[PFUser currentUser] setObject:userToSave.gender      forKey:userGender];
            [[PFUser currentUser] setObject:dateTime               forKey:userModifiedDate];
            [PFUser currentUser].email = userToSave.email;
            
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
            {
                if (!error)
                {
                    NSLog(@"Saved");
                }
                else
                {
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
                
                [self hideActivityIndicator];
            }];
        }
        else
        {
            [self hideActivityIndicator];
        }
    }];
}

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

- (BOOL)validateUserProfile
{
    firstName = [txtFirstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    lastName  = [txtLastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    birthDate = txtDateOfBirth.text;
    imageData = [NSData dataWithData:UIImagePNGRepresentation([btnProfileImage imageForState:UIControlStateNormal])];
    gender    = (btnGender.isSelected) ? @"Female" : @"Male";
    email     = [txtEmailAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (firstName.length == 0)
    {
        NSLog(@"Please Enter FirstName.");
        
        [[[UIAlertView alloc] initWithTitle:Appname
                                    message:@"Please Enter FirstName."
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
        
        return NO;
    }
    else if (lastName.length == 0)
    {
        NSLog(@"Please Enter LastName.");
        
        [[[UIAlertView alloc] initWithTitle:Appname
                                    message:@"Please Enter LastName."
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
        
        return NO;
    }
    else if (![self validateEmail:email])
    {
        NSLog(@"Please Enter Valid Email.");
        
        [[[UIAlertView alloc] initWithTitle:Appname
                                    message:@"Please Enter Valid Email."
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
        
        return NO;
    }
    else if (birthDate.length == 0)
    {
        NSLog(@"Please Enter Birthdate.");
        
        [[[UIAlertView alloc] initWithTitle:Appname
                                    message:@"Please Enter Birthdate."
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
        
        return NO;
    }
    else if (imageData.length == 0)
    {
        NSLog(@"Please Select Image");
        
        [[[UIAlertView alloc] initWithTitle:Appname
                                    message:@"Please Select Image."
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
        
        return NO;
    }
    else if (gender.length == 0)
    {
        NSLog(@"Please Select Gender");
        
        [[[UIAlertView alloc] initWithTitle:Appname
                                    message:@"Please Select Gender."
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
        
        return NO;
    }
    
    return YES;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)hideActivityIndicator
{
    scrvProfile.contentOffset = CGPointMake(0, 0);
    scrvProfile.contentInset  = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [activityIndicator stopAnimating];
    
    [activityIndicator removeFromSuperview];
    
    activityIndicator = nil;
    
    showActivityIndicator = NO;
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
    UIImage *imgProfile = [self imageWithImage:[info objectForKey:UIImagePickerControllerEditedImage] scaledToSize:CGSizeMake(110, 110)];
    
    [btnProfileImage setImage:imgProfile forState:UIControlStateNormal];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    isChange = YES;
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == txtDateOfBirth)
    {
        return NO;
    }
    
    isChange = YES;
    
    return YES;
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%@", @(scrollView.contentOffset.y));
    
    if(scrollView.contentOffset.y < -40)
    {
        if(!activityIndicator)
        {
            activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
            activityIndicator.frame = CGRectMake(CGRectGetWidth(scrollView.frame)/2.0 - 25, -40, 50, 50);
        }
    
        [scrollView addSubview:activityIndicator];
        
        [activityIndicator startAnimating];
        
        showActivityIndicator = YES;
        
        scrollView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
    }
    else
    {
       showActivityIndicator = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(showActivityIndicator)
    {
        showActivityIndicator = NO;
        
        scrollView.contentOffset = CGPointMake(0, -50);
        
        scrollView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
        
        [textboxHandler btnDoneTap];
        
        [self swipeDown];
    }
}

@end