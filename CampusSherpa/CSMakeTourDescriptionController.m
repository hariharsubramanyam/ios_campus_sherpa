//
//  CSMakeTourDescriptionController.m
//  CampusSherpa
//
//  Created by Harihar Subramanyam on 5/3/14.
//  Copyright (c) 2014 Campus Sherpa. All rights reserved.
//

#import "CSMakeTourDescriptionController.h"
#import "CSAppDelegate.h"

@interface CSMakeTourDescriptionController ()
@property (weak, nonatomic) IBOutlet UITextField *txtTourDescription;
@property (strong, nonatomic) CSAppDelegate *appDelegate;
@property (nonatomic) BOOL hasDescription;
@end

@implementation CSMakeTourDescriptionController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)onNextClick:(id)sender {
    if ([self.txtTourDescription.text length] > 0) {
        self.hasDescription = YES;
        self.appDelegate.createdTour.description = self.txtTourDescription.text;
    }else{
        self.hasDescription = NO;
        [[[UIAlertView alloc] initWithTitle:@"Needs a description!" message:@"Your tour needs a description!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = ((CSAppDelegate *)[[UIApplication sharedApplication] delegate]);
    self.hasDescription = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    return self.hasDescription;
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
