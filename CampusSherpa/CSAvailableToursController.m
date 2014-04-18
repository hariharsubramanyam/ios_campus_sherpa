#import "CSAvailableToursController.h"
#import <Parse/Parse.h>
#import "CSAppDelegate.h"
#import "CSStartTourViewController.h"
#import "CSTour.h"

@interface CSAvailableToursController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;  // Lists all the tours
@property (strong, nonatomic) CSAppDelegate *appDelegate;   // Holds global data
@end

@implementation CSAvailableToursController


/* View loaded */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Resize table
    self.tableView.autoresizingMask =
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    
    
    // Get app delegate
    self.appDelegate = (CSAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    // Make parse query
    PFQuery *query = [PFQuery queryWithClassName:@"Tour"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // Recreate global list of tours
            self.appDelegate.tours = [[NSMutableArray alloc] init];
            
            // Iterate through each Parse tour, make a CSTour, and add it to the global list of tours
            for (PFObject *pfobject in objects) {
                CSTour *tour = [[CSTour alloc] initWithID:pfobject.objectId
                                                     name:pfobject[@"name"]
                                              description:pfobject[@"description"]
                                                 duration:[((NSNumber *)pfobject[@"duration"]) doubleValue]
                                          tourLocationIDs:pfobject[@"tourLocationIDs"]
                                       thumbnailParseFile:pfobject[@"thumbnail"]];
            
                [self.appDelegate.tours addObject:tour];
            }
            
            // Update the table view with the data
            [self.tableView reloadData];
        });
    }];

}



/* Item in table view cell */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Dequeue cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AvailableTourPrototype" forIndexPath:indexPath];
    
    // Get tour and set text labels
    CSTour *tour = self.appDelegate.tours[indexPath.item];
    cell.textLabel.text = tour.name;
    cell.detailTextLabel.text = tour.description;
    
    // Set image view if there is none
    if (!cell.imageView.image) {
        
        // Asynchronously convert parse image to NSData
        PFFile *imageFile = tour.thumbnailParseFile;
        if (imageFile != nil) {
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        // Force image to 60x40 and put in image view
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

/* Before segue */
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

/* Unwind from new tour */
- (IBAction)unwindFromNewTour:(UIStoryboardSegue *)segue
{
    // Local variable to avoid confusion with "self"
    CSAppDelegate *appDelegate = self.appDelegate;
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        // Save new tour to parse
        [appDelegate.createdTour saveToParse];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            
            // Add to list of global tours
            [self.appDelegate.tours addObject:self.appDelegate.createdTour];
            
            // No created tour
            self.appDelegate.createdTour = nil;
            
            // Update table
            [self.tableView reloadData];
        });
    });
}


/* # items in table section */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.appDelegate.tours count];
}

/* Table style */
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {}
    return self;
}

/* Memory warning */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* Table view editable? */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

/* # sections in table view */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

/* Selected item in table view */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.appDelegate.selectedTour = self.appDelegate.tours[indexPath.row];
}


/* Unwind from cancel */
- (IBAction)unwindFromNewTourCancel:(UIStoryboardSegue *)segue
{
    // pass
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

@end
