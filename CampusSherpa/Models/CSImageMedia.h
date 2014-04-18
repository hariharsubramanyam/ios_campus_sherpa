#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface CSImageMedia : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) PFFile *imageParseFile;
@property (strong, nonatomic) NSData *image;

- (instancetype) initWithName:(NSString *)name description:(NSString *)description imageParseFile:(PFFile *)imageParseFile;

- (NSString *) saveToParse;
@end
