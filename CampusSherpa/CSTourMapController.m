//
//  CSTourMapController.m
//  CampusSherpa
//
//  Created by Harihar Subramanyam on 4/22/14.
//  Copyright (c) 2014 Campus Sherpa. All rights reserved.
//

#import "CSTourMapController.h"
#import <MapKit/MapKit.h>
#import "CSAppDelegate.h"
#import "CSTourLocation.h"

@interface CSTourMapController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CSAppDelegate *appDelegate;
@end

@implementation CSTourMapController

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
    // Do any additional setup after loading the view.
    self.appDelegate = ((CSAppDelegate *)[[UIApplication sharedApplication] delegate]);
    NSMutableArray *tourLocations = self.appDelegate.selectedTour.tourLocations;
    for (CSTourLocation *tourLocation in tourLocations) {
        CLLocationCoordinate2D mapCenter = {tourLocation.location.coordinate.latitude, tourLocation.location.coordinate.longitude};
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(mapCenter, METERS_PER_MILE, METERS_PER_MILE);
        [self.mapView setRegion:viewRegion];
        
        // Make pin
        MKPointAnnotation *ant = [[MKPointAnnotation alloc] init];

        ant.coordinate = tourLocation.location.coordinate;
        ant.title = tourLocation.name;
        [self.mapView addAnnotation:ant];

    }
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
