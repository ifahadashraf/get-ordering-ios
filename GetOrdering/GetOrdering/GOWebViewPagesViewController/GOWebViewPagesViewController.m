//
//  GOWebViewPagesViewController.m
//  GetOrdering
//
//  Created by Ali Apple on 1/19/18.
//  Copyright © 2018 Ali Apple. All rights reserved.
//

#import "GOWebViewPagesViewController.h"

@interface GOWebViewPagesViewController ()

@end

@implementation GOWebViewPagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super addMainPagetopview];
    
    NSString *strOpenFileName;
    
    if([self.strComeFrom isEqualToString:@"Copyright"])
    {
        strOpenFileName=@"Copyright";
        self.lblHeading.text=@"Copy Right";
    }
    else  if([self.strComeFrom isEqualToString:@"terms"])
    {
        strOpenFileName=@"Terms";
        self.lblHeading.text=@"Terms & Conditions";
    }
    
    NSURL *targetURL = [[NSBundle mainBundle] URLForResource:strOpenFileName withExtension:@"pdf"];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [self.myWebView loadRequest:request];
    
    
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
