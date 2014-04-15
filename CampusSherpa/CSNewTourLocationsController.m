//
//  CSNewTourLocationsController.m
//  CampusSherpa
//
//  Created by Tesline Thomas on 4/4/14.
//  Copyright (c) 2014 Campus Sherpa. All rights reserved.
//

#import "CSNewTourLocationsController.h"
#import "CSAppDelegate.h"

@interface CSNewTourLocationsController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addLocationButton;
@property (strong, nonatomic) CSAppDelegate *appDelegate;
@end

@implementation CSNewTourLocationsController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = (CSAppDelegate *)[[UIApplication sharedApplication] delegate];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.appDelegate.createdTour.tourLocations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewTourLocationPrototype" forIndexPath:indexPath];
    CSTourLocation *location = self.appDelegate.createdTour.tourLocations[indexPath.item];
    cell.textLabel.text = location.name;
    cell.detailTextLabel.text = location.description;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.appDelegate.locationToEdit = self.appDelegate.createdTour.tourLocations[indexPath.row];
}

- (IBAction)unwindFromNewTourSingleLocation:(UIStoryboardSegue *)segue
{
    [self.appDelegate.createdTour.tourLocations addObject:self.appDelegate.locationToEdit];
    self.appDelegate.locationToEdit = nil;
    [self.tableView reloadData];
}

- (IBAction)unwindFromNewTourSingleLocationCancel:(UIStoryboardSegue *)segue
{
    // pass
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender == self.addLocationButton) {
        self.appDelegate.locationToEdit = [[CSTourLocation alloc] init];
        [self.appDelegate logMessageToParse:@"Adding location to tour"];
    }
}

@end
