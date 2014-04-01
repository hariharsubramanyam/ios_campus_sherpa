//
//  CSTourMedia.m
//  CampusSherpa
//
//  Created by Harihar Subramanyam on 3/22/14.
//  Copyright (c) 2014 Campus Sherpa. All rights reserved.
//

#import "CSTourMedia.h"

@implementation CSTourMedia
- (instancetype) initWithName:(NSString *)name description:(NSString *)description imageParseFile:(PFFile *)imageParseFile{
    
    self = [super init];
    
    if (self) {
        self.name = name;
        self.description = description;
        self.imageParseFile = imageParseFile;
    }
    
    return self;
}
@end
