//
//  CurrencyTableViewController.h
//  CurrencyConverterDemo
//
//  Created by Aldrin Thivyanathan on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CurrencyTableViewControllerDelegate <NSObject>

-(void)selectedCurrency:(NSString *)pCurrency  forExRate:(float)pRate;

@end

@interface CurrencyTableViewController : UITableViewController{
    
    NSArray *curKeys;
    NSArray *curValue;
    NSDictionary *forExRates;
    NSDictionary *curName;
    NSArray *alphbetsArray;
    id<CurrencyTableViewControllerDelegate>delegate;
    NSArray *sections;
    
    NSMutableDictionary *sectionValues;
}

@property(nonatomic,retain)NSArray *curKeys;
@property(nonatomic,retain)NSArray *curValue;
@property(nonatomic,retain)NSDictionary *curName;
@property(nonatomic,retain)NSDictionary *forExRates;
@property(nonatomic,retain)id<CurrencyTableViewControllerDelegate>delegate;

@end
