//
//  DTUser.h
//  dataBase
//
//  Created by Vivek on 25/05/15.
//  Copyright (c) 2015 cloudZon Infosoft. All rights reserved.
//

extern NSString *const userFirstName;
extern NSString *const userLastName;
extern NSString *const userGender;
extern NSString *const userBirthDate;
extern NSString *const userEmail;
extern NSString *const userImage;
extern NSString *const userModifiedDate;

@interface DTUser : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *birthDate;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) UIImage  *image;
@property (strong, nonatomic) NSDate   *modifiedDate;

- (instancetype)initWithDictionary:(NSDictionary *)userInfo NS_DESIGNATED_INITIALIZER;

+ (void)saveUserName:(NSString *)userName;
+ (BOOL)isAnyUserLogin;

@end
