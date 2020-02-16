//
//  GOContactUsViewController.m
//  GetOrdering
//
//  Created by Ali Apple on 1/19/18.
//  Copyright © 2018 Ali Apple. All rights reserved.
//

#import "GOContactUsViewController.h"

@interface GOContactUsViewController ()

@end

@implementation GOContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super addMainPagetopview];
    self.lblHeading.text=@"Contact Us";
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

#pragma mark-- IBAction Methods

-(IBAction)onBtnCall:(id)sender
{
    UIButton *btnSender=(UIButton *)sender;
    
    NSString *phNo;
    
    if((int)btnSender.tag==1)
    {
        phNo= @"+27117392150";
    }
    else
    {
       phNo= @"+27729182372";
    }
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
       //show error message
    }
}

-(IBAction)onBtnEmal:(id)sender{
if ([MFMailComposeViewController canSendMail])
{
    UIButton *btnSender=(UIButton *)sender;
    
    NSString *strEmail;
    
    if((int)btnSender.tag==1)
    {
        strEmail= @"info@mytakki.com";
    }
    else
    {
        strEmail= @"mytakki@gmail.com";
    }
    
    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
    mail.mailComposeDelegate = self;
    [mail setSubject:@""];
    [mail setMessageBody:@"Here is some main text in the email!" isHTML:NO];
    [mail setToRecipients:@[strEmail]];
    
    [self presentViewController:mail animated:YES completion:NULL];
}
else
{
    NSLog(@"This device cannot send email");
}
}
@end
