//
//  NRMasterViewController.m
//  MyMoney
//
//  Created by saekil on 12. 12. 23..
//  Copyright (c) 2012년 R&D Center. All rights reserved.
//

#import "NRMasterViewController.h"

#import "NRDetailViewController.h"
#import "ItemDataController.h"
#import "Item.h"
#import "AddSightViewController.h"
#import "NRAppDelegate.h"


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
    

    NSString *cardKind;
    NSString *userName;
    NSString *productName;
    NSString *dateStr;
    NSString *timeStr;
    NSDecimalNumber *price = nil;
    NSDecimalNumber *newPrice = nil;
    NSDecimalNumber *sumOfPrice = nil;

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
                    NSLog(@"token cardKind=[%@]", token);
                    cardKind = token;
                } else if ([self isUserName:token]) {
                    NSLog(@"token userName=[%@]", token);
                    userName = token;
                } else if ([self isDate:token]) {
                    NSLog(@"token Date=[%@]", token);
                    dateStr = token;
                } else if ([self isTime:token]) {
                    NSLog(@"token Time=[%@]", token);
                    timeStr = token;
                } else if ( ([self getPriceFromToken:&newPrice token:token]) ) {
                    if (price == nil) {
                        price = newPrice;
                        sumOfPrice = newPrice;
                    }
                    else if ( [price compare:newPrice] == NSOrderedDescending ){
                        price = newPrice;
                    }
                    else{
                        sumOfPrice = newPrice;
                    }

                    NSLog(@"token price=[%@] <- %@", price, token);
                }
                else /* it must be product name */ {
                    NSLog(@"token product=[%@]", token);
                    productName = token;
                }
                
            }
        }
                
        Item *item = [[Item alloc] initWithName:cardKind userName:userName productName:productName price:price sumOfPrice:sumOfPrice dateStr:dateStr timeStr:timeStr];
        [self.dataController addItemWithItem:item];
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
        if (addController.item) {
            [self.dataController addItemWithItem:addController.item];
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
    self.dataController = [ [ItemDataController alloc] init ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem.accessibilityHint = @"Adds a new bird sighting event";
    self.detailViewController = (NRDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.dataController.theCollation sectionIndexTitles];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.dataController.theCollation sectionTitles] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [self.dataController.theCollation sectionForSectionIndexTitleAtIndex:index];
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

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataController countOfList];
}
*/

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        //NSDate *object = _objects[indexPath.row];
        //self.detailViewController.detailItem = object;
    }
    [self performSegueWithIdentifier:@"ShowSightDetails" sender:nil];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowSightDetails"]) {
        NRDetailViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.item = [self.dataController itemInListAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
}


/*- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NRAppDelegate *controller = (NRAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (indexPath.row == [self.dataController countOfList]-1) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataController removeObjectFromListAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.dataController.theCollation sectionTitles] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *itemsInSection = [self.dataController.sectionsArray objectAtIndex:section];
    return [itemsInSection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"BirdSightCell";
    static NSNumberFormatter *numFormatter = nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ];
    }
    
	// Get the time zone from the array associated with the section index in the sections array.
	NSArray *itemsInSection = [self.dataController.sectionsArray objectAtIndex:indexPath.section];
	
	// Configure the cell with the time zone's name.
	Item *item = [itemsInSection objectAtIndex:indexPath.row];
    cell.textLabel.text = item.productName;
	
    if (numFormatter == nil) {
        numFormatter = [[NSNumberFormatter alloc] init];
        [numFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    }
    [ [cell detailTextLabel] setText: [numFormatter stringFromNumber: item.price]];
    return cell;
}
/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 static NSString *cellIdentifier = @"BirdSightCell";
 static NSDateFormatter *formatter = nil;
 static NSNumberFormatter *numFormatter = nil;
 
 if ( formatter == nil){
 formatter = [ [NSDateFormatter alloc] init];
 [formatter setDateStyle:NSDateFormatterMediumStyle];
 }
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
 Item *birdSight =  [self.dataController itemInListAtIndex:indexPath.row];
 [ [cell textLabel] setText:birdSight.productName];
 //[ [cell detailTextLabel] setText: [formatter stringFromDate:(NSDate*)birdSight.date]];
 
 if (numFormatter == nil) {
 numFormatter = [[NSNumberFormatter alloc] init];
 [numFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
 }
 [ [cell detailTextLabel] setText: [numFormatter stringFromNumber: birdSight.price]];
 return cell;
 
 }*/

@end
