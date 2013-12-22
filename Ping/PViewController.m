//
//  PViewController.m
//  Ping
//
//  Created by zorro on 13-12-22.
//  Copyright (c) 2013年 zorro. All rights reserved.
//

#import "PViewController.h"
#import "SimplePing.h"

@interface PViewController ()
{
    SimplePing *_pinger;
    NSDate *_startDate;
}

@end

@implementation PViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ping:(id)sender {
    NSString *addr = _address.text;
    NSLog(@"Address is %@", addr);
    
    _pinger = [SimplePing simplePingWithHostName:addr];
    _pinger.delegate = self;
    [_pinger start];
}

#pragma mark Simple Ping Delegate

- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address
{
    [_pinger sendPingWithData:nil];
    NSLog(@"Send data");
}

- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error
{
    NSLog(@"Failed");
    return;
}

- (void)simplePing:(SimplePing *)pinger didSendPacket:(NSData *)packet
{
    _startDate = [NSDate date];
    NSLog(@"Packet send successfully");
}

- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet error:(NSError *)error
{
    NSLog(@"Fail to send packet");
}

- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:_startDate];
    NSLog(@"Host responsed in %0.2lf ms", interval*1000);
}

- (void)simplePing:(SimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet
{
    NSLog(@"Received an unexpected packet");
}
@end
