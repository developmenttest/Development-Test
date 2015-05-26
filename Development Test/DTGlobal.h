//
//  DTGlobal.h
//  Development Test
//
//  Created by Development Test on 25/05/15.
//  Copyright (c) 2015 Development. All rights reserved.
//

#define DTGlobalObject [DTGlobal global]

typedef NS_ENUM(NSInteger, DTScreenSizeType)
{
    DTScreenSizeTypeUnknown  = 0,
    DTScreenSizeTypeIPhone4  = 1,
    DTScreenSizeTypeIPhone5  = 2,
    DTScreenSizeTypeIPhone6  = 3,
    DTScreenSizeTypeIPhone6p = 4
};

@interface DTGlobal : NSObject

@property (nonatomic) DTScreenSizeType screenSizeType;

+ (DTGlobal *)global;

+ (BOOL)reachable;

@end