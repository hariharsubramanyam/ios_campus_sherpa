//
//  CSNewTourDescriptionController.m
//  CampusSherpa
//
//  Created by Tesline Thomas on 4/4/14.
//  Copyright (c) 2014 Campus Sherpa. All rights reserved.
//

#import "CSNewTourDescriptionController.h"
#import "CSAppDelegate.h"

@interface CSNewTourDescriptionController ()
@property (weak, nonatomic) IBOutlet UITextField *tourName;
@property (weak, nonatomic) IBOutlet UITextView *description;
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
    // Do any additional setup after loading the view.
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
        self.appDelegate.createdTour.name = self.tourName.text;
        self.appDelegate.createdTour.description = self.description.text;
    } else if (sender == self.cancelButton) {
        self.appDelegate.createdTour = nil;
    }
}

- (IBAction)unwindFromNewTourLocations:(UIStoryboardSegue *)segue
{
    
}

@end