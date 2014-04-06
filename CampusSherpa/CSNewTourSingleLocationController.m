//
//  CSNewTourSingleLocationControllerViewController.m
//  CampusSherpa
//
//  Created by Tesline Thomas on 4/5/14.
//  Copyright (c) 2014 Campus Sherpa. All rights reserved.
//

#import "CSNewTourSingleLocationController.h"
#import "CSUploadImageController.h"
#import "CSTourMedia.h"
#import "CSAppDelegate.h"
#import <MapKit/MapKit.h>

@interface CSNewTourSingleLocationController ()
@property (strong, nonatomic) CSAppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UITextField *latitudeField;
@property (weak, nonatomic) IBOutlet UITextField *longitudeField;
@property (strong, nonatomic) CLLocationManager *locationManager;
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
    self.appDelegate = (CSAppDelegate *)[[UIApplication sharedApplication] delegate];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindFromAddMedia:(UIStoryboardSegue *)segue
{
    if ([[segue sourceViewController] class] == [CSUploadImageController class]) {
        CSUploadImageController *imgCtrl = [segue sourceViewController];
        if (imgCtrl.image != nil) {
            CSTourMedia *createdMedia = [[CSTourMedia alloc] initWithName:imgCtrl.titleStr description:imgCtrl.descStr imageParseFile:nil];
            createdMedia.image = imgCtrl.image;
            [self.appDelegate.locationToEdit.media addObject:createdMedia];
        }
    }
}

- (IBAction)useCurrentLocation:(id)sender {
    CLLocation *loc = self.locationManager.location;
    self.latitudeField.text = [NSString stringWithFormat:@"%f", loc.coordinate.latitude];
    self.longitudeField.text = [NSString stringWithFormat:@"%f", loc.coordinate.longitude];
}

- (IBAction)doneClicked:(id)sender {
    
}


- (IBAction)unwindFromCancelMedia:(UIStoryboardSegue *)segue
{
    // pass
}

- (CLLocationCoordinate2D) geoCodeUsingAddress:(NSString *)address
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
