#import <UIKit/UIKit.h>
#import "CSTour.h"
#import "CSTourLocation.h"
#import "CSImageMedia.h"

@interface CSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (strong, nonatomic) CSTour *selectedTour;
@property (strong, nonatomic) CSTourLocation *selectedTourLocation;
@property (strong, nonatomic) NSMutableArray *tours;
@property (strong, nonatomic) CSImageMedia *selectedMedia;
@property (strong, nonatomic) CSTour *createdTour;
@property (strong, nonatomic) CSTourLocation *locationToEdit;

@property (strong, nonatomic) UIColor *viewBackgroundColor;

- (void) logMessageToParse:(NSString *)message;

@end
