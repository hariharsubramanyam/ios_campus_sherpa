//
//  CSTour.h
//  CampusSherpa
//
//  Created by Harihar Subramanyam on 3/22/14.
//  Copyright (c) 2014 Campus Sherpa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSUser.h"

@interface CSTour : NSObject
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic, strong) CSUser *creator;

@end
