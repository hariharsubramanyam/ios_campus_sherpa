#import "CSTourMedia.h"

@implementation CSTourMedia
- (instancetype) initWithName:(NSString *)name description:(NSString *)description parseFile:(PFFile *)imageParseFile{
    self = [super init];
    
    if (self) {
        self.name = name;
        self.description = description;
        self.parseFile = imageParseFile;
    }
    
    return self;
}

- (NSString *) saveToParse {
    PFObject *media = [PFObject objectWithClassName:@"TourMedia"];
    media[@"name"] = self.name;
    media[@"description"] = self.description;
    
    if (self.isImage) {
        PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"Image%d.jpeg", abs(arc4random()), nil] data:self.mediaData];
        self.parseFile = imageFile;
        media[@"image"] = imageFile;
    }else{
        PFFile *audioFile = [PFFile fileWithName:[NSString stringWithFormat:@"Audio%d.m4a", abs(arc4random()), nil] data:self.mediaData];
        self.parseFile = audioFile;
        media[@"audio"] = audioFile;
    }
    
    [media save];
    return [media objectId];
}
@end
