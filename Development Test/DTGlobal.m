//
//  DTGlobal.m
//  Development Test
//
//  Created by Development Test on 25/05/15.
//  Copyright (c) 2015 Development. All rights reserved.
//

#import "DTGlobal.h"

@implementation DTGlobal

@synthesize screenSizeType;

+ (DTGlobal *)global
{
    static DTGlobal *object = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
    {
        object = [[self alloc] init];
    });
    
    return object;
}

- (instancetype) init
{
    self = [super init];
    
    if(self)
    {
        
    }
    
    return self;
}

- (DTScreenSizeType)screenSizeType
{
    if(screenSizeType == DTScreenSizeTypeUnknown)
    {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        if(screenSize.height == 480)
        {
            return DTScreenSizeTypeIPhone4;
        }
        else if(screenSize.height == 568)
        {
            return DTScreenSizeTypeIPhone5;
        }
        else if (screenSize.height == 667)
        {
            return DTScreenSizeTypeIPhone6;
        }
        else if (screenSize.height == 736)
        {
            return DTScreenSizeTypeIPhone6p;
        }
        else
        {
            return DTScreenSizeTypeUnknown;
        }
    }
    
    return screenSizeType;
}

@end