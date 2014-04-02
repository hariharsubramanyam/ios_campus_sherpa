//
//  CSTourMediaDetailViewController.m
//  CampusSherpa
//
//  Created by Harihar Subramanyam on 4/1/14.
//  Copyright (c) 2014 Campus Sherpa. All rights reserved.
//

#import "CSTourMediaDetailViewController.h"
#import "CSAppDelegate.h"

@interface CSTourMediaDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgMedia;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (strong, nonatomic) CSAppDelegate *appDelegate;
@end

@implementation CSTourMediaDetailViewController

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
    self.appDelegate = (CSAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.title = self.appDelegate.selectedMedia.name;
    self.txtDescription.text = self.appDelegate.selectedMedia.description;
    self.imgMedia.image = [UIImage imageWithData:self.appDelegate.selectedMedia.image];
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