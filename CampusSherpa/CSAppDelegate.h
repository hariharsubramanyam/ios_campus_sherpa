#import <UIKit/UIKit.h>
#import "CSTour.h"
#import "CSTourLocation.h"
#import "CSTourMedia.h"

@interface CSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (strong, nonatomic) CSTour *selectedTour;
@property (strong, nonatomic) CSTourLocation *selectedTourLocation;
@property (strong, nonatomic) NSMutableArray *tours;
@property (strong, nonatomic) CSTourMedia *selectedMedia;
@property (strong, nonatomic) CSTour *createdTour;
@property (strong, nonatomic) CSTourLocation *locationToEdit;

- (void) logMessageToParse:(NSString *)message;

@end
