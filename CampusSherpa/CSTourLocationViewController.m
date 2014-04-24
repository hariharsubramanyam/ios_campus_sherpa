#import "CSTourLocationViewController.h"
#import "CSAppDelegate.h"
#import "CSTourMedia.h"

@interface CSTourLocationViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnPreviousLocation; // Previous location button
@property (weak, nonatomic) IBOutlet UIButton *btnNextLocation;     // Next location button
@property (weak, nonatomic) IBOutlet UIButton *btnSeeMedia;         // See media button

@property (weak, nonatomic) IBOutlet UITextView *txtDescription;    // Description of location
@property (weak, nonatomic) IBOutlet UIImageView *imgLocation;      // Picture of location
@property (weak, nonatomic) IBOutlet UILabel *lblLocationName;      // Name of location

@property (strong, nonatomic) CSAppDelegate *appDelegate;           // App delegate
@end

@implementation CSTourLocationViewController

- (IBAction)onShowMapClick:(id)sender {
    
}


/* Previous location button click */
- (IBAction)onPreviousLocationClick:(id)sender {
    [self loadPreviousLocation];
}

- (void) loadPreviousLocation{
    // Iterate through all the locations
    for (int i = 0; i < [self.appDelegate.selectedTour.tourLocations count]; i++) {
        
        // Find the current location
        if(self.appDelegate.selectedTour.tourLocations[i] == self.appDelegate.selectedTourLocation){
            
            // Handle array out of bounds
            if(i - 1 < 0){
                self.appDelegate.selectedTourLocation = [self.appDelegate.selectedTour.tourLocations lastObject];
            }else{
                self.appDelegate.selectedTourLocation = self.appDelegate.selectedTour.tourLocations[i-1];
            }
            
            // Log message
            NSString *logMessage = [NSString stringWithFormat:@"Going to previous location - %@", self.appDelegate.selectedTourLocation.name];
            [self.appDelegate logMessageToParse:logMessage];
            
            // Update the UI and query for the locations
            [self updateUI];
            [self makeQuery];
            
            // When we've updated the UI, quit the loop
            return;
        }
    }
}

- (void) loadNextLocation{
    // Iterate through all the locations
    for (int i = 0; i < [self.appDelegate.selectedTour.tourLocations count]; i++) {
        
        // Find the current location
        if(self.appDelegate.selectedTour.tourLocations[i] == self.appDelegate.selectedTourLocation){
            
            // Handle array out of bounds
            if(i + 1 >= [self.appDelegate.selectedTour.tourLocations count]){
                self.appDelegate.selectedTourLocation = [self.appDelegate.selectedTour.tourLocations firstObject];
            }else{
                self.appDelegate.selectedTourLocation = self.appDelegate.selectedTour.tourLocations[i+1];
            }
            
            // Log message
            NSString *logMessage = [NSString stringWithFormat:@"Going to next location - %@", self.appDelegate.selectedTourLocation.name];
            [self.appDelegate logMessageToParse:logMessage];
            
            // Update the UI and query for the locations
            [self updateUI];
            [self makeQuery];
            
            // When we've updated the UI, quit the loop
            return;
        }
    }
}

/* Next location button click */
- (IBAction)onNextLocationClick:(id)sender {
    [self loadNextLocation];
}


/* Init with nib */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}

/* View load */
- (void)viewDidLoad
{
    self.appDelegate = ((CSAppDelegate *)[[UIApplication sharedApplication]delegate]);

    [super viewDidLoad];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]
                                   initWithTarget:self
                                       action:@selector(swiped:)];
    [swipe setDirection:(UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:swipe];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    // Do any additional setup after loading the view.
    [self updateUI];
    [self makeQuery];
    
}

- (void)swiped:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self loadNextLocation];
    }else{
        [self loadPreviousLocation];
    }
}

/* Retrieve the Tour media */
- (void) makeQuery{
    
    // Query Parse for TourMedia for the current tour location
    PFQuery *query = [PFQuery queryWithClassName:@"TourMedia"];
    [query whereKey:@"objectId" containedIn:self.appDelegate.selectedTourLocation.mediaIDs];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.appDelegate.selectedTourLocation.media = [[NSMutableArray alloc] init];
                self.appDelegate.selectedTourLocation.mediaIDs = [[NSMutableArray alloc] init];
                
                // For each TourMedia object
                for (PFObject *object in objects) {
                    
                    // Add the ID to the list
                    [self.appDelegate.selectedTourLocation.mediaIDs addObject:object.objectId];
                
                    
                    CSTourMedia *tourMedia;
                    if (object[@"image"] == nil) {
                        tourMedia = [[CSTourMedia alloc] initWithName:object[@"name"]
                                                          description:object[@"description"]
                                                            parseFile:object[@"audio"]];
                        tourMedia.isImage = NO;
                    }else{
                        tourMedia = [[CSTourMedia alloc] initWithName:object[@"name"]
                                                          description:object[@"description"]
                                                            parseFile:object[@"image"]];
                        tourMedia.isImage = YES;
                    }
                    
                    // Add the media to the list
                    [self.appDelegate.selectedTourLocation.media addObject:tourMedia];
                }
            });
        }
    }];

    
}

/* Update UI to reflect location */
- (void) updateUI{
    
    // Set location name and description
    self.txtDescription.text = self.appDelegate.selectedTourLocation.description;
    self.lblLocationName.text = self.appDelegate.selectedTourLocation.name;
    
    // List index of location on the tour
    for (int i = 0; i < [self.appDelegate.selectedTour.tourLocations count]; i++) {
        if (self.appDelegate.selectedTourLocation == self.appDelegate.selectedTour.tourLocations[i]) {
            self.title = [NSString stringWithFormat:@"Location %d of %lu", (i+1), (unsigned long)[self.appDelegate.selectedTour.tourLocations count]];
            break;
        }
    }
    
    // Display image for location
    PFFile *imageFile = self.appDelegate.selectedTourLocation.thumbnailParseFile;
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imgLocation setImage:[UIImage imageWithData:data]];
            });
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
