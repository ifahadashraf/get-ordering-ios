//
//  GOContactUsViewController.h
//  GetOrdering
//
//  Created by Ali Apple on 1/19/18.
//  Copyright © 2018 Ali Apple. All rights reserved.
//

#import "GOParentViewController.h"
#import <MessageUI/MessageUI.h>

@interface GOContactUsViewController : GOParentViewController<MFMailComposeViewControllerDelegate>
{
    
}


-(IBAction)onBtnCall:(id)sender;
-(IBAction)onBtnEmal:(id)sender;


@end
