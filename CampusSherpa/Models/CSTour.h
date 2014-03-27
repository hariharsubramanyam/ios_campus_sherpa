//
//  CSTour.h
//  CampusSherpa
//
//  Created by Harihar Subramanyam on 3/22/14.
//  Copyright (c) 2014 Campus Sherpa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSTourLocation.h"
#import <Parse/Parse.h>

@interface CSTour : NSObject
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic, strong) NSMutableArray *tourLocationIDs;
@property (nonatomic, strong) NSData *thumbnail;
@property (nonatomic, strong) PFFile *thumbnailParseFile;
@property (nonatomic, strong) NSMutableArray *tourLocations;

- (instancetype) initWithID:(NSString *)objectId name:(NSString *)name description:(NSString *)description duration:(NSTimeInterval)duration tourLocationIDs:(NSMutableArray *)tourLocationIDs thumbnailParseFile:(PFFile *)thumbnailParseFile;
@end
