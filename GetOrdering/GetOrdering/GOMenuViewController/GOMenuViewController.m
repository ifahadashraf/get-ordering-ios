//
//  GOMenuViewController.m
//  GetOrdering
//
//  Created by Ali Apple on 1/19/18.
//  Copyright © 2018 Ali Apple. All rights reserved.
//

#import "GOMenuViewController.h"

@interface GOMenuViewController ()
{
    NSMutableArray *arrayMenu;
    NSInteger _presentedRow;
}

@end

@implementation GOMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
 //   arrayMenu=[[NSMutableArray alloc]initWithObjects:@"Home",@"Location Setting",@"Terms & Conditions", @"Website",@"Search History",@"Contact us",@"Copy Rights",@"FAQ", nil];
    
    arrayMenu=[[NSMutableArray alloc]initWithObjects:
               @{@"selected_icon" : @"ic_home_green.png",
                 @"unselected_icon" :@"ic_home_gray.png",
                 @"title" : @"Home"
                 },
               @{@"selected_icon" :@"ic_location_green.png" ,
                 @"unselected_icon" : @"ic_location_gray.png",
                 @"title" : @"Location Settings"
                 },
               @{  @"selected_icon" :    @"ic_terms_green.png",
                   @"unselected_icon" :    @"ic_terms_gray.png",
                   @"title" :   @"Terms & Conditions"
                   },
               @{@"selected_icon" : @"ic_website_green.png",
                 @"unselected_icon" :@"ic_website_gray.png",
                 @"title" :@"Website"
                 },
//               @{@"selected_icon" : @"ic_searchHistory_green.png",
//                 @"unselected_icon" :@"ic_searchHistory_gray.png",
//                 @"title" : @"Search History"
//                 },
//               @{@"selected_icon"  :@"ic_menu_Fav_Green",
//                 @"unselected_icon" :@"ic_menu_Fav",
//                 @"title" :@"Favourite"
//                 },
               @{@"selected_icon"  :@"ic_contactus_green.png",
                 @"unselected_icon" :@"ic_contactus_gray.png",
                 @"title" :@"Contact Us"
                 },
               @{@"selected_icon" :@"ic_copyright_green.png",
                 @"unselected_icon" :@"ic_copyright_gray.png",
                 @"title" :@"Copyrights"
                 },
               @{@"selected_icon" : @"ic_FAQ_green.png",
                 @"unselected_icon" :@"ic_FAQ_gray.png",
                 @"title" :@"FAQ"
                 },
               nil];
    
    [self.datatableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.datatableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    self.datatableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectZero];
    self.datatableView.backgroundColor=[UIColor clearColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.datatableView reloadData];
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

- (UIColor *)colorWithHexString:(NSString *)hex {
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:1.0f];
}

#pragma mark-- Uitableview Delegate and Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrayMenu count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"Cell";
    
    GOMenuTableViewCell *cell = (GOMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    NSArray *nib;
    if (cell == nil) {
        nib = [[NSBundle mainBundle] loadNibNamed:@"GOMenuTableViewCell"
                                            owner:self
                                          options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    NSDictionary * dict = arrayMenu[indexPath.row];
    
    cell.lblMenuItem.text = dict[@"title"] ;
    
    int menuIndex = [[[NSUserDefaults standardUserDefaults]objectForKey:@"menuIndex"] intValue];
    NSInteger selectedRow = (NSInteger) menuIndex;
    
    if(indexPath.row == selectedRow)
    {
        cell.lblMenuItem.textColor=[self colorWithHexString:@"999933"];
        cell.backgroundColor=[UIColor lightGrayColor];
        cell.menuItemImageView.image = [UIImage imageNamed:dict[@"selected_icon"]];
        cell.backgroundColor=[self colorWithHexString:@"cccccc"];
    }
    else
    {
        cell.lblMenuItem.textColor=[UIColor blackColor];
        cell.backgroundColor=[UIColor whiteColor];
        cell.menuItemImageView.image = [UIImage imageNamed:dict[@"unselected_icon"]];
        cell.backgroundColor=[UIColor clearColor];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SWRevealViewController *revealController = self.revealViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle: nil];

  //  NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    
    // selecting row
    NSInteger row = indexPath.row;
    
    int menuIndex = [[[NSUserDefaults standardUserDefaults]objectForKey:@"menuIndex"] intValue];
    
    NSInteger selectedRow = (NSInteger) menuIndex;
    
    // if we are trying to push the same row or perform an operation that does not imply frontViewController replacement
    // we'll just set position and return
    
    if (row == selectedRow)
    {
        [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        return;
    }
    
    // otherwise we'll create a new frontViewController and push it with animation
    
    UIViewController *newFrontController = nil;
    
    if(indexPath.row==0)
    {
        //Home
        
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"menuIndex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        GOHomeViewController *objGOHomeViewController= (GOHomeViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GOHomeViewController"];
        newFrontController = objGOHomeViewController;
    }
    else if (row == 1)
    {
        //Location Setting
        
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"menuIndex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        GOLocationServiceViewController *objGOLocationServiceViewController= (GOLocationServiceViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GOLocationServiceViewController"];
        newFrontController = objGOLocationServiceViewController;
    }
    else if (row == 2)
    {
        //Terms & Conditions
        [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"menuIndex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        GOWebViewPagesViewController*objGOWebViewPagesViewController= (GOWebViewPagesViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GOWebViewPagesViewController"];
        objGOWebViewPagesViewController.strComeFrom=@"terms";
        newFrontController = objGOWebViewPagesViewController;
    }
    else if (row == 3)
    {
        //Website
        [[NSUserDefaults standardUserDefaults]setObject:@"3" forKey:@"menuIndex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
         [self.datatableView reloadData];
        
        NSURL *facebookURL = [NSURL URLWithString:@"http://www.nuroworks.com/takkiweb/"];
        if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
            [[UIApplication sharedApplication] openURL:facebookURL];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@""]];
        }
        
        return;
    }
    else if (row == 99)
    {
        //Search History
        
        [[NSUserDefaults standardUserDefaults]setObject:@"4" forKey:@"menuIndex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        GOSearchHistoryViewController *objGOSearchHistoryViewController= (GOSearchHistoryViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GOSearchHistoryViewController"];
        newFrontController = objGOSearchHistoryViewController;
    }
    else if (row == 99)
    {
        //Favourite
        [[NSUserDefaults standardUserDefaults]setObject:@"5" forKey:@"menuIndex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        FavouriteViewController*objFavouriteViewController= (FavouriteViewController *)[storyboard instantiateViewControllerWithIdentifier:@"FavouriteViewController"];
        newFrontController = objFavouriteViewController;
    }
    else if (row == 4)
    {
        //Contact us
        [[NSUserDefaults standardUserDefaults]setObject:@"4" forKey:@"menuIndex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        GOContactUsViewController*objGOContactUsViewController= (GOContactUsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GOContactUsViewController"];
        newFrontController = objGOContactUsViewController;
        
    }
    else if (row == 5)
    {
        //Copy Rights
        [[NSUserDefaults standardUserDefaults]setObject:@"5" forKey:@"menuIndex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        GOWebViewPagesViewController*objGOWebViewPagesViewController= (GOWebViewPagesViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GOWebViewPagesViewController"];
        objGOWebViewPagesViewController.strComeFrom=@"Copyright";
        newFrontController = objGOWebViewPagesViewController;
        
    }
    else if (row == 6)
    {
        //FAQ
        
        //Copy Rights
        [[NSUserDefaults standardUserDefaults]setObject:@"6" forKey:@"menuIndex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
         [self.datatableView reloadData];
        
        NSURL *facebookURL = [NSURL URLWithString:@"http://www.nuroworks.com/takkiweb/"];
        if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
            [[UIApplication sharedApplication] openURL:facebookURL];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@""]];
        }
        
        return;
    }
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newFrontController];
    [revealController.navigationController.navigationBar setHidden:YES];
    [revealController pushFrontViewController:navigationController animated:YES];
    
    _presentedRow = row;
    [self.datatableView reloadData];
 
}


@end
