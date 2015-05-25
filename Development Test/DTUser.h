//
//  DTUser.h
//  dataBase
//
//  Created by Vivek on 25/05/15.
//  Copyright (c) 2015 cloudZon Infosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *const userFirstName;
NSString *const userLastName;
NSString *const userGender;
NSString *const userBirthDate;
NSString *const userImage;

@interface DTUser : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *birthDate;
@property (strong, nonatomic) UIImage  *image;

- (instancetype)initWithDictionary:(NSDictionary *)userInfo;

@end
