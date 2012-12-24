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
#import "AddSightViewController.h"


//#import "Pas"

@interface NRMasterViewController () {
    //NSMutableArray *_objects;
    //BirdSightDataController *_list;
}
@end

@implementation NRMasterViewController


/*
 Algorithm
 
    1. <ignore_keyword>를 삭제한다.
    2. parse stirngs with white characters;
    3. For each item
        TRIM
        CHECK <cardKind_keyword> 
        CHECK date & time
        CHECK if price , keep lower
        set ... to productName
 
 SMS Text Sample
 씨티카드(2*7*)         cardKind    : 씨티카드*, 하나SK*, 삼성카드*, 롯데
 강귀남님               //userName    : *님
 12/23                buyDate: 99/99
 17:56                buyTime: 99:99
 일시불                 <ignore_keyword>
 50,150원              price: *원
 누계                  <ignore_keyword>
 2,633,051원           //totalPrice: *원  -> price와 어떻게 구분할 것인가? ... 저장하지 않고, 작은 값만 유효하게...
 미스터피자상갈보라점       productName: 유일한 ELSE

 
 삼성카드승인
 12/24 
 12:17
 3,300원
 일시불
 (주)이비카드경기
 *누적
 3,300원

 하나SK(7*3*)권*길님 
 12/24 
 11:45 
 (주)새서 
 77,480원/410,120원
 */

- (NSString*)deleteIgnoreKeyword: (NSString *) text{
    NSArray *keywords = [NSArray arrayWithObjects:@"일시불/",@"일시불", @"*누적", @"누적", @"누계",nil ];
    
    for (NSString *keyword in keywords) {
        text = [text stringByReplacingOccurrencesOfString:keyword withString:@""];
    }
    return text;
}

- (BOOL)isCardKind: (NSString*) token{
    NSArray *keywords = [NSArray arrayWithObjects:@"씨티카드", @"삼성", @"하나SK",@"롯데", nil ];
    
    for (NSString *keyword in keywords) {
        if ([token hasPrefix:keyword])
            return TRUE;
        //text = [text stringByReplacingOccurrencesOfString:keyword withString:@""];
    }
    return FALSE;
}
- (BOOL)isUserName: (NSString*) token{
    
    return [token hasSuffix:@"님"];
}
- (BOOL)isDate: (NSString*) token{
    // format: 99/99
    token = [token stringByReplacingOccurrencesOfString:@"/" withString:@""];
    return ( ([token length]==4) && ([token intValue]>0));
}
- (BOOL)isTime: (NSString*) token{
    // format: 99:99
    token = [token stringByReplacingOccurrencesOfString:@":" withString:@""];
    return ( ([token length]==4) && ([token intValue]>0));
}

- (BOOL)getPriceFromToken: (NSDecimalNumber **)price token:(NSString*) token{
    if ([token hasSuffix:@"원"]) {
        token = [token stringByReplacingOccurrencesOfString:@"원" withString:@""];
        token = [token stringByReplacingOccurrencesOfString:@"," withString:@""]; // CHECK
        //NSLog(@"  ;; token = %@", token);
        *price = [[NSDecimalNumber  alloc] initWithString:token];
        return TRUE;
        //return [price initWithString:token]>0;
    }
    return 0;
}

- (IBAction)PasteBtn:(id)sender {
    
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    NSString *text = [pasteBoard string];
    
    //1. <ignore_keyword>를 삭제한다.
    text = [self deleteIgnoreKeyword:text];
    
    NSString *buyItem;
    NSDecimalNumber *price = nil;
    NSDecimalNumber *newPrice = nil;

    if (text != nil) {
        
        //2. parse stirngs with white characters;
        NSArray *list = [text componentsSeparatedByCharactersInSet:
                            [NSCharacterSet characterSetWithCharactersInString:@"\n "]];
        for (NSString *aToken in list) {
            NSString *token = [aToken stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([token isEqualToString:@""]){
                continue;
            }
            else {
                //NSLog(@"valid token=[%@]", token);
                if ([self isCardKind:token]){
                    // set
                    NSLog(@"token cardKind=[%@]", token);
                } else if ([self isUserName:token]) {
                    NSLog(@"token userName=[%@]", token);
                } else if ([self isDate:token]) {
                    NSLog(@"token Date=[%@]", token);
                } else if ([self isTime:token]) {
                    NSLog(@"token Time=[%@]", token);
                } else if ( ([self getPriceFromToken:&newPrice token:token]) ) {
                    if (price == nil)
                        price = newPrice;
                    else if ( [price compare:newPrice] == NSOrderedDescending ){
                        price = newPrice;
                    }

                    NSLog(@"token price=[%@] <- %@", price, token);
                }
                else /* it must be product name */ {
                    NSLog(@"token product=[%@]", token);
                    buyItem = token;
                }
            }
        }
        NRBirdSight *item = [[NRBirdSight alloc] initWithName:buyItem price:price date:[NSDate date]];
        [self.dataController addBirdSightWithBirdSight:item];
    }
    else {
        // CHECK
    }
    
    [[self tableView] reloadData];
}

- (IBAction)done:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"ReturnInput"]) {
        
        AddSightViewController *addController = [segue sourceViewController];
        if (addController.birdSight) {
            [self.dataController addBirdSightWithBirdSight:addController.birdSight];
            [[self tableView] reloadData];
        }
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"CancelInput"]) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

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
    static NSNumberFormatter *numFormatter = nil;
    
    if ( formatter == nil){
        formatter = [ [NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    NRBirdSight *birdSight =  [self.dataController itemInListAtIndex:indexPath.row];
    [ [cell textLabel] setText:birdSight.productName];
    //[ [cell detailTextLabel] setText: [formatter stringFromDate:(NSDate*)birdSight.date]];
    
    if (numFormatter == nil) {
        numFormatter = [[NSNumberFormatter alloc] init];
        [numFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    }
    [ [cell detailTextLabel] setText: [numFormatter stringFromNumber: birdSight.price]];
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
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
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
