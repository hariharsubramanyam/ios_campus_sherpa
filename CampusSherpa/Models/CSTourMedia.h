//
//  CSTourMedia.h
//  CampusSherpa
//
//  Created by Harihar Subramanyam on 3/22/14.
//  Copyright (c) 2014 Campus Sherpa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface CSTourMedia : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) PFFile *imageParseFile;
@property (strong, nonatomic) NSData *image;

- (instancetype) initWithName:(NSString *)name description:(NSString *)description imageParseFile:(PFFile *)imageParseFile;

- (NSString *) saveToParse;
@end
