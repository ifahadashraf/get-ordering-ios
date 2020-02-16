//
//  FavouriteViewController.m
//  GetOrdering
//
//  Created by shahbaz tariq on 1/31/18.
//  Copyright © 2018 Ali Apple. All rights reserved.
//

#import "FavouriteViewController.h"
#import "TVCell.h"
#import "LogoPopupView.h"
#import "MenuVC.h"
#import <MapKit/MapKit.h>

@interface FavouriteViewController ()
{
    NSMutableDictionary * dictFavorites;
    UIView * coverView;
}
@property(strong,nonatomic) IBOutlet UITableView * tblViewFavorites;
@property(strong,nonatomic) IBOutlet UILabel * lblNoRecord;

@end

@implementation FavouriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super addFavOPageBack];
    [self.btnMenu addTarget:self action:@selector(onBtnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    self.lblHeading.text=@"Favourite";
    
    [self.tblViewFavorites setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tblViewFavorites.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    self.tblViewFavorites.tableHeaderView=[[UIView alloc]initWithFrame:CGRectZero];
    self.tblViewFavorites.backgroundColor=[UIColor clearColor];
    
    dictFavorites = [[[NSUserDefaults standardUserDefaults]objectForKey:@"favorites"]mutableCopy];
    
    if ([[dictFavorites allKeys] count] > 0) {
        self.lblNoRecord.hidden = YES;
        self.tblViewFavorites.hidden = NO;
    }
    else
    {
        self.lblNoRecord.hidden = NO;
        self.tblViewFavorites.hidden = YES;
    }
    
}

-(IBAction)onBtnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark--UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[dictFavorites allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *iDentifier = @"TVCell";
    
    TVCell *cell = (TVCell *)[tableView dequeueReusableCellWithIdentifier:iDentifier];
    
    NSArray *nib;
    if (cell == nil) {
        nib = [[NSBundle mainBundle] loadNibNamed:@"TVCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSArray * arrayKeys = [dictFavorites allKeys];
    
    NSString * keyName = arrayKeys[indexPath.row];
    
    NSMutableDictionary * dictInfo = dictFavorites[keyName];
    
    NSString * favStr = dictInfo[@"favData"];
    
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:[[favStr stringByRemovingPercentEncoding] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    
    cell.lblTradingName.text = dict[@"trading_name"];
    cell.lblIsOpen.text = [dict[@"work_info"][@"isOpen"] intValue] == 0 ? @"Close" : @"Open" ;
    
    cell.lblBusinessType.text = [dict[@"business_type"] componentsJoinedByString:@" | "];
    
    cell.lblFoodType.text = dict[@"food_type"];
    cell.lblViewsCount.text = [NSString stringWithFormat:@"%@ views",dict[@"Views"]];
    
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
    return 135;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)onBtnFav:(UIButton *)btnSender
{
    NSArray * arrayKeys = [dictFavorites allKeys];
    
    NSString * keyName = arrayKeys[btnSender.tag];
    
    NSMutableDictionary * dictInfo = dictFavorites[keyName];
    
    NSString * favStr = dictInfo[@"favData"];
    
    NSDictionary * dictFav = [NSJSONSerialization JSONObjectWithData:[[favStr stringByRemovingPercentEncoding] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    
    NSDictionary * productInfo = [dictFav mutableCopy];
    
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
    
    dictFavorites = [dict mutableCopy];
    
    if ([[dictFavorites allKeys] count] > 0) {
        self.lblNoRecord.hidden = YES;
        self.tblViewFavorites.hidden = NO;
    }
    else
    {
        self.lblNoRecord.hidden = NO;
        self.tblViewFavorites.hidden = YES;
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:dict forKey:@"favorites"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    

    [self.tblViewFavorites reloadData];
}

- (NSString *)convertFavDictToStr:(NSDictionary *)favoritesDict  {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:favoritesDict options:0 error:NULL];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return [jsonString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

-(void)onBtnCall:(UIButton *)sender
{
    NSArray * arrayKeys = [dictFavorites allKeys];
    NSString * keyName = arrayKeys[sender.tag];
    NSMutableDictionary * dictInfo = dictFavorites[keyName];
    NSString * favStr = dictInfo[@"favData"];
    
    NSDictionary * dictFav = [NSJSONSerialization JSONObjectWithData:[[favStr stringByRemovingPercentEncoding] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    
    NSDictionary * dic = [dictFav mutableCopy];
        
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
    NSArray * arrayKeys = [dictFavorites allKeys];
    NSString * keyName = arrayKeys[btnSender.tag];
    NSMutableDictionary * dictInfo = dictFavorites[keyName];
    NSString * favStr = dictInfo[@"favData"];
    
    NSDictionary * dictFav = [NSJSONSerialization JSONObjectWithData:[[favStr stringByRemovingPercentEncoding] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    
    NSDictionary * dic = [dictFav mutableCopy];
    
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
    
    NSArray * arrayKeys = [dictFavorites allKeys];
    NSString * keyName = arrayKeys[btnSender.tag];
    NSMutableDictionary * dictInfo = dictFavorites[keyName];
    NSString * favStr = dictInfo[@"favData"];
    
    NSDictionary * dictFav = [NSJSONSerialization JSONObjectWithData:[[favStr stringByRemovingPercentEncoding] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    
    NSDictionary * dic = [dictFav mutableCopy];
    
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
    
    NSArray * arrayKeys = [dictFavorites allKeys];
    NSString * keyName = arrayKeys[btnSender.tag];
    NSMutableDictionary * dictInfo = dictFavorites[keyName];
    NSString * favStr = dictInfo[@"favData"];
    
    NSDictionary * dictFav = [NSJSONSerialization JSONObjectWithData:[[favStr stringByRemovingPercentEncoding] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    
    NSDictionary * dic = [dictFav mutableCopy];
    
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
    
    NSArray * arrayKeys = [dictFavorites allKeys];
    NSString * keyName = arrayKeys[btnSender.tag];
    NSMutableDictionary * dictInfo = dictFavorites[keyName];
    NSString * favStr = dictInfo[@"favData"];
    
    NSDictionary * dictFav = [NSJSONSerialization JSONObjectWithData:[[favStr stringByRemovingPercentEncoding] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    
    NSDictionary * dic = [dictFav mutableCopy];
    
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
    
    NSArray * arrayKeys = [dictFavorites allKeys];
    NSString * keyName = arrayKeys[btnSender.tag];
    NSMutableDictionary * dictInfo = dictFavorites[keyName];
    NSString * favStr = dictInfo[@"favData"];
    
    NSDictionary * dictFav = [NSJSONSerialization JSONObjectWithData:[[favStr stringByRemovingPercentEncoding] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    
    NSDictionary * dic = [dictFav mutableCopy];
    
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
    NSArray * arrayKeys = [dictFavorites allKeys];
    NSString * keyName = arrayKeys[btnSender.tag];
    NSMutableDictionary * dictInfo = dictFavorites[keyName];
    NSString * favStr = dictInfo[@"favData"];
    
    NSDictionary * dictFav = [NSJSONSerialization JSONObjectWithData:[[favStr stringByRemovingPercentEncoding] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    
    NSDictionary * dic = [dictFav mutableCopy];
    
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
    
    NSArray * arrayKeys = [dictFavorites allKeys];
    NSString * keyName = arrayKeys[btnSender.tag];
    NSMutableDictionary * dictInfo = dictFavorites[keyName];
    NSString * favStr = dictInfo[@"favData"];
    
    NSDictionary * dictFav = [NSJSONSerialization JSONObjectWithData:[[favStr stringByRemovingPercentEncoding] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    
    NSDictionary * dic = [dictFav mutableCopy];
    
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
    NSArray * arrayKeys = [dictFavorites allKeys];
    NSString * keyName = arrayKeys[btnSender.tag];
    NSMutableDictionary * dictInfo = dictFavorites[keyName];
    NSString * favStr = dictInfo[@"favData"];
    
    NSDictionary * dictFav = [NSJSONSerialization JSONObjectWithData:[[favStr stringByRemovingPercentEncoding] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    
    NSDictionary * dic = [dictFav mutableCopy];
    
    [coverView removeFromSuperview];
    MenuVC * menuVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MenuVC class])];
    menuVC.dictData = dic;
    [self.navigationController pushViewController:menuVC animated:YES];
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

- (NSString *)getDateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
    return stringFromDate;
}

#pragma mark-- Popupview

-(void)addLocatoinPopup:(int)index
{
    coverView=[[UIView alloc]initWithFrame:self.view.frame];
    coverView.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"LogoPopupView" owner:self options:nil];
    UIView *customPopUp=[subviewArray objectAtIndex:1];
    
    customPopUp.center=CGPointMake(coverView.center.x, coverView.center.y);
    
    NSArray * arrayKeys = [dictFavorites allKeys];
    NSString * keyName = arrayKeys[index];
    NSMutableDictionary * dictInfo = dictFavorites[keyName];
    NSString * favStr = dictInfo[@"favData"];
    
    NSDictionary * dictFav = [NSJSONSerialization JSONObjectWithData:[[favStr stringByRemovingPercentEncoding] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    
    NSDictionary * dic = [dictFav mutableCopy];
    
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
    
    NSArray * arrayKeys = [dictFavorites allKeys];
    NSString * keyName = arrayKeys[index];
    NSMutableDictionary * dictInfo = dictFavorites[keyName];
    NSString * favStr = dictInfo[@"favData"];
    
    NSDictionary * dictFav = [NSJSONSerialization JSONObjectWithData:[[favStr stringByRemovingPercentEncoding] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    
    NSDictionary * dic = [dictFav mutableCopy];
    
    UIView *popupView=(UIImageView *)[customPopUp viewWithTag:100];
    popupView.layer.cornerRadius=5.0;
    
    UIImageView *imgView=(UIImageView *)[customPopUp viewWithTag:101];
    [imgView sd_setImageWithURL: [NSURL URLWithString:[dic objectForKey:@"image_url"]]];
    
    
    UIButton *btnClose=(UIButton *)[customPopUp viewWithTag:102];
    [btnClose addTarget:self action:@selector(onBtnClose:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [coverView addSubview:customPopUp];
    [self.view addSubview:coverView];
    
    
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
