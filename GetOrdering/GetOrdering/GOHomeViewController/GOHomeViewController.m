//
//  GOHomeViewController.m
//  GetOrdering
//
//  Created by Ali Apple on 1/19/18.
//  Copyright © 2018 Ali Apple. All rights reserved.
//

#import "GOHomeViewController.h"
#import "CVCell.h"
#import "TVCell.h"
#import <MapKit/MapKit.h>
#import "LogoPopupView.h"

#import "MenuVC.h"

static float const VIEW_HEIGHT = 60;
static float const CELL_HEIGHT = 135;


@interface GOHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,SWRevealViewControllerDelegate,UIGestureRecognizerDelegate>
{
    NSArray * arrayFBOptionsStatic;
    NSMutableArray * arrayFBOptions;
    NSArray * arraySearchedResults;
    int selectedDistance;
    UIView * coverView;
    NSString * searchString;
    
    BOOL isFilterByNameExpanded;
    BOOL isFilterByDistanceExpanded;
    BOOL isFilterByAddressExpanded;
    BOOL isFilterByCategoryExpanded;
    BOOL isFilterByOptionExpanded;
    NSString * sortBy;
    NSString * sortByStatus;
}

@property(weak,nonatomic) IBOutlet UIView * viewMain;
@property(weak,nonatomic) IBOutlet UIScrollView * viewMainScroll;
@property(weak,nonatomic) IBOutlet UIView * viewScrollContent;

@property(weak,nonatomic) IBOutlet UIView * viewFBName;
@property(weak,nonatomic) IBOutlet UIView * viewFBNameD;
@property(weak,nonatomic) IBOutlet NSLayoutConstraint * constraintViewFBNameHeight;
@property(weak,nonatomic) IBOutlet UIFloatLabelTextField * txtFBName;
@property(weak,nonatomic) IBOutlet UIButton * btnFBName;
-(IBAction)onBtnFBName:(id)sender;

@property(weak,nonatomic) IBOutlet UIView * viewFBDistance;
@property(weak,nonatomic) IBOutlet UIView * viewFBDistanceD;
@property(weak,nonatomic) IBOutlet NSLayoutConstraint * constraintViewFBDistanceHeight;
@property(weak,nonatomic) IBOutlet UIButton * btnFBDistance;
-(IBAction)onBtnFBDistance:(id)sender;

@property(weak,nonatomic) IBOutlet UIView * viewFBAddress;
@property(weak,nonatomic) IBOutlet UIView * viewFBAddressD;
@property(weak,nonatomic) IBOutlet NSLayoutConstraint * constraintViewFBAddressHeight;
@property(weak,nonatomic) IBOutlet UIFloatLabelTextField * txtFBAddress;
@property(weak,nonatomic) IBOutlet UIButton * btnFBAddress;
-(IBAction)onBtnFBAddress:(id)sender;

@property(weak,nonatomic) IBOutlet UIView * viewFBCategory;
@property(weak,nonatomic) IBOutlet UIView * viewFBCategoryD;
@property(weak,nonatomic) IBOutlet NSLayoutConstraint * constraintViewCategoryHeight;
@property(weak,nonatomic) IBOutlet UIFloatLabelTextField * txtFBCategory;
@property(weak,nonatomic) IBOutlet UIButton * btnFBCategory;
-(IBAction)onBtnFBCategory:(id)sender;

@property(weak,nonatomic) IBOutlet UIView * viewFBOption;
@property(weak,nonatomic) IBOutlet UIView * viewFBOptionD;
@property(weak,nonatomic) IBOutlet NSLayoutConstraint * constraintViewOptionHeight;
@property(weak,nonatomic) IBOutlet UIButton * btnFBOption;
-(IBAction)onBtnFBOption:(id)sender;

@property(weak,nonatomic) IBOutlet UIButton * btnSearch;
-(IBAction)onBtnFBSearch:(id)sender;

@property(weak,nonatomic) IBOutlet UIButton * btn10;
@property(weak,nonatomic) IBOutlet UIButton * btn25;
@property(weak,nonatomic) IBOutlet UIButton * btn50;
@property(weak,nonatomic) IBOutlet UIButton * btn50Greater;

@property(weak,nonatomic) IBOutlet UIImageView * ImgView10;
@property(weak,nonatomic) IBOutlet UIImageView * ImgView25;
@property(weak,nonatomic) IBOutlet UIImageView * ImgView50;
@property(weak,nonatomic) IBOutlet UIImageView * ImgView50Greater;

-(IBAction)onChangeFilterDistanceValue:(UIButton *)sender;

@property(weak,nonatomic) IBOutlet UIButton * btnRestaurant;
@property(weak,nonatomic) IBOutlet UIButton * btnOpen;
@property(weak,nonatomic) IBOutlet UIButton * btnTakeAway;
@property(weak,nonatomic) IBOutlet UIButton * btnFastFood;

@property(weak,nonatomic) IBOutlet UIImageView * ImgViewRestaurant;
@property(weak,nonatomic) IBOutlet UIImageView * ImgViewOpen;
@property(weak,nonatomic) IBOutlet UIImageView * ImgViewTakeAway;
@property(weak,nonatomic) IBOutlet UIImageView * ImgViewFastFood;

@property(weak,nonatomic) IBOutlet UICollectionView * collectionViewTypes;

@property(weak,nonatomic) IBOutlet UITableView * tableViewSearch;

-(IBAction)onBtnAddOptionValue:(UIButton *)sender;

@property(weak,nonatomic)IBOutlet UIView * viewSearchActions;
@property(weak,nonatomic)IBOutlet NSLayoutConstraint * viewSearchActionsHeightConstraint;
@property(weak,nonatomic)IBOutlet UIView * viewSaveSearch;
@property(weak,nonatomic)IBOutlet UIView * viewClearSearch;
@property(weak,nonatomic)IBOutlet UIView * viewSortBy;

-(IBAction)onBtnSaveSearch:(id)sender;
-(IBAction)onBtnClearSearch:(id)sender;
-(IBAction)onBtnSortBy:(id)sender;

@property(weak,nonatomic)IBOutlet UIView * viewSearchData;
@property(weak,nonatomic)IBOutlet NSLayoutConstraint * viewSearchDataHeightConstraint;

@property(weak,nonatomic)IBOutlet UIView * viewNoRecord;
@property(weak,nonatomic)IBOutlet NSLayoutConstraint * viewNoRecordHeightConstraint;

@property(weak,nonatomic)IBOutlet UIView * viewTableRecord;
@property(weak,nonatomic)IBOutlet NSLayoutConstraint * viewTableRecordHeightConstraint;

@property(weak,nonatomic) IBOutlet UIView * viewCover;

@end

@implementation GOHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super addMainPagetopview];
    self.lblHeading.text=@"Home";
    
    SWRevealViewController *revealController = [self revealViewController];
    revealController.delegate=self;
   
    UITapGestureRecognizer *tap = [revealController tapGestureRecognizer];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    [self.collectionViewTypes registerNib:[UINib nibWithNibName:@"CVCell" bundle:nil] forCellWithReuseIdentifier:@"CVCell"];
    self.collectionViewTypes.dataSource=self;
    self.collectionViewTypes.delegate=self;
    
    [self.tableViewSearch setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableViewSearch.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    self.tableViewSearch.tableHeaderView=[[UIView alloc]initWithFrame:CGRectZero];
    self.tableViewSearch.backgroundColor=[UIColor clearColor];
    
    arrayFBOptionsStatic = @[@"Coffee shop",@"Casual dining",@"Fine dining",@"Take away",@"Pub and bar",@"Open",@"Live entertainment",@"Kids friendly",@"Play area",@"Outside area / view",@"Cocktail bar",@"Lounge",@"Live sport",@"Gambling / Betting",@"Pet friendly",@"Wi-fi"];
    
    arrayFBOptions = [NSMutableArray arrayWithCapacity:4];
    arraySearchedResults = [[NSMutableArray alloc]init];
    
    sortBy = @"distance";
    
    [self onChangeFilterDistanceValue:self.btn10];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[Webservice sharedInstance]getSubscription:^(BOOL success, NSDictionary *response, NSError *error) {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (!error && response) {
            [self handleSubscription:response];
        }
    }];
}

-(void)handleSubscription:(NSDictionary *)response
{
    NSString * status = response[@"Status"];
    
    if ([status intValue] == 2) {
        self.viewError.hidden = NO;
        [self.view bringSubviewToFront:self.viewError];
        self.lblError.text = response[@"msg"];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    if (self.searchInfoString && self.searchInfoString.length > 0) {
        [self setUpSearchDataInUI:self.searchInfoString];
    }
    
    if (arraySearchedResults.count) {
        [self.tableViewSearch reloadData];
    }
}

- (void)revealController:(SWRevealViewController *)revealController animateToPosition:(FrontViewPosition)position
{
    if (position == FrontViewPositionLeft){
        self.viewCover.hidden = YES;
    }
    else
    {
        self.viewCover.hidden = NO;
    }
}

-(void)setUpSearchDataInUI:(NSString *)searchStr
{
    NSDictionary *appInfoDict = [NSJSONSerialization JSONObjectWithData:[[searchStr stringByRemovingPercentEncoding] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    
    NSLog(@"appInfoDict is %@",appInfoDict);
    
    NSMutableDictionary * searchInfoDict = appInfoDict[@"searchInfoDict"];
    
    arrayFBOptions = [NSMutableArray arrayWithArray:searchInfoDict[@"business_types"]];
    
    NSArray * name = searchInfoDict[@"queries"];
    NSDictionary * distance = searchInfoDict[@"distance"];
 
    if (distance) {
        if ([distance[@"less_than"] intValue] == 10) {
            [self onChangeFilterDistanceValue:self.btn10];
        }
        else if ([distance[@"less_than"] intValue] == 25) {
            [self onChangeFilterDistanceValue:self.btn25];
        }
        else if ([distance[@"less_than"] intValue] == 50) {
            [self onChangeFilterDistanceValue:self.btn50];
        }
        else if ([distance[@"less_than"] intValue] == 99999) {
            [self onChangeFilterDistanceValue:self.btn50Greater];
        }
        else
        {
            [self onChangeFilterDistanceValue:self.btn10];
        }
        
        self.constraintViewFBDistanceHeight.constant = VIEW_HEIGHT * 1.6;
        self.viewFBDistanceD.alpha = 1.0;
        isFilterByDistanceExpanded = YES;
    }
    else
    {
        self.constraintViewFBDistanceHeight.constant = VIEW_HEIGHT;
        self.viewFBDistanceD.alpha = 0.0;
        isFilterByDistanceExpanded = NO;
    }
    
    NSArray * address = searchInfoDict[@"address"];
    NSArray * categories = searchInfoDict[@"categories"];
    NSArray * businessTypes = [NSArray arrayWithArray:arrayFBOptions];
    
    if (name.count) {
        self.txtFBName.text = name[0];
        self.constraintViewFBNameHeight.constant = VIEW_HEIGHT * 1.6;
        self.viewFBNameD.alpha = 1.0;
        isFilterByNameExpanded = YES;
    }
    else
    {
        self.constraintViewFBNameHeight.constant = VIEW_HEIGHT;
        self.viewFBNameD.alpha = 0.0;
        isFilterByNameExpanded = NO;
    }
    
    if (address.count) {
        self.txtFBAddress.text = address[0];
        self.constraintViewFBAddressHeight.constant = VIEW_HEIGHT * 1.6;
        self.viewFBAddressD.alpha = 1.0;
        isFilterByAddressExpanded = YES;
    }
    else
    {
        self.constraintViewFBAddressHeight.constant = VIEW_HEIGHT;
        self.viewFBAddressD.alpha = 0.0;
        isFilterByAddressExpanded = NO;
    }
    
    
    if (categories.count) {
        self.txtFBCategory.text = categories[0];
        self.constraintViewCategoryHeight.constant = VIEW_HEIGHT * 1.6;
        self.viewFBCategoryD.alpha = 1.0;
        isFilterByCategoryExpanded = YES;
    }
    else
    {
        self.constraintViewCategoryHeight.constant = VIEW_HEIGHT;
        self.viewFBCategoryD.alpha = 0.0;
        isFilterByCategoryExpanded = NO;
    }
    
    if (businessTypes.count) {
        self.constraintViewOptionHeight.constant = 380;
         self.viewFBOptionD.alpha = 1.0;
         isFilterByOptionExpanded = YES;
    }
    else
    {
        self.constraintViewOptionHeight.constant = VIEW_HEIGHT;
        self.viewFBOptionD.alpha = 0.0;
        isFilterByOptionExpanded = NO;
    }
    
    [self.collectionViewTypes reloadData];
    
    sortBy = @"distance";
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Please wait...";
    [[Webservice sharedInstance]getRestaurants:name distance:distance address:address categories:categories businessTypes:businessTypes completionHandler:^(BOOL success, NSDictionary *response,NSString * searchStr ,NSError *error) {
        searchString = searchStr;
        
        if (error) {
            [hud hideAnimated:YES];
            NSLog(@"error description is %@",error.localizedDescription);
            return ;
        }
        
        NSLog(@"response is : %@",response);
        NSLog(@"response is : %@",searchString);
        
        if ([response[@"success"] intValue] == 1)
        {
            [hud hideAnimated:YES];
            [self handleData:response];
        }
        else
        {
            [hud hideAnimated:YES];
            NSString * errorMessage = response[@"errmsg"];
            [self showErrorWithMessage:@"Message" message:errorMessage];
            return;
        }
        
    }];
    
}

#pragma mark - Button Actions

-(IBAction)onBtnFBName:(id)sender
{
    CGFloat alpha = 0.0;
    if (self.constraintViewFBNameHeight.constant == VIEW_HEIGHT) {
        self.constraintViewFBNameHeight.constant = VIEW_HEIGHT * 1.6;
        alpha = 1.0;
        
        [UIView animateWithDuration:0.4 animations:^{[self.viewScrollContent layoutIfNeeded];}completion:^(BOOL finished)
         {
             [UIView animateWithDuration:0.4 animations:^{self.viewFBNameD.alpha = alpha;}completion:^(BOOL finished){
                 isFilterByNameExpanded = YES;
             }];
         }];
    }
    else
    {
        
        [UIView animateWithDuration:0.4 animations:^{self.viewFBNameD.alpha = alpha;}completion:^(BOOL finished)
         {
             self.constraintViewFBNameHeight.constant = VIEW_HEIGHT;
             [UIView animateWithDuration:0.4 animations:^{[self.viewScrollContent layoutIfNeeded];}completion:^(BOOL finished){
                 isFilterByNameExpanded = NO;
             }];
         }];
    }
}

-(IBAction)onBtnFBDistance:(id)sender
{
    CGFloat alpha = 0.0;
    if (self.constraintViewFBDistanceHeight.constant == VIEW_HEIGHT) {
        self.constraintViewFBDistanceHeight.constant = VIEW_HEIGHT * 1.6;
        alpha = 1.0;
        
        [UIView animateWithDuration:0.4 animations:^{[self.viewScrollContent layoutIfNeeded];}completion:^(BOOL finished)
         {
             [UIView animateWithDuration:0.4 animations:^{self.viewFBDistanceD.alpha = alpha;}completion:^(BOOL finished){
                 isFilterByDistanceExpanded = YES;
             }];
         }];
    }
    else
    {
        
        [UIView animateWithDuration:0.4 animations:^{self.viewFBDistanceD.alpha = alpha;}completion:^(BOOL finished)
         {
             self.constraintViewFBDistanceHeight.constant = VIEW_HEIGHT;
             [UIView animateWithDuration:0.4 animations:^{[self.viewScrollContent layoutIfNeeded];}completion:^(BOOL finished){
                 isFilterByDistanceExpanded = NO;
             }];
         }];
    }
    
}

-(IBAction)onBtnFBAddress:(id)sender
{
    CGFloat alpha = 0.0;
    if (self.constraintViewFBAddressHeight.constant == VIEW_HEIGHT) {
        self.constraintViewFBAddressHeight.constant = VIEW_HEIGHT * 1.6;
        alpha = 1.0;
        
        [UIView animateWithDuration:0.4 animations:^{[self.viewScrollContent layoutIfNeeded];}completion:^(BOOL finished)
         {
             [UIView animateWithDuration:0.4 animations:^{self.viewFBAddressD.alpha = alpha;}completion:^(BOOL finished){
                 isFilterByAddressExpanded = YES;
             }];
         }];
    }
    else
    {
        
        [UIView animateWithDuration:0.4 animations:^{self.viewFBAddressD.alpha = alpha;}completion:^(BOOL finished)
         {
             self.constraintViewFBAddressHeight.constant = VIEW_HEIGHT;
             [UIView animateWithDuration:0.4 animations:^{[self.viewScrollContent layoutIfNeeded];}completion:^(BOOL finished){
                 isFilterByAddressExpanded = NO;
             }];
         }];
    }
    
}

-(IBAction)onBtnFBCategory:(id)sender
{
    CGFloat alpha = 0.0;
    
    if (self.constraintViewCategoryHeight.constant == VIEW_HEIGHT) {
        self.constraintViewCategoryHeight.constant = VIEW_HEIGHT * 1.6;
        alpha = 1.0;
        
        [UIView animateWithDuration:0.4 animations:^{[self.viewScrollContent layoutIfNeeded];}completion:^(BOOL finished)
         {
             [UIView animateWithDuration:0.4 animations:^{self.viewFBCategoryD.alpha = alpha;}completion:^(BOOL finished){
                 isFilterByCategoryExpanded = YES;
             }];
         }];
    }
    else
    {
        
        [UIView animateWithDuration:0.4 animations:^{self.viewFBCategoryD.alpha = alpha;}completion:^(BOOL finished)
         {
             self.constraintViewCategoryHeight.constant = VIEW_HEIGHT;
             [UIView animateWithDuration:0.4 animations:^{[self.viewScrollContent layoutIfNeeded];}completion:^(BOOL finished){
                 isFilterByCategoryExpanded = NO;
             }];
         }];
    }
    
}

-(IBAction)onBtnFBOption:(id)sender
{
    CGFloat alpha = 0.0;
    
    if (self.constraintViewOptionHeight.constant == VIEW_HEIGHT) {
        self.constraintViewOptionHeight.constant = 380;
        alpha = 1.0;
        
        [UIView animateWithDuration:0.4 animations:^{[self.viewScrollContent layoutIfNeeded];}completion:^(BOOL finished)
         {
             [UIView animateWithDuration:0.4 animations:^{self.viewFBOptionD.alpha = alpha;}completion:^(BOOL finished){
                 isFilterByOptionExpanded = YES;
             }];
         }];
    }
    else
    {
        [UIView animateWithDuration:0.4 animations:^{self.viewFBOptionD.alpha = alpha;}completion:^(BOOL finished)
         {
             self.constraintViewOptionHeight.constant = VIEW_HEIGHT;
             [UIView animateWithDuration:0.4 animations:^{[self.viewScrollContent layoutIfNeeded];}completion:^(BOOL finished){
                 isFilterByOptionExpanded = NO;
             }];
         }];
    }
    
}

-(int)getSearchCount
{
    int count = 0;
    
    if (isFilterByNameExpanded) {
        count = count + 1;
    }
    
    /*
    if (isFilterByDistanceExpanded) {
        count = count + 1;
    }
     */
    
    if (isFilterByAddressExpanded) {
        count = count + 1;
    }
    
    if (isFilterByCategoryExpanded) {
        count = count + 1;
    }
    
    if (isFilterByOptionExpanded) {
        count = count + 1;
    }
    
    return count;
}

-(IBAction)onBtnFBSearch:(id)sender
{
    int searchCount = [self getSearchCount];
    
    if (searchCount < 1 || !isFilterByDistanceExpanded)
    {
         [self showErrorWithMessage:@"Alert!" message:@"Distance and one more search option must be selected"];
         return;
    }

    // setup name
    NSArray * name = @[];
    
    if (isFilterByNameExpanded)
    {
        if (IS_NOT_EMPTY(self.txtFBName.text)) {
            name = @[IS_TEXT(self.txtFBName.text)];
        }
    }
    
    NSDictionary * distance = [self getDistance:selectedDistance];
    
    // setup address
    NSArray * address = @[];
    
    if (isFilterByAddressExpanded) {
        if (IS_NOT_EMPTY(self.txtFBAddress.text)) {
            address = @[IS_TEXT(self.txtFBAddress.text)];
        }
    }

    
    // setup categories
    NSArray * categories = @[];
    
    if (isFilterByCategoryExpanded) {
        if (IS_NOT_EMPTY(self.txtFBCategory.text)) {
            categories = @[IS_TEXT(self.txtFBCategory.text)];
        }
    }
    
    NSArray * businessTypes = @[];

    if (isFilterByOptionExpanded) {
       businessTypes = [NSArray arrayWithArray:arrayFBOptions];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Please wait...";
    [[Webservice sharedInstance]getRestaurants:name distance:distance address:address categories:categories businessTypes:businessTypes completionHandler:^(BOOL success, NSDictionary *response,NSString * searchStr ,NSError *error) {
        searchString = searchStr;
        
        if (error) {
            [hud hideAnimated:YES];
            NSLog(@"error description is %@",error.localizedDescription);
            return ;
        }
        
        NSLog(@"response is : %@",response);
        NSLog(@"response is : %@",searchString);
        
        if ([response[@"success"] intValue] == 1)
        {
            [hud hideAnimated:YES];
            [self handleData:response];
        }
        else
        {
            [hud hideAnimated:YES];
            NSString * errorMessage = response[@"errmsg"];
            [self showErrorWithMessage:@"Message" message:errorMessage];
            return;
        }
        
    }];
    
}

-(CLLocationDistance)getDistance:(CLLocation *)oldLocation newLocation:(CLLocation *)newLocation
{
    CLLocationDistance kilometers = [newLocation distanceFromLocation:oldLocation] / 1000;
    return kilometers;
}

-(NSArray *)prepareArrayForSorting:(NSArray *)arrayRecord
{
    NSMutableArray * returnArray = [[NSMutableArray alloc]init];
    
    for (int a=0; a<[arrayRecord count]; a++)
    {
        NSMutableDictionary * dict = [arrayRecord[a] mutableCopy];
        NSLog(@"dict :%@",dict);
        
        NSString * latitude = dict[@"location"][@"lat"];
        NSString * longitude = dict[@"location"][@"lng"];
        
        latitude = latitude ? latitude : @"-26.416711";
        longitude = longitude ? longitude : @"28.465283";
        
        //Calculate Distance
        CLLocation *OldLocation = [[CLLocation alloc] initWithLatitude:[[NSString stringWithFormat:@"%f", [Location sharedInstace].currentLocation.coordinate.latitude] doubleValue] longitude:[[NSString stringWithFormat:@"%f",[Location sharedInstace].currentLocation.coordinate.longitude] doubleValue]];
        
        CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:[[NSString stringWithFormat:@"%@",latitude] doubleValue]longitude:[[NSString stringWithFormat:@"%@",longitude] doubleValue]];
        
        NSString * distance = [NSString stringWithFormat:@"%.1f km",[self getDistance:OldLocation newLocation:newLocation]];
        NSString * open = [NSString stringWithFormat:@"%@",dict[@"work_info"][@"isOpen"]];
        
        [dict setObject:distance forKey:@"distance"];
        [dict setObject:open forKey:@"status"];
        
        [returnArray addObject:dict];
    }
    
    return [NSArray arrayWithArray:returnArray];
}

-(NSMutableArray * )sortArrayInAscendingOrder:(NSArray * )arrayValues keyName:(NSString *)keyName
{
    if ([keyName isEqualToString:@"distance"])
    {
        NSArray *sortedArray = [arrayValues sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            long data1 = [[obj1 valueForKey:@"distance"] integerValue];
            long data2 = [[obj2 valueForKey:@"distance"] integerValue];
            if (data1 > data2) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            if (data1 < data2) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        return [NSMutableArray arrayWithArray:sortedArray];
    }
    else
    {
        bool isAscending = YES;
        
        if ([keyName isEqualToString:@"status"]) {
            isAscending = NO;
        }
        
        NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:keyName ascending:isAscending];
        NSArray * sortDescriptors = [NSArray arrayWithObject:sort];
        NSArray * sortedArray = [arrayValues sortedArrayUsingDescriptors:sortDescriptors];
        NSLog(@"sortedArray %@",sortedArray);
        
        return [NSMutableArray arrayWithArray:sortedArray];
    }

}

-(void)handleData:(NSDictionary *)response
{
    NSArray * arrayRecord = [self prepareArrayForSorting:[response[@"data"] mutableCopy]];
    
    arraySearchedResults = [self sortArrayInAscendingOrder:arrayRecord keyName:sortBy];
    
    self.viewSearchActionsHeightConstraint.constant = 110;
    self.viewSaveSearch.alpha = 1.0;
    self.viewClearSearch.alpha = 1.0;
    self.viewSortBy.alpha = 1.0;
    
    if (arraySearchedResults.count == 0) {
        
        arraySearchedResults = [[NSArray alloc]init];
        [self.tableViewSearch reloadData];
        
        self.viewSearchDataHeightConstraint.constant = 40;
        self.viewNoRecordHeightConstraint.constant = 40;
        self.viewNoRecord.alpha = 1.0;
        self.viewTableRecord.alpha = 0.0;
        [self.viewScrollContent layoutIfNeeded];
        return;
    }
    
    
    self.viewNoRecordHeightConstraint.constant = 0;
    self.viewSearchDataHeightConstraint.constant = arraySearchedResults.count * CELL_HEIGHT;
    self.viewNoRecord.alpha = 0.0;
    self.viewTableRecord.alpha = 1.0;
    [self.viewScrollContent layoutIfNeeded];
    
    [self.tableViewSearch reloadData];
}

-(NSDictionary *)getDistance:(int)selectedDistanceOpt
{
    NSDictionary * dict = @{};
    
    NSString * latitude =  [NSString stringWithFormat:@"%f",[Location sharedInstace].currentLocation.coordinate.latitude];
    NSString * longitude = [NSString stringWithFormat:@"%f",[Location sharedInstace].currentLocation.coordinate.longitude];
    
    // latitude =  latitude ?: @"-26.416711";
    // longitude = longitude ?: @"28.465283";
    
    //    latitude = @"-26.416711";
    //    longitude = @"28.465283";
    
    if (selectedDistanceOpt == 1) {
        dict = @{ @"more_than" : @"0",
                  @"less_than" : @"10",
                  @"latitude" : latitude,
                  @"longitude" : longitude
                  };
    }
    
    if (selectedDistanceOpt == 2) {
        dict = @{ @"more_than" : @"0",
                  @"less_than" : @"25",
                  @"latitude" : latitude,
                  @"longitude" : longitude
                  };
    }
    
    if (selectedDistanceOpt == 3) {
        dict = @{ @"more_than" : @"0",
                  @"less_than" : @"50",
                  @"latitude" : latitude,
                  @"longitude" : longitude
                  };
    }
    
    if (selectedDistanceOpt == 4) {
        dict = @{ @"more_than" : @"50",
                  @"less_than" : @"99999",
                  @"latitude" : latitude,
                  @"longitude" : longitude
                  };
    }
    
    return dict;
}

-(IBAction)onChangeFilterDistanceValue:(UIButton *)sender
{
    if (sender.tag == 1)
    {
        selectedDistance = 1;
        self.ImgView10.image = [UIImage imageNamed:@"ic_radio_button_checked.png"];
        self.ImgView25.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
        self.ImgView50.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
        self.ImgView50Greater.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
    }
    else if (sender.tag == 2)
    {
        selectedDistance = 2;
        self.ImgView10.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
        self.ImgView25.image = [UIImage imageNamed:@"ic_radio_button_checked.png"];
        self.ImgView50.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
        self.ImgView50Greater.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
    }
    else if (sender.tag == 3)
    {
        selectedDistance = 3;
        self.ImgView10.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
        self.ImgView25.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
        self.ImgView50.image = [UIImage imageNamed:@"ic_radio_button_checked.png"];
        self.ImgView50Greater.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
    }
    if (sender.tag == 4)
    {
        selectedDistance = 4;
        self.ImgView10.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
        self.ImgView25.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
        self.ImgView50.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
        self.ImgView50Greater.image = [UIImage imageNamed:@"ic_radio_button_checked.png"];
    }
}

-(IBAction)onBtnAddOptionValue:(UIButton *)sender
{
    if (sender.tag == 1) {
        
        NSString * restaurant = @"Restaurant";
        
        if ([arrayFBOptions containsObject:restaurant]) {
            [arrayFBOptions removeObjectAtIndex:[arrayFBOptions indexOfObject:restaurant]];
            self.ImgViewRestaurant.image = [UIImage imageNamed:@"ic_check_box_outline_blank.png"];
        }
        else
        {
            [arrayFBOptions addObject:restaurant];
            self.ImgViewRestaurant.image = [UIImage imageNamed:@"ic_check_box.png"];
        }
    }
    
    if (sender.tag == 2) {
        
        NSString * open = @"Open";
        
        if ([arrayFBOptions containsObject:open]) {
            [arrayFBOptions removeObjectAtIndex:[arrayFBOptions indexOfObject:open]];
            self.ImgViewOpen.image = [UIImage imageNamed:@"ic_check_box_outline_blank.png"];
        }
        else
        {
            [arrayFBOptions addObject:open];
            self.ImgViewOpen.image = [UIImage imageNamed:@"ic_check_box.png"];
        }
    }
    
    if (sender.tag == 3) {
        NSString * takeAway = @"TakeAway";
        
        if ([arrayFBOptions containsObject:takeAway]) {
            [arrayFBOptions removeObjectAtIndex:[arrayFBOptions indexOfObject:takeAway]];
            self.ImgViewTakeAway.image = [UIImage imageNamed:@"ic_check_box_outline_blank.png"];
        }
        else
        {
            [arrayFBOptions addObject:takeAway];
            self.ImgViewTakeAway.image = [UIImage imageNamed:@"ic_check_box.png"];
        }
    }
    
    if (sender.tag == 4) {
        NSString * fastFood = @"Fast Food";
        if ([arrayFBOptions containsObject:fastFood]) {
            [arrayFBOptions removeObjectAtIndex:[arrayFBOptions indexOfObject:fastFood]];
            self.ImgViewFastFood.image = [UIImage imageNamed:@"ic_check_box_outline_blank.png"];
        }
        else
        {
            [arrayFBOptions addObject:fastFood];
            self.ImgViewFastFood.image = [UIImage imageNamed:@"ic_check_box.png"];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)showErrorWithMessage:(NSString *)title message:(NSString *)message
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                               }];
    
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Collection view delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [arrayFBOptionsStatic count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"CVCell";
    
    CVCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.lblOption.text = arrayFBOptionsStatic[indexPath.row];
    
    if ([arrayFBOptions containsObject:arrayFBOptionsStatic[indexPath.row]]) {
        cell.ImgViewOption.image = [UIImage imageNamed:@"ic_check_box.png"];
    }
    else
    {
        cell.ImgViewOption.image = [UIImage imageNamed:@"ic_check_box_outline_blank.png"];
    }
    
    cell.btnOption.tag = indexPath.row;
    [cell.btnOption addTarget:self action:@selector(onBtnSelectOption:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    int width = collectionView.frame.size.width - 10;
    return CGSizeMake(width/2,30);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    UIEdgeInsets insets=UIEdgeInsetsMake(0, 0, 0, 0);
    return insets;
}

-(void)onBtnSelectOption:(UIButton *)btnSender
{
    NSString * value = arrayFBOptionsStatic[btnSender.tag];
    
    if ([arrayFBOptions containsObject:value]) {
        [arrayFBOptions removeObjectAtIndex:[arrayFBOptions indexOfObject:value]];
    }
    else
    {
        [arrayFBOptions addObject:value];
    }
    
    [self.collectionViewTypes reloadData];
}

#pragma mark--UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arraySearchedResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *iDentifier = @"TVCell";
    
    TVCell *cell = (TVCell *)[tableView dequeueReusableCellWithIdentifier:iDentifier];
    
    NSArray *nib;
    if (cell == nil) {
        nib = [[NSBundle mainBundle] loadNibNamed:@"TVCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary * dict = arraySearchedResults[indexPath.row];
    
    cell.lblTradingName.text = dict[@"trading_name"];
    cell.lblIsOpen.text = [dict[@"work_info"][@"isOpen"] intValue] == 0 ? @"Close" : @"Open" ;
    
    cell.lblBusinessType.text = [dict[@"business_type"] componentsJoinedByString:@" | "];
    
    cell.lblFoodType.text = dict[@"food_type"];
    cell.lblViewsCount.text = [NSString stringWithFormat:@"%@ views",dict[@"Views"]];
    
//    newStr = dict[@"tag_line"];
    
    cell.btnCall.tag = indexPath.row;
    [cell.btnCall addTarget:self action:@selector(onBtnCall:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnWebsite.tag = indexPath.row;
    [cell.btnWebsite addTarget:self action:@selector(onBtnWebsite:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnLocation.tag = indexPath.row;
    [cell.btnLocation addTarget:self action:@selector(onBtnLocation:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnOptions.tag = indexPath.row;
    [cell.btnOptions addTarget:self action:@selector(onBtnOptions:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnFood.tag = indexPath.row;
    [cell.btnFood addTarget:self action:@selector(onBtnFood:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnOpenClose.tag = indexPath.row;
    [cell.btnOpenClose addTarget:self action:@selector(onBtnOpenClose:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnLocationOnDistance.tag = indexPath.row;
    [cell.btnLocationOnDistance addTarget:self action:@selector(onBtnLocationOnDistance:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnHeading.tag = indexPath.row;
    [cell.btnHeading addTarget:self action:@selector(tabOnHeading:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnImage.tag = indexPath.row;
    [cell.btnImage addTarget:self action:@selector(onBtnImage:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnFavorites.tag = indexPath.row;
    [cell.btnFavorites addTarget:self action:@selector(onBtnFav:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnGoOnMenu.tag = indexPath.row;
    [cell.btnGoOnMenu addTarget:self action:@selector(onBtnGoOnMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.ImgViewProductLogo sd_setImageWithURL: [NSURL URLWithString:[dict objectForKey:@"image_url"]]];
    
    cell.lblDistance.text = [NSString stringWithFormat:@"%@",dict[@"distance"]];
    
    NSString * productId = dict[@"id"];
    
    NSMutableDictionary * favDict = [[[NSUserDefaults standardUserDefaults]objectForKey:@"favorites"]mutableCopy];
    
    if (favDict[productId])
    {
        cell.ImgViewFav.image = [UIImage imageNamed:@"ic_Fav.png"];
    }
    else
    {
        cell.ImgViewFav.image = [UIImage imageNamed:@"ic_unFav.png"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)onBtnFav:(UIButton *)btnSender
{
    NSDictionary * productInfo = [arraySearchedResults[btnSender.tag] mutableCopy];
    
    NSMutableDictionary * dict = [[[NSUserDefaults standardUserDefaults]objectForKey:@"favorites"]mutableCopy];
    
    if (!dict)
    {
        dict = [[NSMutableDictionary alloc]init];
    }
    
    NSString * productId = productInfo[@"id"];
 
    if (dict[productId])
    {
        [dict removeObjectForKey:productId];
    }
    else
    {
        if ([[dict allKeys]count]>10)
        {
            [self showErrorWithMessage:@"Alert!" message:@"You can not add more than 10 favorites"];
            return;
        }
        
        NSString * favStr = [self convertFavDictToStr:productInfo];
        
        NSString * dateStr = [self getDateString];
        NSMutableDictionary * dictNew = [[NSMutableDictionary alloc]init];
        [dictNew setObject:dateStr forKey:@"dateInfo"];
        [dictNew setObject:favStr forKey:@"favData"];
        dict[productId] = dictNew;
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:dict forKey:@"favorites"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableViewSearch reloadData];
}

- (NSString *)convertFavDictToStr:(NSDictionary *)favoritesDict  {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:favoritesDict options:0 error:NULL];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return [jsonString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

-(void)onBtnCall:(UIButton *)sender
{
    NSMutableDictionary *dic=[arraySearchedResults objectAtIndex:sender.tag];
    
    NSString *phNo=dic[@"contact_info"][@"phone"];
    
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        //show error message
    }
    
}

-(void)onBtnImage:(UIButton *)sender
{
    [self addCustomView:(int)sender.tag];
}

-(IBAction)onBtnClose:(id)sender
{
    [coverView removeFromSuperview];
}

-(void)onBtnWebsite:(UIButton *)btnSender
{
    NSMutableDictionary *dic=[arraySearchedResults objectAtIndex:btnSender.tag];
    NSString *strURL=[NSString stringWithFormat:@"http://%@",dic[@"contact_info"][@"website"]];
    NSURL *url = [NSURL URLWithString:strURL];
    [[UIApplication sharedApplication] openURL:url];
}

-(void)onBtnLocation:(UIButton *)btnSender
{
    [self addLocatoinPopup:(int)btnSender.tag];
}

-(void)showOnMap:(UIButton *)btnSender
{
    [coverView removeFromSuperview];
    NSMutableDictionary *dic=[arraySearchedResults objectAtIndex:btnSender.tag];
    
    NSString *strLat=dic[@"location"][@"lat"];
    NSString *strLong=dic[@"location"][@"lng"];
    
    CLLocationCoordinate2D endingCoord = CLLocationCoordinate2DMake([strLat doubleValue], [strLong doubleValue]);
    MKPlacemark *endLocation = [[MKPlacemark alloc] initWithCoordinate:endingCoord addressDictionary:nil];
    MKMapItem *endingItem = [[MKMapItem alloc] initWithPlacemark:endLocation];
    
    NSMutableDictionary *launchOptions = [[NSMutableDictionary alloc] init];
    [launchOptions setObject:MKLaunchOptionsDirectionsModeDriving forKey:MKLaunchOptionsDirectionsModeKey];
    
    [endingItem openInMapsWithLaunchOptions:launchOptions];
}

-(void)onBtnOptions:(UIButton *)btnSender
{
    coverView=[[UIView alloc]initWithFrame:self.view.frame];
    coverView.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"LogoPopupView" owner:self options:nil];
    UIView *customPopUp=[subviewArray objectAtIndex:2];
    
    customPopUp.center=CGPointMake(coverView.center.x, coverView.center.y);
    
    NSMutableDictionary *dic=[arraySearchedResults objectAtIndex:btnSender.tag];
    
    UIView *popupView=(UIImageView *)[customPopUp viewWithTag:100];
    popupView.layer.cornerRadius=5.0;
    
    UILabel *lblHeading=(UILabel *)[customPopUp viewWithTag:106];
    lblHeading.text=@"Options";
    
    UITextView *txtOptions=(UITextView *)[customPopUp viewWithTag:105];
    txtOptions.text=[dic[@"business_type"] componentsJoinedByString:@"\n\n"];
    
    UIButton *btnClose=(UIButton *)[customPopUp viewWithTag:102];
    [btnClose addTarget:self action:@selector(onBtnClose:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [coverView addSubview:customPopUp];
    [self.view addSubview:coverView];
}

-(void)onBtnFood:(UIButton *)btnSender
{
    coverView=[[UIView alloc]initWithFrame:self.view.frame];
    coverView.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"LogoPopupView" owner:self options:nil];
    UIView *customPopUp=[subviewArray objectAtIndex:2];
    
    customPopUp.center=CGPointMake(coverView.center.x, coverView.center.y);
    
    NSMutableDictionary *dic=[arraySearchedResults objectAtIndex:btnSender.tag];
    
    UIView *popupView=(UIImageView *)[customPopUp viewWithTag:100];
    popupView.layer.cornerRadius=5.0;
    
    UILabel *lblHeading=(UILabel *)[customPopUp viewWithTag:106];
    lblHeading.text=@"Cuisine";
    
    UITextView *txtOptions=(UITextView *)[customPopUp viewWithTag:105];
    txtOptions.text=dic[@"food_type"];
    
    UIButton *btnClose=(UIButton *)[customPopUp viewWithTag:102];
    [btnClose addTarget:self action:@selector(onBtnClose:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [coverView addSubview:customPopUp];
    [self.view addSubview:coverView];
}

-(void)onBtnOpenClose:(UIButton *)btnSender
{
    coverView=[[UIView alloc]initWithFrame:self.view.frame];
    coverView.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"LogoPopupView" owner:self options:nil];
    UIView *customPopUp=[subviewArray objectAtIndex:3];
    
    customPopUp.center=CGPointMake(coverView.center.x, coverView.center.y);
    
    NSMutableDictionary *dic=[arraySearchedResults objectAtIndex:btnSender.tag];
    
    UIView *popupView=(UIImageView *)[customPopUp viewWithTag:100];
    popupView.layer.cornerRadius=5.0;
    
    UITextView *txtOptions=(UITextView *)[customPopUp viewWithTag:105];
    txtOptions.text=[NSString stringWithFormat:@"Monday: %@ \n\nTuesday: %@ \n\nWednesday: %@ \n\nThursday: %@ \n\nFriday: %@ \n\nSaturday: %@ \n\nSunday: %@",dic[@"work_info"][@"working_hours"],dic[@"work_info"][@"working_hours"],dic[@"work_info"][@"working_hours"],dic[@"work_info"][@"working_hours"],dic[@"work_info"][@"working_hours"],dic[@"work_info"][@"working_hours"],dic[@"work_info"][@"working_hours"]];
    
    UIButton *btnClose=(UIButton *)[customPopUp viewWithTag:102];
    [btnClose addTarget:self action:@selector(onBtnClose:) forControlEvents:UIControlEventTouchUpInside];
    
    [coverView addSubview:customPopUp];
    [self.view addSubview:coverView];
}

-(void)onBtnLocationOnDistance:(UIButton *)btnSender
{
    NSMutableDictionary *dic=[arraySearchedResults objectAtIndex:btnSender.tag];
    
    NSString *strLat=dic[@"location"][@"lat"];
    NSString *strLong=dic[@"location"][@"lng"];
    
    CLLocationCoordinate2D endingCoord = CLLocationCoordinate2DMake([strLat doubleValue], [strLong doubleValue]);
    MKPlacemark *endLocation = [[MKPlacemark alloc] initWithCoordinate:endingCoord addressDictionary:nil];
    MKMapItem *endingItem = [[MKMapItem alloc] initWithPlacemark:endLocation];
    
    NSMutableDictionary *launchOptions = [[NSMutableDictionary alloc] init];
    [launchOptions setObject:MKLaunchOptionsDirectionsModeDriving forKey:MKLaunchOptionsDirectionsModeKey];
    
    [endingItem openInMapsWithLaunchOptions:launchOptions];
}

-(void)tabOnHeading:(UIButton *)btnSender
{
    coverView=[[UIView alloc]initWithFrame:self.view.frame];
    coverView.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"LogoPopupView" owner:self options:nil];
    UIView *customPopUp=[subviewArray objectAtIndex:1];
    
    customPopUp.center=CGPointMake(coverView.center.x, coverView.center.y);
    
    NSMutableDictionary *dic=[arraySearchedResults objectAtIndex:btnSender.tag];
    
    UIView *popupView=(UIImageView *)[customPopUp viewWithTag:100];
    popupView.layer.cornerRadius=5.0;
    
    UILabel *lblHeding=(UILabel *)[customPopUp viewWithTag:108];
    lblHeding.text=@"Resturant Name";
    
    UILabel *lblAddress=(UILabel *)[customPopUp viewWithTag:104];
    lblAddress.text=dic[@"trading_name"];
    
    UIButton *btnShowMenu=(UIButton *)[customPopUp viewWithTag:103];
    btnShowMenu.tag=btnSender.tag;
    [btnShowMenu setTitle:@"Show Menu" forState:UIControlStateNormal];
    [btnShowMenu addTarget:self action:@selector(onBtnShowMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btnClose=(UIButton *)[customPopUp viewWithTag:102];
    [btnClose addTarget:self action:@selector(onBtnClose:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [coverView addSubview:customPopUp];
    [self.view addSubview:coverView];
}

-(void)onBtnShowMenu:(UIButton *)btnSender
{
    [coverView removeFromSuperview];
    MenuVC * menuVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MenuVC class])];
    menuVC.dictData = arraySearchedResults[btnSender.tag];
    [self.navigationController pushViewController:menuVC animated:YES];
}

-(void)onBtnGoOnMenu:(UIButton *)btnSender
{
    NSMutableDictionary *dic=[arraySearchedResults objectAtIndex:btnSender.tag];
    NSString *strURL=[NSString stringWithFormat:@"%@",dic[@"menu_url"]];
    NSURL *url = [NSURL URLWithString:strURL];
    [[UIApplication sharedApplication] openURL:url];
}

//////////////////
-(IBAction)onBtnSaveSearch:(id)sender
{
    
    FavouriteViewController*objFavouriteViewController= (FavouriteViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"FavouriteViewController"];
    [self.navigationController pushViewController:objFavouriteViewController animated:YES];
    
    return;
    if (!searchString) {
        return;
    }
    
    [self showSaveAlert:searchString];
}

-(void)showSaveAlert:(NSString *)searchString
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Save Current Search"
                                                                              message:nil
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"name";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        
        if (namefield.text.length > 0) {
            [self saveSearchInLocalDB:namefield.text searchStr:searchString];
        }
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)saveSearchInLocalDB:(NSString *)title searchStr:(NSString *)searchStr
{
    NSMutableDictionary * dict = [[[NSUserDefaults standardUserDefaults]objectForKey:@"searchInfo"]mutableCopy];
    
    if (!dict)
    {
        dict = [[NSMutableDictionary alloc]init];
    }
    
    if (dict[title])
    {
        [self showErrorWithMessage:@"Error" message:@"Search already save with same name. Please use different name"];
    }
    
    NSString * dateStr = [self getDateString];
    
    NSMutableDictionary * dictNew = [[NSMutableDictionary alloc]init];
    [dictNew setObject:dateStr forKey:@"dateInfo"];
    [dictNew setObject:searchString forKey:@"searchData"];
    
    dict[title] = dictNew;
   
    [[NSUserDefaults standardUserDefaults]setObject:dict forKey:@"searchInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self showErrorWithMessage:@"Search successfully added to history" message:nil];
}

- (NSString *)getDateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
    return stringFromDate;
}

-(IBAction)onBtnClearSearch:(id)sender
{
    self.txtFBName.text = @"";
    self.txtFBAddress.text = @"";
    self.txtFBCategory.text = @"";
    [arrayFBOptions removeAllObjects];
    arraySearchedResults = [[NSMutableArray alloc]init];
    [self onChangeFilterDistanceValue:self.btn10];
    [self.collectionViewTypes reloadData];
    [self.tableViewSearch reloadData];
}

-(IBAction)onBtnSortBy:(id)sender
{
    coverView=[[UIView alloc]initWithFrame:self.view.frame];
    coverView.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"LogoPopupView" owner:self options:nil];
    UIView *customPopUp=[subviewArray objectAtIndex:4];
    customPopUp.tag = 1100;
    customPopUp.center=CGPointMake(coverView.center.x, coverView.center.y);
    
    UIImageView * imgViewSortByDistance = (UIImageView *)[customPopUp viewWithTag:201];
    UIImageView * imgViewSortByName = (UIImageView *)[customPopUp viewWithTag:202];
    UIImageView * imgViewSortByOpenClose = (UIImageView *)[customPopUp viewWithTag:203];
    
    imgViewSortByDistance.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
    imgViewSortByName.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
    imgViewSortByOpenClose.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
    
    if ([sortBy isEqualToString:@"distance"]) {
        imgViewSortByDistance.image = [UIImage imageNamed:@"ic_radio_button_checked.png"];
        
    }
    
    if ([sortBy isEqualToString:@"trading_name"]) {
        imgViewSortByName.image = [UIImage imageNamed:@"ic_radio_button_checked.png"];
    }
    
    if ([sortBy isEqualToString:@"status"]) {
        imgViewSortByOpenClose.image = [UIImage imageNamed:@"ic_radio_button_checked.png"];
    }
    
    sortByStatus = sortBy;
    
    UIButton * btnSortByDistance = (UIButton *)[customPopUp viewWithTag:204];
    [btnSortByDistance addTarget:self action:@selector(onBtnSortByDistance:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * btnSortByName = (UIButton *)[customPopUp viewWithTag:205];
    [btnSortByName addTarget:self action:@selector(onBtnSortByName:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * btnSortByOpenClose = (UIButton *)[customPopUp viewWithTag:206];
    [btnSortByOpenClose addTarget:self action:@selector(onBtnSortByOpenClose:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnDismiss=(UIButton *)[customPopUp viewWithTag:207];
    [btnDismiss addTarget:self action:@selector(onBtnSortByDismiss:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnChoose=(UIButton *)[customPopUp viewWithTag:208];
    [btnChoose addTarget:self action:@selector(onBtnSortByChoose:) forControlEvents:UIControlEventTouchUpInside];
    
    [coverView addSubview:customPopUp];
    [self.view addSubview:coverView];
}

-(void)onBtnSortByDistance:(UIButton *)btnSender
{
    UIView * viewPopUp = (UIView *)[coverView viewWithTag:1100];
    
    UIImageView * imgViewSortByDistance = (UIImageView *)[viewPopUp viewWithTag:201];
    UIImageView * imgViewSortByName = (UIImageView *)[viewPopUp viewWithTag:202];
    UIImageView * imgViewSortByOpenClose = (UIImageView *)[viewPopUp viewWithTag:203];
    
    imgViewSortByDistance.image = [UIImage imageNamed:@"ic_radio_button_checked.png"];
    imgViewSortByName.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
    imgViewSortByOpenClose.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];

    sortByStatus = @"distance";
}

-(void)onBtnSortByName:(UIButton *)btnSender
{
    UIView * viewPopUp = (UIView *)[coverView viewWithTag:1100];
    
    UIImageView * imgViewSortByDistance = (UIImageView *)[viewPopUp viewWithTag:201];
    UIImageView * imgViewSortByName = (UIImageView *)[viewPopUp viewWithTag:202];
    UIImageView * imgViewSortByOpenClose = (UIImageView *)[viewPopUp viewWithTag:203];
    
    imgViewSortByDistance.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
    imgViewSortByName.image = [UIImage imageNamed:@"ic_radio_button_checked.png"];
    imgViewSortByOpenClose.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
    
    sortByStatus = @"trading_name";
}

-(void)onBtnSortByOpenClose:(UIButton *)btnSender
{
    UIView * viewPopUp = (UIView *)[coverView viewWithTag:1100];
    
    UIImageView * imgViewSortByDistance = (UIImageView *)[viewPopUp viewWithTag:201];
    UIImageView * imgViewSortByName = (UIImageView *)[viewPopUp viewWithTag:202];
    UIImageView * imgViewSortByOpenClose = (UIImageView *)[viewPopUp viewWithTag:203];
    
    imgViewSortByDistance.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
    imgViewSortByName.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
    imgViewSortByOpenClose.image = [UIImage imageNamed:@"ic_radio_button_checked.png"];
    
    sortByStatus = @"status";

}

-(void)onBtnSortByDismiss:(UIButton *)btnSender
{
    sortByStatus = @"";
    [coverView removeFromSuperview];
}

-(void)onBtnSortByChoose:(UIButton *)btnSender
{
    [coverView removeFromSuperview];
    
    sortBy = sortByStatus;
    
     arraySearchedResults = [self sortArrayInAscendingOrder:arraySearchedResults keyName:sortBy];
     [self.tableViewSearch reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-- Popupview

-(void)addLocatoinPopup:(int)index
{
    coverView=[[UIView alloc]initWithFrame:self.view.frame];
    coverView.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"LogoPopupView" owner:self options:nil];
    UIView *customPopUp=[subviewArray objectAtIndex:1];
    
    customPopUp.center=CGPointMake(coverView.center.x, coverView.center.y);
    
    NSMutableDictionary *dic=[arraySearchedResults objectAtIndex:index];
    
    UIView *popupView=(UIImageView *)[customPopUp viewWithTag:100];
    popupView.layer.cornerRadius=5.0;
    
    UILabel *lblAddress=(UILabel *)[customPopUp viewWithTag:104];
    lblAddress.text=dic[@"location"][@"address"];
    
    UIButton *btnShowOnMap=(UIButton *)[customPopUp viewWithTag:103];
    btnShowOnMap.tag=index;
    [btnShowOnMap addTarget:self action:@selector(showOnMap:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btnClose=(UIButton *)[customPopUp viewWithTag:102];
    [btnClose addTarget:self action:@selector(onBtnClose:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [coverView addSubview:customPopUp];
    [self.view addSubview:coverView];
}

-(void)addCustomView:(int)index{
    
    coverView=[[UIView alloc]initWithFrame:self.view.frame];
    coverView.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"LogoPopupView" owner:self options:nil];
    UIView *customPopUp=[subviewArray objectAtIndex:0];
    
    customPopUp.center=CGPointMake(coverView.center.x, coverView.center.y);
    
    NSMutableDictionary *dic=[arraySearchedResults objectAtIndex:index];
    
    UIView *popupView=(UIImageView *)[customPopUp viewWithTag:100];
    popupView.layer.cornerRadius=5.0;
    
    UIImageView *imgView=(UIImageView *)[customPopUp viewWithTag:101];
    [imgView sd_setImageWithURL: [NSURL URLWithString:[dic objectForKey:@"image_url"]]];
    
    
    UIButton *btnClose=(UIButton *)[customPopUp viewWithTag:102];
    [btnClose addTarget:self action:@selector(onBtnClose:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [coverView addSubview:customPopUp];
    [self.view addSubview:coverView];
    
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
