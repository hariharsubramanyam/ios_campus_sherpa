//
//  CSStartTourViewController.m
//  CampusSherpa
//
//  Created by Tesline Thomas on 3/26/14.
//  Copyright (c) 2014 Campus Sherpa. All rights reserved.
//

#import "CSStartTourViewController.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "CSAppDelegate.h"
#import "CSTour.h"
#import "CSTourLocation.h"

@interface CSStartTourViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CSAppDelegate *appDelegate;
@end

@implementation CSStartTourViewController

#define METERS_PER_MILE 1609.344

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)onStartTourClick:(id)sender {
    self.appDelegate.selectedTourLocation = self.appDelegate.selectedTour.tourLocations[0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = ((CSAppDelegate *)[[UIApplication sharedApplication] delegate]);
    
    PFQuery *query = [PFQuery queryWithClassName:@"TourLocation"];
    [query whereKey:@"tourID" equalTo:self.appDelegate.selectedTour.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.appDelegate.selectedTour.tourLocations = [[NSMutableArray alloc] init];
                for (PFObject *object in objects) {
                    PFGeoPoint *geopoint = object[@"location"];
                    CLLocation *location = [[CLLocation alloc] initWithLatitude:geopoint.latitude longitude:geopoint.longitude];
                    CSTourLocation *tourLocation = [[CSTourLocation alloc] initWithID:object.objectId name:object[@"name"] description:object[@"description"] location:location mediaIDs:object[@"mediaIDs"] tourID:object[@"tourID"] thumbnailParseFile:object[@"thumbnail"]];
                    [self.appDelegate.selectedTour.tourLocations addObject:tourLocation];
                    CLLocationCoordinate2D mapCenter = {location.coordinate.latitude, location.coordinate.longitude};
                    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(mapCenter, METERS_PER_MILE, METERS_PER_MILE);
                    [self.mapView setRegion:viewRegion];
                    MKPointAnnotation *ant = [[MKPointAnnotation alloc] init];
                    ant.coordinate = location.coordinate;
                    ant.title = tourLocation.name;
                    [self.mapView addAnnotation:ant];
                }
            });
        } else {
            NSLog(@"Error loading tour locations %@ %@", error, [error userInfo]);
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
