//
//  CSTourLocation.m
//  CampusSherpa
//
//  Created by Harihar Subramanyam on 3/22/14.
//  Copyright (c) 2014 Campus Sherpa. All rights reserved.
//

#import "CSTourLocation.h"

@implementation CSTourLocation
- (instancetype) initWithID:(NSString *)objectId name:(NSString *)name description:(NSString *)description location:(CLLocation *)location mediaIDs:(NSMutableArray *)mediaIDs tourID:(NSString *)tourID thumbnailParseFile:(PFFile *)thumbnailParseFile{
    self = [super init];
    
    if (self) {
        self.objectId = objectId;
        self.name = name;
        self.description = description;
        self.location = location;
        self.mediaIDs = mediaIDs;
        self.tourID = tourID;
        self.thumbnailParseFile = thumbnailParseFile;
    }
    
    return self;
}
@end
