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
extern NSString *const userImage;

@interface DTUser : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *birthDate;
@property (strong, nonatomic) UIImage  *image;

- (instancetype)initWithDictionary:(NSDictionary *)userInfo NS_DESIGNATED_INITIALIZER;

@end
