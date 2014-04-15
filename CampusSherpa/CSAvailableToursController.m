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
#import "CSTour.h"

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
            self.appDelegate.tours = [[NSMutableArray alloc] init];
            for (PFObject *pfobject in objects) {
                CSTour *tour = [[CSTour alloc] initWithID:pfobject.objectId name:pfobject[@"name"] description:pfobject[@"description"] duration:[((NSNumber *)pfobject[@"duration"]) doubleValue] tourLocationIDs:pfobject[@"tourLocationIDs"] thumbnailParseFile:pfobject[@"thumbnail"]];
                [self.appDelegate.tours addObject:tour];
            }
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
    CSTour *tour = self.appDelegate.tours[indexPath.item];
    cell.textLabel.text = tour.name;
    cell.detailTextLabel.text = tour.description;
    if (!cell.imageView.image) {
        PFFile *imageFile = tour.thumbnailParseFile;
        if (imageFile != nil) {
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIImage *thumbnail = [[UIImage alloc] initWithData:data];
                        CGSize itemSize = CGSizeMake(60, 40);
                        UIGraphicsBeginImageContext(itemSize);
                        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                        [thumbnail drawInRect:imageRect];
                        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    });
                }
            }];
        }
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.appDelegate.selectedTour = self.appDelegate.tours[indexPath.row];
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
    if ([[segue identifier] isEqualToString:@"NEW_TOUR"]) {
        [self.appDelegate logMessageToParse:@"Started making a tour"];
        if (self.appDelegate.createdTour == nil) {
            self.appDelegate.createdTour = [[CSTour alloc] init];
        }
    } else {
        NSString *logMessage = [NSString stringWithFormat:@"Started taking a tour %@", self.appDelegate.selectedTour.name];
        [self.appDelegate logMessageToParse:logMessage];
    }
}

- (IBAction)unwindFromNewTour:(UIStoryboardSegue *)segue
{
    CSAppDelegate *appDelegate = self.appDelegate;
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [appDelegate.createdTour saveToParse];
        dispatch_async( dispatch_get_main_queue(), ^{
            [self.appDelegate.tours addObject:self.appDelegate.createdTour];
            self.appDelegate.createdTour = nil;
            [self.tableView reloadData];
        });
    });
}

- (IBAction)unwindFromNewTourCancel:(UIStoryboardSegue *)segue
{
    // pass
}

@end
