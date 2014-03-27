//
//  CSAvailableToursController.m
//  CampusSherpa
//
//  Created by Harihar Subramanyam on 3/26/14.
//  Copyright (c) 2014 Campus Sherpa. All rights reserved.
//

#import "CSAvailableToursController.h"
#import <Parse/Parse.h>
#import "CSAppDelegate.h"
#import "CSStartTourViewController.h"

@interface CSAvailableToursController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

// the app delegate stores global data
@property (strong, nonatomic) CSAppDelegate *appDelegate;
@end

@implementation CSAvailableToursController

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
    /* Make sure our table view resizes correctly */
    self.tableView.autoresizingMask =
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    
    self.appDelegate = (CSAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Tour"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.appDelegate.tours = [[NSMutableArray alloc] initWithArray:objects];
            NSLog(@"Size is %d", [self.appDelegate.tours count]);
            [self.tableView reloadData];
        });
    }];
    
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.appDelegate.tours count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AvailableTourPrototype" forIndexPath:indexPath];
        // Configure the cell...
    PFObject *parseObject = [self.appDelegate.tours objectAtIndex:indexPath.item];
    cell.textLabel.text = [parseObject objectForKeyedSubscript:@"name"];
    cell.detailTextLabel.text = [parseObject objectForKeyedSubscript:@"description"];
    if (!cell.imageView.image) {
        PFFile *imageFile = [parseObject objectForKeyedSubscript:@"thumbnail"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cell.imageView setImage:[[UIImage alloc] initWithData:data]];
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                });
            }
        }];
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PFObject *selectedTour = [self.appDelegate.tours objectAtIndex:indexPath.row];
    self.appDelegate.currentTourID = selectedTour.objectId;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

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
    CSStartTourViewController *c = [segue destinationViewController];
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    NSLog(@"%d", path.item);
    c.selectedTour = [self.tours objectAtIndex:path.item];
    NSLog(@"%@", c.selectedTour);
}

@end
