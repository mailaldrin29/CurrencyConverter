//
//  ViewController.h
//  CurrencyConverter
//
//  Created by Aldrin Thivyanathan on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyTableViewController.h"

@interface ViewController : UIViewController<CurrencyTableViewControllerDelegate,UISearchBarDelegate>{
    
    UIButton *currencyBtnOne;
    UIButton *currencyBtnTwo;
    UISearchBar *currencyFieldOne;
    UISearchBar *currencyFieldTwo;
    NSArray *keys;
    NSArray *values;
    NSDictionary *forExRates;
    NSDictionary *currencies;
    UITabBarController *tabBarController;
    UINavigationController *navController;
    BOOL isBtnOneClicked;
    BOOL isBtnTwoCLicked;
    float baseCurrencyValue;
    float rateOne;
    float rateTwo;
    NSArray *alphbetsArray;
    NSMutableDictionary *sectionValues;
    NSMutableArray *sections;
    NSMutableArray *tempArray;
}

@end
