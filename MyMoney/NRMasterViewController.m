//
//  NRMasterViewController.m
//  MyMoney
//
//  Created by saekil on 12. 12. 23..
//  Copyright (c) 2012년 R&D Center. All rights reserved.
//

#import "NRMasterViewController.h"

#import "NRDetailViewController.h"
#import "BirdSightDataController.h"
#import "NRBirdSight.h"

@interface NRMasterViewController () {
    //NSMutableArray *_objects;
    BirdSightDataController *_list;
}
@end

@implementation NRMasterViewController

- (void)awakeFromNib
{
    /*if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }*/
    [super awakeFromNib];
    self.dataController = [ [BirdSightDataController alloc] init ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem.accessibilityHint = @"Adds a new bird sighting event";

    self.detailViewController = (NRDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
	// Do any additional setup after loading the view, typically from a nib.
    /*self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (NRDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)insertNewObject:(id)sender
{
    //if (!_objects) {
    //    _objects = [[NSMutableArray alloc] init];
    //}
    
    if (!_list) {
        _list = [[BirdSightDataController alloc] init];
    }
    
    //[_objects insertObject:[NSDate date] atIndex:0];
    
    NSDate date;
    NRBirdSight *birdSight = [ [NRBirdSight alloc] initWithName:@"Eagle" location:@"Pangyo" date: date];
    
    [_list addBirdSightWithBirdSight:birdSight];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
*/


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataController countOfList];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = _objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"BirdSightCell";
    static NSDateFormatter *formatter = nil;
    
    if ( formatter == nil){
        formatter = [ [NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    NRBirdSight *birdSight =  [self.dataController itemInListAtIndex:indexPath.row];
    [ [cell textLabel] setText:birdSight.name];
    [ [cell detailTextLabel] setText: [formatter stringFromDate:(NSDate*)birdSight.date]];
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}*/

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



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        //NSDate *object = _objects[indexPath.row];
        //self.detailViewController.detailItem = object;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //[performSegueWithIdentifier:@"ShowSightDetails"];
    //[self.splitViewController performSegueWithIdentifier:@"ShowSightDetails"    sender:self.splitViewController];
    [self performSegueWithIdentifier:@"ShowSightDetails" sender:nil];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowSightDetails"]) {
        NRDetailViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.sight = [self.dataController itemInListAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
}


@end
