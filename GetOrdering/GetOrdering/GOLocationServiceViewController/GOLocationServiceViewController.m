//
//  GOLocationServiceViewController.m
//  GetOrdering
//
//  Created by Ali Apple on 1/19/18.
//  Copyright © 2018 Ali Apple. All rights reserved.
//

#import "GOLocationServiceViewController.h"

@interface GOLocationServiceViewController ()
{
    NSString * locAccur;
}
@property(weak,nonatomic) IBOutlet UISwitch * switchLocationUpdates;
-(IBAction)onSwitchValueChanged:(UISwitch *)sender;

@property(weak,nonatomic) IBOutlet UIImageView * imgViewHigh;
@property(weak,nonatomic) IBOutlet UIImageView * imgViewLow;
@property(weak,nonatomic) IBOutlet UIImageView * imgViewMedium;

-(IBAction)onBtnLocationAccuracy:(id)sender;

@end

@implementation GOLocationServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super addMainPagetopview];
    self.lblHeading.text=@"Location Setting";
    
    BOOL isLocationUpdates = [[NSUserDefaults standardUserDefaults]boolForKey:@"isLocUpdates"];
    [self.switchLocationUpdates setOn:isLocationUpdates];
    
    NSString * locAccuracy  = [[NSUserDefaults standardUserDefaults]objectForKey:@"loc_accuracy"];
    
    if ([locAccuracy isEqualToString:@"high"]) {
        locAccur = locAccuracy;
        self.imgViewHigh.image = [UIImage imageNamed:@"ic_radio_button_checked.png"];
        self.imgViewMedium.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
        self.imgViewLow.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
    }
    
    if ([locAccuracy isEqualToString:@"medium"]) {
        locAccur = locAccuracy;
        self.imgViewHigh.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
        self.imgViewMedium.image = [UIImage imageNamed:@"ic_radio_button_checked.png"];
        self.imgViewLow.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
    }
    
    if ([locAccuracy isEqualToString:@"low"]) {
        locAccur = locAccuracy;
        self.imgViewHigh.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
        self.imgViewMedium.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
        self.imgViewLow.image = [UIImage imageNamed:@"ic_radio_button_checked.png"];
    }
    
    if (!locAccuracy) {
        [[NSUserDefaults standardUserDefaults]setObject:@"high" forKey:@"loc_accuracy"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
}

-(IBAction)onSwitchValueChanged:(UISwitch *)sender
{
    [[NSUserDefaults standardUserDefaults]setBool:sender.isOn forKey:@"isLocUpdates"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(IBAction)onBtnLocationAccuracy:(UIButton *)sender
{
    if (sender.tag == 21) {
        
        if ([locAccur isEqualToString:@"high"]) {
            return;
        }
        
        locAccur = @"high";
        self.imgViewHigh.image = [UIImage imageNamed:@"ic_radio_button_checked.png"];
        self.imgViewMedium.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
        self.imgViewLow.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
    }
    else if (sender.tag == 22){
        
        if ([locAccur isEqualToString:@"medium"]) {
            return;
        }
        
        locAccur = @"medium";
        self.imgViewHigh.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
        self.imgViewMedium.image = [UIImage imageNamed:@"ic_radio_button_checked.png"];
        self.imgViewLow.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
    }
    else{
        
        if ([locAccur isEqualToString:@"low"]) {
            return;
        }
        
        locAccur = @"low";
        self.imgViewHigh.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
        self.imgViewMedium.image = [UIImage imageNamed:@"ic_radio_button_unchecked.png"];
        self.imgViewLow.image = [UIImage imageNamed:@"ic_radio_button_checked.png"];
    }

    [[NSUserDefaults standardUserDefaults]setObject:locAccur forKey:@"loc_accuracy"];
    [[NSUserDefaults standardUserDefaults]synchronize];
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
