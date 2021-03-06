#import "CSNewTourSingleLocationController.h"
#import "CSUploadImageController.h"
#import "CSTourMedia.h"
#import "CSAppDelegate.h"
#import <MapKit/MapKit.h>
#import "CSRecordAudioController.h"
#import <CoreLocation/CoreLocation.h>

@interface CSNewTourSingleLocationController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) CSAppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UITextField *latitudeField;
@property (weak, nonatomic) IBOutlet UITextField *longitudeField;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UITableView *mediaTable;
@end

@implementation CSNewTourSingleLocationController

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
    self.mediaTable.dataSource = self;
    self.appDelegate = (CSAppDelegate *)[[UIApplication sharedApplication] delegate];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
        [self.view addGestureRecognizer:tap];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}

-(void)dismissKeyboard {
    [self.latitudeField resignFirstResponder];
    [self.longitudeField resignFirstResponder];
    [self.addressField resignFirstResponder];
    [self.nameField resignFirstResponder];
    [self.txtDescription resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.appDelegate.locationToEdit.media count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MediaPrototype" forIndexPath:indexPath];
    cell.textLabel.text = ((CSTourMedia *)(self.appDelegate.locationToEdit.media[indexPath.item])).name;
    return cell;
}

- (IBAction)unwindFromAddMedia:(UIStoryboardSegue *)segue
{
    if ([[segue sourceViewController] class] == [CSUploadImageController class]) {
        CSUploadImageController *imgCtrl = [segue sourceViewController];
        if (imgCtrl.image != nil) {
            CSTourMedia *createdMedia = [[CSTourMedia alloc] initWithName:imgCtrl.titleStr description:imgCtrl.descStr parseFile:nil];
            createdMedia.mediaData = imgCtrl.image;
            createdMedia.isImage = YES;
            [self.appDelegate.locationToEdit.media addObject:createdMedia];
            [self.mediaTable reloadData];
        }
    }else if([[segue sourceViewController] class] == [CSRecordAudioController class]){
        CSRecordAudioController *sourceController = [segue sourceViewController];
        if (sourceController.audioData != nil) {
            CSTourMedia *createdMedia = [[CSTourMedia alloc] initWithName:sourceController.audioTitle description:sourceController.audioDescription parseFile:nil];
            createdMedia.mediaData = sourceController.audioData;
            createdMedia.isImage = NO;
            [self.appDelegate.locationToEdit.media addObject:createdMedia];
            [self.mediaTable reloadData];
        }
    }
}

- (IBAction)useCurrentLocation:(id)sender {
    [self.appDelegate logMessageToParse:@"Used current location for new location"];
    CLLocation *loc = self.locationManager.location;
    self.latitudeField.text = [NSString stringWithFormat:@"%f", loc.coordinate.latitude];
    self.longitudeField.text = [NSString stringWithFormat:@"%f", loc.coordinate.longitude];
}

- (IBAction)useAddress:(id)sender {
    NSString *logMessage = [NSString stringWithFormat:@"Entered address for new location - %@", self.addressField.text];
    [self.appDelegate logMessageToParse:logMessage];
    CLLocationCoordinate2D coord = [CSNewTourSingleLocationController geoCodeUsingAddress:self.addressField.text];
    self.latitudeField.text = [NSString stringWithFormat:@"%f", coord.latitude];
    self.longitudeField.text = [NSString stringWithFormat:@"%f", coord.longitude];
}

- (IBAction)unwindFromCancelMedia:(UIStoryboardSegue *)segue
{
    // pass
}

+ (CLLocationCoordinate2D) geoCodeUsingAddress:(NSString *)address
{
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    return center;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender == self.doneButton) {
        NSString *logMessage = [NSString stringWithFormat:@"Finished adding location to tour - %@", self.nameField.text];
        [self.appDelegate logMessageToParse:logMessage];
        self.appDelegate.locationToEdit.location =
        [[CLLocation alloc] initWithLatitude:[self.latitudeField.text doubleValue] longitude:[self.longitudeField.text doubleValue]];
        self.appDelegate.locationToEdit.name = self.nameField.text;
        self.appDelegate.locationToEdit.description = self.txtDescription.text;
    } else {
        [self.appDelegate logMessageToParse:@"Cancelled adding location to tour"];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
}

@end
