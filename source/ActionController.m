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
    NSDistributedNotificationCenter *distributedCenter = [NSDistributedNotificationCenter defaultCenter];
    [distributedCenter addObserver:self
			  selector:@selector(freshclamDownload:)
			      name:@"net.clamav.freshclam.download"
			    object:nil];
    [self reset];
}

-(void) reset {
    state = NOTHING;
    value = 0;
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
    int percent = (int) (100 * [[[notification userInfo] objectForKey:@"downloaded"] doubleValue] / max);
    NSLog(@"percent : %i", value);
    if(percent > value) {
	value = percent;
	[thermometre setDoubleValue: (double)value];
    }
    if([[[notification userInfo] objectForKey:@"total" ] doubleValue] == [[[notification userInfo] objectForKey:@"downloaded"] doubleValue]) {
	[self reset];
    }
}

@end