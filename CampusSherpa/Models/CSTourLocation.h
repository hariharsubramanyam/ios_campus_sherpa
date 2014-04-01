//
//  CSTourLocation.h
//  CampusSherpa
//
//  Created by Harihar Subramanyam on 3/22/14.
//  Copyright (c) 2014 Campus Sherpa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@interface CSTourLocation : NSObject
@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSMutableArray *mediaIDs;
@property (strong, nonatomic) NSMutableArray *media;
@property (strong, nonatomic) NSString *tourID;
@property (strong, nonatomic) PFFile *thumbnailParseFile;
@property (strong, nonatomic) NSData *thumbnail;

- (instancetype) initWithID:(NSString *)objectId name:(NSString *)name description:(NSString *)description location:(CLLocation *)location mediaIDs:(NSMutableArray *)mediaIDs tourID:(NSString *)tourID thumbnailParseFile:(PFFile *)thumbnailParseFile;
@end
