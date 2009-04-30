//
//  ActionPanel.m
//  Palourde
//
//  Created by Mathieu on 16/01/09.
//  Copyright 2009 garambrogne.net. All rights reserved.
//

#import "ActionController.h"
#import "ActionCell.h"

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
    NSDistributedNotificationCenter *distributedCenter = [NSDistributedNotificationCenter defaultCenter];
    [distributedCenter addObserver:self
						  selector:@selector(freshclamDownload:)
							  name:@"net.clamav.freshclam.download"
							object:nil];
    [self reset];
	infos = [[NSArray alloc] initWithObjects:@"Scan", @"Download", @"Virus", @"Infected", nil ];
    virus = [NSMutableArray arrayWithCapacity:3];
	files = [NSMutableArray arrayWithCapacity:3];
	[thermometre setControlTint:NSGraphiteControlTint];
	[thermometre setControlSize:NSMiniControlSize];
    [thermometre setUsesThreadedAnimation:true];
	[thermometre setBezeled:false];
}

-(void) reset {
    state = NOTHING;
    [thermometre setDoubleValue:0];
}

- (void) freshclamDownload: (NSNotification *)notification {
    //NSLog(@"Thermo FreshClam Download %@", [notification userInfo] );
	if( download == nil) {
		[actionTable expandItem:@"Download"];
		download = [[NSMutableArray alloc] initWithCapacity:1];
		[download retain];
	}
	ActionCell *file = [[ActionCell alloc] initWithName:[[notification userInfo] objectForKey:@"file"] type:@"File"];
	if(! [download containsObject:file]) {
		[download addObject:file];
		NSLog(@"download: %@", download);
		[actionTable reloadData];
	}
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
		//if(percent == 100){
		[self reset];
    }
}

-(id) outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
	if(item == nil)
		return [infos objectAtIndex:index];
	if([item isEqualToString: @"Download"]) {
		return [download objectAtIndex:index];
	}
	return nil;
}

-(BOOL) outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
	if([item isKindOfClass:[NSString class]] && [item isEqualToString: @"Download"])
		return true;
	return false;
}

-(NSInteger) outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
	if(item == nil)
		return [infos count];
	[item retain];
	if([item isKindOfClass:[NSString class]] && [item isEqualToString: @"Download"]) {
		return [download count];
	}
	return  0;
}
-(id) outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
	if(tableColumn == nil || [[tableColumn identifier] isEqualToString: @"titleID"]) {
		if([item isKindOfClass:[ActionCell class]])
			return [item name];
		return [item retain];
	}
	return nil;
}


@end