//
//  NRDetailViewController.m
//  MyMoney
//
//  Created by saekil on 12. 12. 23..
//  Copyright (c) 2012년 R&D Center. All rights reserved.
//

#import "NRDetailViewController.h"
#import "Item.h"

@interface NRDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation NRDetailViewController

#pragma mark - Managing the detail item

/*
- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}*/

- (void)setItem:(Item *)item{
    if (_item != item){
        _item = item;
        
        // Update the view
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    /*if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }*/
    Item *item = self.item;
    
    static NSDateFormatter *formatter = nil;
    static NSNumberFormatter *numFormatter = nil;
    
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        //[formatter setDateStyle:NSDateFormatterLongStyle];
        [formatter setDateFormat:@"YYYY.MM.dd HH:mm"];
    }
    
    if (numFormatter == nil) {
        numFormatter = [[NSNumberFormatter alloc] init];
        [numFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    }

    if (item){
        self.userLabel.text = item.userName;
        self.kindLabel.text = item.cardKind;
        self.birdNameLabel.text = item.productName;
        self.locationLabel.text = [numFormatter stringFromNumber: item.price];
        self.dateLabel.text = [formatter stringFromDate:(NSDate*)item.date];
        self.sumLabel.text = [numFormatter stringFromNumber: item.sumOfPrice];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
