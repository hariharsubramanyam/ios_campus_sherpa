//
//  CSMakeTourNameController.m
//  CampusSherpa
//
//  Created by Harihar Subramanyam on 5/3/14.
//  Copyright (c) 2014 Campus Sherpa. All rights reserved.
//

#import "CSMakeTourNameController.h"
#import "CSAppDelegate.h"

@interface CSMakeTourNameController ()
@property (weak, nonatomic) IBOutlet UITextField *txtTourName;
@property (strong, nonatomic) CSAppDelegate *appDelegate;
@property (nonatomic) BOOL hasName;
@end

@implementation CSMakeTourNameController
- (IBAction)onCancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onNextClick:(id)sender {
    if ([self.txtTourName.text length] > 0) {
        self.hasName = YES;
        self.appDelegate.createdTour.name = self.txtTourName.text;
    }else{
        self.hasName = NO;
        [[[UIAlertView alloc] initWithTitle:@"Tour needs a name!" message:@"Please enter a name for your tour" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
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
    self.appDelegate = ((CSAppDelegate *)[[UIApplication sharedApplication] delegate]);
    self.hasName = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    return self.hasName;
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
