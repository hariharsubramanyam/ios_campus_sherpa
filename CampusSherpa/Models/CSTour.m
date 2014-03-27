//
//  CSTour.m
//  CampusSherpa
//
//  Created by Harihar Subramanyam on 3/22/14.
//  Copyright (c) 2014 Campus Sherpa. All rights reserved.
//

#import "CSTour.h"

@implementation CSTour
- (instancetype) initWithID:(NSString *)objectId name:(NSString *)name description:(NSString *)description duration:(NSTimeInterval)duration tourLocationIDs:(NSMutableArray *)tourLocationIDs thumbnailParseFile:(PFFile *)thumbnailParseFile{
    self = [super init];
    
    if (self) {
        self.objectId = objectId;
        self.name = name;
        self.description = description;
        self.duration = duration;
        self.tourLocationIDs = tourLocationIDs;
        self.thumbnailParseFile = thumbnailParseFile;
    }
    
    return self;
}

@end
