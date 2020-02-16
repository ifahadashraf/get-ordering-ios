//
//  GOParentViewController.m
//  GetOrdering
//
//  Created by Ali Apple on 1/19/18.
//  Copyright © 2018 Ali Apple. All rights reserved.
//

#import "GOParentViewController.h"

@interface GOParentViewController ()

@end

@implementation GOParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self.navigationController.navigationBar setHidden:YES];
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
    NSString *cString = [[hex
                          stringByTrimmingCharactersInSet:[NSCharacterSet
                                                           whitespaceAndNewlineCharacterSet]]
                         uppercaseString];
    
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

-(void)addMainPagetopview{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    topView.backgroundColor=[self colorWithHexString:@"999933"];
  
    SWRevealViewController *revealController = [self revealViewController];
    self.btnMenu=[[UIButton alloc]initWithFrame:CGRectMake(20, 25, 25, 25)];
    [self.btnMenu setImage:[UIImage imageNamed:@"ic_menu"] forState:UIControlStateNormal];
    [self.btnMenu addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    self.lblHeading=[[UILabel alloc]initWithFrame:CGRectMake(self.btnMenu.frame.origin.x+self.btnMenu.frame.size.width+15, 25, 150, 25)];
    self.lblHeading.font=[UIFont boldSystemFontOfSize:16];
    self.lblHeading.textColor= [UIColor whiteColor];
 
    [topView addSubview:self.btnMenu];
    [topView addSubview:self.lblHeading];
    [self.view addSubview:topView];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    self.viewError = [[UIView alloc]initWithFrame:CGRectMake(0, 0,screenSize.width, screenSize.height)];
    self.viewError.backgroundColor = [UIColor whiteColor];
    
    self.lblError = [[UILabel alloc]initWithFrame:CGRectMake(25,0,screenSize.width - 50, screenSize.height)];
    self.lblError.textColor = [UIColor blackColor];
    self.lblError.numberOfLines = 0;
    self.lblError.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblError.textAlignment = NSTextAlignmentCenter;
    self.lblError.font = [UIFont boldSystemFontOfSize:24.0];
    
    [self.viewError addSubview:self.lblError];
    
    self.viewError.hidden = YES;
    [self.view addSubview:self.viewError];
    [self.view bringSubviewToFront:self.viewError];
}


-(void)addFavOPageBack
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    topView.backgroundColor=[self colorWithHexString:@"999933"];
    
    
    self.btnMenu=[[UIButton alloc]initWithFrame:CGRectMake(20, 25, 25, 25)];
    [self.btnMenu setImage:[UIImage imageNamed:@"ic_arrow_back_white"] forState:UIControlStateNormal];
    
    self.lblHeading=[[UILabel alloc]initWithFrame:CGRectMake(self.btnMenu.frame.origin.x+self.btnMenu.frame.size.width+15, 25, 150, 25)];
    self.lblHeading.font=[UIFont boldSystemFontOfSize:16];
    self.lblHeading.textColor= [UIColor whiteColor];
    
    [topView addSubview:self.btnMenu];
    [topView addSubview:self.lblHeading];
    [self.view addSubview:topView];
}

@end
