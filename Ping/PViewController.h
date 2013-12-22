//
//  PViewController.h
//  Ping
//
//  Created by zorro on 13-12-22.
//  Copyright (c) 2013年 zorro. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SimplePing.h"

@interface PViewController : UIViewController <SimplePingDelegate>

@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UITextView *result;

- (IBAction)ping:(id)sender;
@end
