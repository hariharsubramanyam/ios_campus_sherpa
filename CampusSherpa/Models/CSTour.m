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

- (instancetype) init {
    self = [super init];
    self.tourLocations = [[NSMutableArray alloc] init];
    return self;
}

- (NSString *) saveToParse {
    self.tourLocationIDs = [[NSMutableArray alloc] init];
    for (CSTourLocation *loc in self.tourLocations) {
        [self.tourLocationIDs addObject:[loc saveToParse]];
    }
    PFObject *tour = [PFObject objectWithClassName:@"Tour"];
    tour[@"name"] = self.name;
    tour[@"description"] = self.description;
    tour[@"expectedDuration"] = [[NSNumber alloc] initWithDouble:self.duration];
    tour[@"tourLocationIDs"] = self.tourLocationIDs;
    [tour save];
    return [tour objectId];
}

@end
