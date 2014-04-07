//
//  CSTourLocationViewController.m
//  CampusSherpa
//
//  Created by Harihar Subramanyam on 3/30/14.
//  Copyright (c) 2014 Campus Sherpa. All rights reserved.
//

#import "CSTourLocationViewController.h"
#import "CSAppDelegate.h"
#import "CSTourMedia.h"

@interface CSTourLocationViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnPreviousLocation;
@property (weak, nonatomic) IBOutlet UIButton *btnNextLocation;

@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnSeeMedia;
@property (weak, nonatomic) IBOutlet UIImageView *imgLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblLocationName;

@property (strong, nonatomic) CSAppDelegate *appDelegate;
@end

@implementation CSTourLocationViewController
- (IBAction)onSeeMediaClick:(id)sender {
}
- (IBAction)onPreviousLocationClick:(id)sender {
    for (int i = 0; i < [self.appDelegate.selectedTour.tourLocations count]; i++) {
        if(self.appDelegate.selectedTour.tourLocations[i] == self.appDelegate.selectedTourLocation){
            if(i - 1 < 0){
                self.appDelegate.selectedTourLocation = [self.appDelegate.selectedTour.tourLocations lastObject];
            }else{
                self.appDelegate.selectedTourLocation = self.appDelegate.selectedTour.tourLocations[i-1];
            }
            [self updateUI];
            [self makeQuery];
            return;
        }
    }
}
- (IBAction)onNextLocationClick:(id)sender {
    for (int i = 0; i < [self.appDelegate.selectedTour.tourLocations count]; i++) {
        if(self.appDelegate.selectedTour.tourLocations[i] == self.appDelegate.selectedTourLocation){
            if(i + 1 >= [self.appDelegate.selectedTour.tourLocations count]){
                self.appDelegate.selectedTourLocation = [self.appDelegate.selectedTour.tourLocations firstObject];
            }else{
                self.appDelegate.selectedTourLocation = self.appDelegate.selectedTour.tourLocations[i+1];
            }
            [self updateUI];
            [self makeQuery];
            return;
        }
    }
}

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
    self.appDelegate = ((CSAppDelegate *)[[UIApplication sharedApplication]delegate]);
    self.view.backgroundColor = self.appDelegate.viewBackgroundColor;

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateUI];
    [self makeQuery];
    
}

- (void) makeQuery{
    PFQuery *query = [PFQuery queryWithClassName:@"TourMedia"];
    
    [query whereKey:@"objectId" containedIn:self.appDelegate.selectedTourLocation.mediaIDs];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.appDelegate.selectedTourLocation.media = [[NSMutableArray alloc] init];
                self.appDelegate.selectedTourLocation.mediaIDs = [[NSMutableArray alloc] init];
                for (PFObject *object in objects) {
                    [self.appDelegate.selectedTourLocation.mediaIDs addObject:object.objectId];
                    CSTourMedia *tourMedia = [[CSTourMedia alloc] initWithName:object[@"name"] description:object[@"description"] imageParseFile:object[@"image"]];
                    [self.appDelegate.selectedTourLocation.media addObject:tourMedia];
                }
            });
        }
    }];

    
}

- (void) updateUI{
    self.txtDescription.text = self.appDelegate.selectedTourLocation.description;
    self.lblLocationName.text = self.appDelegate.selectedTourLocation.name;
    for (int i = 0; i < [self.appDelegate.selectedTour.tourLocations count]; i++) {
        if (self.appDelegate.selectedTourLocation == self.appDelegate.selectedTour.tourLocations[i]) {
            self.title = [NSString stringWithFormat:@"Location %d of %d", (i+1), [self.appDelegate.selectedTour.tourLocations count]];
            break;
        }
    }
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
