//
//  CSTourLocationViewController.m
//  CampusSherpa
//
//  Created by Harihar Subramanyam on 3/30/14.
//  Copyright (c) 2014 Campus Sherpa. All rights reserved.
//

#import "CSTourLocationViewController.h"
#import "CSAppDelegate.h"

@interface CSTourLocationViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnPreviousLocation;
@property (weak, nonatomic) IBOutlet UIButton *btnNextLocation;

@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnSeeMedia;
@property (weak, nonatomic) IBOutlet UIImageView *imgLocation;

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
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateUI];
    
}

- (void) updateUI{
    self.appDelegate = ((CSAppDelegate *)[[UIApplication sharedApplication]delegate]);
    self.txtDescription.text = self.appDelegate.selectedTourLocation.description;
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