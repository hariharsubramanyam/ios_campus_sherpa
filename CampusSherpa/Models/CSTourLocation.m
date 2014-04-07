//
//  CSTourLocation.m
//  CampusSherpa
//
//  Created by Harihar Subramanyam on 3/22/14.
//  Copyright (c) 2014 Campus Sherpa. All rights reserved.
//

#import "CSTourLocation.h"
#import "CSTourMedia.h"

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

- (instancetype) init{
    self = [super init];
    self.media = [[NSMutableArray alloc] init];
    return self;
}

- (NSString *) saveToParse {
    self.mediaIDs = [[NSMutableArray alloc] init];
    for (CSTourMedia *media in self.media) {
        [self.mediaIDs addObject:[media saveToParse]];
    }
    PFObject *location = [PFObject objectWithClassName:@"TourLocation"];
    if ([self.media count] > 0) {
        CSTourMedia *media = self.media[0];
        self.thumbnailParseFile = media.imageParseFile;
        location[@"thumbnail"] = self.thumbnailParseFile;
    }
    location[@"name"] = self.name;
    location[@"description"] = self.description;
    PFGeoPoint *loc = [PFGeoPoint geoPointWithLocation:self.location];
    location[@"location"] = loc;
    location[@"media"] = self.mediaIDs;
    NSLog(@"%d", [self.mediaIDs count]);
    [location save];
    return [location objectId];
}
@end
