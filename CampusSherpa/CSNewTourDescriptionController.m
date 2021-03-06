#import "CSNewTourDescriptionController.h"
#import "CSAppDelegate.h"

@interface CSNewTourDescriptionController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) CSAppDelegate *appDelegate;
@end

@implementation CSNewTourDescriptionController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = (CSAppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender == self.doneButton) {
        NSString *logMessage = [NSString stringWithFormat:@"Created tour - %@", self.appDelegate.createdTour.name];
        [self.appDelegate logMessageToParse:logMessage];
    } else if (sender == self.cancelButton) {
        self.appDelegate.createdTour = nil;
        [self.appDelegate logMessageToParse:@"Cancelled create tour"];
    }
}

- (IBAction)unwindFromNewTourLocations:(UIStoryboardSegue *)segue
{
    // pass
}

@end
