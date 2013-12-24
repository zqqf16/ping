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
    /// If the Pinger is started
    BOOL _isStarted;
    NSTimer *_timer;
    /// The count of sent packets.
    NSInteger _count;
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

- (IBAction)ping:(id)sender
{
    NSString *addr = _address.text;
    NSLog(@"Address is %@", addr);
    
    if ([addr isEqualToString:@""]) return;
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [_result setText:nil];
    
    _pinger = [SimplePing simplePingWithHostName:addr];
    _pinger.delegate = self;

    _count = 5;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(startPinger) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)updateResult:(NSString *)format, ...
{
    va_list args;
    
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    [_result setText:[_result.text stringByAppendingString:str]];
}

- (void)startPinger
{
    assert(_pinger != nil);
    
    if (_isStarted) {
        [self stopPinger:@"Request timeout\n" terminal:NO];
    }
    
    [_pinger start];
    _isStarted = YES;
    
    _count -= 1;
    if (_count <= 0) {
        [_timer invalidate];
    }
}

/**
 * Stop Pinger
 * 
 * @param reason   The reason that to stop the Pinger.
 * @param terminal Terminal the Timer or not.
 * 
 */
- (void)stopPinger:(NSString *)reason terminal:(BOOL)terminal
{
    assert(_pinger != nil);

    if (!_isStarted){
        return;
    }
    
    [_pinger stop];
    _isStarted = NO;
    
    [self updateResult:reason];
    
    if (terminal) {
        [_timer invalidate];
    }
}

#pragma mark - Simple Ping Delegate

- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address
{
    NSLog(@"Send data");
    [_pinger sendPingWithData:nil];
}

- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error
{
    NSLog(@"Failed with error %@", error);
    [self stopPinger:@"Fail to start Ping\n" terminal:YES];
}

- (void)simplePing:(SimplePing *)pinger didSendPacket:(NSData *)packet
{
    _startDate = [NSDate date];
    NSLog(@"Packet send successfully");
}

- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet error:(NSError *)error
{
    NSLog(@"Fail to send packet");
    [self stopPinger:@"Fail to send packet\n" terminal:NO];
}

- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:_startDate];
    NSLog(@"Host responsed in %0.2lf ms", interval*1000);
    
    NSString *result = [[NSString alloc] initWithFormat:@"Host responsed in %0.2lf ms\n",interval*1000];
    [self stopPinger:result terminal:NO];
}

- (void)simplePing:(SimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet
{
    NSLog(@"Received an unexpected packet");
    [self stopPinger:@"Received an unexpected packet\n" terminal:NO];
}
@end
