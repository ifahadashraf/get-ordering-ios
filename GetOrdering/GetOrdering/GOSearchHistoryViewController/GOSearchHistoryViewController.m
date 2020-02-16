//
//  GOSearchHistoryViewController.m
//  GetOrdering
//
//  Created by Ali Apple on 1/19/18.
//  Copyright © 2018 Ali Apple. All rights reserved.
//

#import "GOSearchHistoryViewController.h"
#import "MenuCell.h"
#import "HistoryCell.h"

@interface GOSearchHistoryViewController ()
{
    NSMutableDictionary * dictSearch;
}
@property(strong,nonatomic) IBOutlet UITableView * tblViewSearch;
@property(strong,nonatomic) IBOutlet UILabel * lblNoRecord;
@end

@implementation GOSearchHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super addMainPagetopview];
    self.lblHeading.text=@"Search History";
    
    [self.tblViewSearch setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tblViewSearch.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    self.tblViewSearch.tableHeaderView=[[UIView alloc]initWithFrame:CGRectZero];
    self.tblViewSearch.backgroundColor=[UIColor clearColor];
    
    dictSearch = [[[NSUserDefaults standardUserDefaults]objectForKey:@"searchInfo"]mutableCopy];
    
    if ([[dictSearch allKeys] count] > 0) {
        self.lblNoRecord.hidden = YES;
        self.tblViewSearch.hidden = NO;
    }
    else
    {
        self.lblNoRecord.hidden = NO;
        self.tblViewSearch.hidden = YES;
    }
    
}

#pragma mark--UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[dictSearch allKeys]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *iDentifier = @"Cell";
    
    HistoryCell *cell = (HistoryCell *)[tableView dequeueReusableCellWithIdentifier:iDentifier];
    
    NSArray *nib;
    
    if (cell == nil) {
        nib = [[NSBundle mainBundle] loadNibNamed:@"HistoryCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSArray * arrayKeys = [dictSearch allKeys];
    NSString * keyName = arrayKeys[indexPath.row];
    
    NSMutableDictionary * dictInfo = dictSearch[keyName];
    
    NSString * dateStr = [self getDate:dictInfo[@"dateInfo"]];
    NSString * timeStr = [self getTime:dictInfo[@"dateInfo"]];
    
    cell.lblDateTime.text = [NSString stringWithFormat:@"%@ | %@",dateStr,timeStr];
    cell.lblTitle.text = keyName;
    
    cell.btnDelete.tag = indexPath.row;
    [cell.btnDelete addTarget:self action:@selector(onBtnDelete:) forControlEvents:UIControlEventTouchUpInside];

    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * arrayKeys = [dictSearch allKeys];
    NSString * keyName = arrayKeys[indexPath.row];
    
    NSMutableDictionary * dictInfo = dictSearch[keyName];
    
    NSString * searchInfoStr = dictInfo[@"searchData"];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"menuIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    SWRevealViewController *revealController = self.revealViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    GOHomeViewController *objGOHomeViewController= (GOHomeViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GOHomeViewController"];
    objGOHomeViewController.searchInfoString = searchInfoStr;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:objGOHomeViewController];
    navigationController.navigationBar.hidden = YES;
    [revealController setFrontViewController:navigationController];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
}

-(void)onBtnDelete:(UIButton *)btnSender
{
    NSArray * arrayKeys = [dictSearch allKeys];
    NSString * keyName = arrayKeys[btnSender.tag];
    [dictSearch removeObjectForKey:keyName];
    
    if ([[dictSearch allKeys] count] > 0) {
        self.lblNoRecord.hidden = YES;
        self.tblViewSearch.hidden = NO;
        [self.tblViewSearch reloadData];
    }
    else
    {
        self.lblNoRecord.hidden = NO;
        self.tblViewSearch.hidden = YES;
    }
    
    NSMutableDictionary * dictNew = [dictSearch mutableCopy];
    
    [[NSUserDefaults standardUserDefaults]setObject:dictNew forKey:@"searchInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *)getDate:(NSString *)strDate
{
    NSDateFormatter *dtFormat = [[NSDateFormatter alloc] init];
    [dtFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *aDate = [dtFormat dateFromString:strDate];
    
    NSDateFormatter *newFormatter = [[NSDateFormatter alloc] init];
    [newFormatter setDateFormat: @"MMMM dd, yyyy"];
    
    NSString * returnStr = [newFormatter stringFromDate:aDate];
    
    return returnStr;
}

-(NSString *)getTime:(NSString *)strDate
{
    NSDateFormatter *dtFormat = [[NSDateFormatter alloc] init];
    [dtFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *aDate = [dtFormat dateFromString:strDate];
    
    NSDateFormatter *newFormatter = [[NSDateFormatter alloc] init];
    [newFormatter setDateFormat: @"hh:mm a"];
    [newFormatter setAMSymbol:@"AM"];
    [newFormatter setPMSymbol:@"PM"];
    NSString * returnStr = [newFormatter stringFromDate:aDate];
    
    return returnStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
