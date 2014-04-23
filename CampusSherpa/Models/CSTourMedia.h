#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface CSTourMedia : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) PFFile *parseFile;
@property (strong, nonatomic) NSData *mediaData;
@property (nonatomic) BOOL isImage;

- (instancetype) initWithName:(NSString *)name description:(NSString *)description parseFile:(PFFile *)imageParseFile;

- (NSString *) saveToParse;
@end
