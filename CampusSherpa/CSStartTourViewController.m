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

@interface CSStartTourViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSArray *tourLocations;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@", self.selectedTour[@"objectId"]);
    PFQuery *query = [PFQuery queryWithClassName:@"TourLocation"];
    [query whereKey:@"tourID" equalTo:self.selectedTour[@"objectId"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.tourLocations = objects;
            dispatch_async(dispatch_get_main_queue(), ^{
                PFObject *first = self.tourLocations[0];
                PFGeoPoint *location = first[@"location"];
                CLLocationCoordinate2D mapCenter = {location.latitude, location.longitude};
                MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(mapCenter, METERS_PER_MILE, METERS_PER_MILE);
                [self.mapView setRegion:viewRegion animated:NO];
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
