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

- (NSString *) saveToParse {
    PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"Image%d.jpeg", abs(arc4random()), nil] data:self.image];
    self.imageParseFile = imageFile;
    PFObject *media = [PFObject objectWithClassName:@"TourMedia"];
    media[@"name"] = self.name;
    media[@"description"] = self.description;
    media[@"image"] = imageFile;
    [media save];
    return [media objectId];
}
@end
