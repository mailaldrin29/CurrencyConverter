//
//  ViewController.m
//  CurrencyConverter
//
//  Created by Aldrin Thivyanathan on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "FavouriteTableViewController.h"


#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) 
#define kLatestForExRatesURL [NSURL URLWithString: @"http://openexchangerates.org/latest.json"] 
#define kCurrencyCodesURL [NSURL URLWithString: @"http://openexchangerates.org/currencies.json"]


@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    forExRates = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"EUR",@"GBP",@"INR",@"SGD",@"USD", nil]
                                             forKeys:[NSArray arrayWithObjects:@"0.7919",@"0.638",@"55.6196",@"1.2673",@"1.0000", nil]];
    
	// Do any additional setup after loading the view, typically from a nib.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    dispatch_async(kBgQueue, ^{
        NSData *responseData = [NSData dataWithContentsOfURL:kCurrencyCodesURL];
        [self performSelectorOnMainThread:@selector(fetchedCurrencyData:) withObject:responseData waitUntilDone:YES];
    });
    
    dispatch_async(kBgQueue, ^{
        NSData *responseData = [NSData dataWithContentsOfURL:kLatestForExRatesURL];
        [self performSelectorOnMainThread:@selector(fetchedForExData:) withObject:responseData waitUntilDone:YES];
    });
    currencyBtnOne = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [currencyBtnOne setFrame:CGRectMake(50, 50, 100, 30)];
    [currencyBtnOne setTitle:@"EUR" forState:UIControlStateNormal];
    [currencyBtnOne addTarget:self action:@selector(btnOneClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:currencyBtnOne];
    
    UIButton *swap = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [swap setFrame:CGRectMake(160, 50, 100, 30)];
    [swap setTitle:@"Swap" forState:UIControlStateNormal];
    [swap addTarget:self action:@selector(swapClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:swap];
    
    currencyFieldOne = [[UISearchBar alloc]initWithFrame:CGRectMake(50, 90, 150, 30)];
    [currencyFieldOne setBackgroundColor:[UIColor whiteColor]];
    currencyFieldOne.text = @"1.00000";
    currencyFieldOne.keyboardType = UIKeyboardTypeNumberPad;
    currencyFieldOne.delegate = self;
    [self.view addSubview:currencyFieldOne];
    
    currencyBtnTwo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [currencyBtnTwo setFrame:CGRectMake(50, 130, 100, 30)];
    [currencyBtnTwo setTitle:@"USD" forState:UIControlStateNormal];
    [currencyBtnTwo addTarget:self action:@selector(btnTwoClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:currencyBtnTwo];
    
    currencyFieldTwo = [[UISearchBar alloc]initWithFrame:CGRectMake(50, 170, 150, 30)];
    [currencyFieldTwo setBackgroundColor:[UIColor whiteColor]];
    currencyFieldTwo.delegate = self;
    currencyFieldTwo.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:currencyFieldTwo];
}

- (void)fetchedCurrencyData:(NSData *)responseData {
    
    NSError* error;
    currencies = [NSJSONSerialization JSONObjectWithData:responseData //1
                                                 options:kNilOptions 
                                                   error:&error];
    
    keys = [NSArray arrayWithArray:[[currencies allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    
    
    values = [NSArray arrayWithArray:[[currencies allValues]sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    
    //    alphbetsArray = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z" ,nil];
    //    sectionValues = [NSMutableDictionary dictionary];
    //    sections = [NSMutableArray array];
    //    tempArray = [NSMutableArray array];
    
    //    for (NSString *alphabet in alphbetsArray) {
    //        for (NSString *currCodes in keys) {
    //            if ([alphabet isEqualToString:[currCodes substringToIndex:1]]) {
    //                [tempArray addObject:currCodes];
    //            }
    //            [sectionValues setObject:tempArray forKey:alphabet];
    //            [sections addObject:sectionValues];
    //        }
    //    }
    //
    //    NSLog(@"sectionssections %@",sections);
}
- (void)fetchedForExData:(NSData *)responseData {
    
    NSError* error;
    forExRates = [NSJSONSerialization JSONObjectWithData:responseData //1
                                                 options:kNilOptions 
                                                   error:&error];
    NSLog(@"forExRatesforExRates %@",forExRates);
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    rateOne = [[[forExRates objectForKey:@"rates"]objectForKey:@"EUR"]floatValue];
    rateTwo = [[[forExRates objectForKey:@"rates"]objectForKey:@"USD"]floatValue];
    NSString *euro =  [NSString stringWithFormat:@"%@",[[forExRates objectForKey:@"rates"]objectForKey:@"EUR"]];
    NSLog(@"euroeuro %@",euro);
    float result = rateTwo *(1/rateOne);
    [currencyFieldTwo setText:[NSString stringWithFormat:@"%f",result]];
    
    
    
}

-(void)btnOneClicked:(id)sender{
    
    isBtnOneClicked = YES;
    isBtnTwoCLicked = NO;
    
    CurrencyTableViewController *ctvc = [[CurrencyTableViewController alloc]init];
    ctvc.tableView.frame = [[UIScreen mainScreen] applicationFrame];
    ctvc.delegate = self;
    ctvc.curKeys = keys;
    ctvc.curValue = values;
    ctvc.forExRates = forExRates;
    ctvc.curName = currencies;
    
    
    //    FavouriteTableViewController *ftvc = [[FavouriteTableViewController alloc]init];
    //    ftvc.tableView.frame = [[UIScreen mainScreen] applicationFrame];
    //
    //    tabBarController = [[UITabBarController alloc]init];
    //    tabBarController.viewControllers = [NSArray arrayWithObjects:ctvc,ftvc, nil];
    //CurrencyViewController *cvc = [[CurrencyViewController alloc]init];
    [self.navigationController pushViewController:ctvc animated:YES];
    
}
-(void)btnTwoClicked:(id)sender{
    
    isBtnOneClicked = NO;
    isBtnTwoCLicked = YES;
    
    CurrencyTableViewController *ctvc = [[CurrencyTableViewController alloc]init];
    ctvc.tableView.frame = [[UIScreen mainScreen] applicationFrame];
    ctvc.delegate = self;
    ctvc.curKeys = keys;
    ctvc.curValue = values;
    ctvc.forExRates = forExRates;
    ctvc.curName = currencies;
    [self.navigationController pushViewController:ctvc animated:YES];
    
}
-(void)swapClicked:(id)sender{
    
    //    float result1 = rateOne *(1/rateTwo);
    //    [currencyFieldOne setText:[NSString stringWithFormat:@"%f",result1]];
    NSString *tempTitle = currencyBtnOne.titleLabel.text;
    currencyBtnOne.titleLabel.text = currencyBtnTwo.titleLabel.text;
    currencyBtnTwo.titleLabel.text = tempTitle;
    
    rateOne = [[currencyFieldOne text]floatValue];
    rateTwo = [[currencyFieldTwo text]floatValue];
    float tempFloat = rateOne;
    rateOne = rateTwo;
    rateTwo = tempFloat;
    
    float result = rateTwo *(1/rateOne);
    [currencyFieldTwo setText:[NSString stringWithFormat:@"%f",result]];
}
-(void)selectedCurrency:(NSString *)pCurrency forExRate:(float)pRate{
    
    if (isBtnOneClicked) {
        [currencyBtnOne setTitle:pCurrency forState:UIControlStateNormal];
        [currencyFieldOne setText:@"1.00000"];
        rateOne = [[currencyFieldOne text]floatValue] *pRate;
        float result = rateTwo *(1/rateOne);
        [currencyFieldTwo setText:[NSString stringWithFormat:@"%f",result]];
    }
    else if(isBtnTwoCLicked){
        [currencyBtnTwo setTitle:pCurrency forState:UIControlStateNormal];
        rateTwo = pRate;
        float result = rateTwo *(1/rateOne);
        [currencyFieldTwo setText:[NSString stringWithFormat:@"%f",result]];
    }
    
    //[currencyBtnOne
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchBar == currencyFieldOne) {
        rateOne = [[[forExRates objectForKey:@"rates"]objectForKey:currencyBtnOne.titleLabel.text]floatValue];
        rateOne = [searchText floatValue]*rateOne;
        NSLog(@"rateOnerateOne %f",rateOne);
        rateTwo = [[[forExRates objectForKey:@"rates"]objectForKey:currencyBtnTwo.titleLabel.text]floatValue];
        NSLog(@"rateTworateTwo %f",rateTwo);
        float result = rateOne *(1/rateTwo);
        [currencyFieldTwo setText:[NSString stringWithFormat:@"%f",result]];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
