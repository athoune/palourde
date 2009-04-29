//
//  ActionPanel.m
//  Palourde
//
//  Created by Mathieu on 16/01/09.
//  Copyright 2009 garambrogne.net. All rights reserved.
//

#import "ActionController.h"

NSArray*    _classNames;

@implementation ActionController
-(id)init {
    if (![super initWithWindowNibName:@"ActionPanel"])
	return nil;
    return self;
}
- (void)windowDidLoad {
    NSLog(@"Nib chargé");
}

-(void) awakeFromNib {
    [thermometre setBezeled:false];
    [thermometre setUsesThreadedAnimation:true];
    NSDistributedNotificationCenter *distributedCenter = [NSDistributedNotificationCenter defaultCenter];
    [distributedCenter addObserver:self
			  selector:@selector(freshclamDownload:)
			      name:@"net.clamav.freshclam.download"
			    object:nil];
    [self reset];
}

-(void) reset {
    state = NOTHING;
    [thermometre setDoubleValue:0];
}

- (void) freshclamDownload: (NSNotification *)notification {
    NSLog(@"Thermo FreshClam Download %@", [notification userInfo] );
    if( state == NOTHING) {
	state = GROWING;
	[thermometre setIndeterminate:false];
	max = [[[notification userInfo] objectForKey:@"total" ] doubleValue];
	[thermometre displayIfNeeded];
    }
    double percent = (double) (100 * [[[notification userInfo] objectForKey:@"downloaded"] doubleValue] / max);
    if(percent > [thermometre doubleValue]) {
	[thermometre setDoubleValue: percent];
    }
    if([[[notification userInfo] objectForKey:@"total" ] doubleValue] == [[[notification userInfo] objectForKey:@"downloaded"] doubleValue]) {
	[self reset];
    }
}

@end