//
//  ActionPanel.m
//  Palourde
//
// Controller for the actionpanel
//
//  Created by Mathieu on 16/01/09.
//  Copyright 2009 garambrogne.net. All rights reserved.
//

#import "ActionController.h"
#import "ActionCell.h"
#import "Contamination.h"

@implementation ActionController
-(id)init {
    [self dealloc];
    @throw [NSException exceptionWithName:@"BadInitCode" reason:@"Init with the main controller" userInfo:nil];
    return nil;
}

-(id)initWithMainController:(PAController *)_mainController {
    if (![super initWithWindowNibName:@"ActionPanel"])
	return nil;
    mainController = _mainController;
    return self;
}

- (void)windowDidLoad {
	NSLog(@"Nib chargé");
}

-(void) awakeFromNib {
	NSDistributedNotificationCenter *distributedCenter = [NSDistributedNotificationCenter defaultCenter];
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[distributedCenter addObserver:self
		selector:@selector(freshclamDownload:)
		name:@"net.clamav.freshclam.download"
		object:nil];
	[center addObserver:self
		selector:@selector(contaminationAdded:)
		name:PAVirusAdded
		     object:nil];
	[self reset];
	infos = [[NSArray alloc] initWithObjects:@"Scan", @"Download", @"Virus", @"Infected", nil ];
	virus = [NSMutableArray arrayWithCapacity:3];
	files = [NSMutableArray arrayWithCapacity:3];
	[thermometre setControlTint:NSGraphiteControlTint];
	[thermometre setControlSize:NSMiniControlSize];
	[thermometre setUsesThreadedAnimation:true];
	[thermometre setBezeled:false];
	thermometres = [[NSMutableDictionary alloc] init];
}

-(void) reset {
	state = NOTHING;
	[thermometre setDoubleValue:0];
}

-(void) contaminationAdded: (NSNotification *)notification {
    [actionTable expandItem:@"Infected"];
    [actionTable reloadData];
}
   

- (void) freshclamDownload: (NSNotification *)notification {
		//NSLog(@"Thermo FreshClam Download %@", [notification userInfo] );
	if( download == nil) {
		[actionTable expandItem:@"Download"];
		download = [[NSMutableArray alloc] initWithCapacity:1];
		[download retain];
	}
	NSString *filename = [[notification userInfo] objectForKey:@"file"];
	ActionCell *file = [[ActionCell alloc] initWithName:filename type:@"File"];
	if(! [download containsObject:file]) {
		[download addObject:file];
		NSLog(@"download: %@", download);
		[actionTable reloadData];
		[thermometres setObject:[[[NSProgressIndicator alloc] init] autorelease] forKey: filename];
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
	if([item isKindOfClass:[NSString class]] && [item isEqualToString: @"Download"]) {
		return [download objectAtIndex:index];
	}
	if([item isKindOfClass:[NSString class]] && [item isEqualToString: @"Infected"]) {
	    return [[mainController contaminations] objectAtIndex:index];
	}
	return nil;
}

-(BOOL) outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
	if([item isKindOfClass:[NSString class]] && [item isEqualToString: @"Download"])
		return [download count] > 0 ;
	if([item isKindOfClass:[NSString class]] && [item isEqualToString: @"Infected"])
	    return [[mainController contaminations] count] > 0;
	return false;
}

-(NSInteger) outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
	if(item == nil)
		return [infos count];
	[item retain];
	if([item isKindOfClass:[NSString class]] && [item isEqualToString: @"Download"]) {
		return [download count];
	}
    if([item isKindOfClass:[NSString class]] && [item isEqualToString: @"Infected"]) {
		return [[mainController contaminations] count];
    }
	return  0;
}

-(id) outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
	if(tableColumn == nil || [[tableColumn identifier] isEqualToString: @"titleID"]) {
		if([item isKindOfClass:[ActionCell class]])
			return [NSString stringWithFormat:@"  %@", [item name]];
		if([item isKindOfClass:[Contamination class]])
			return [item virus];
		return [item retain];
	}
    if( [[tableColumn identifier] isEqualToString: @"valueID"]) {
	
    }
    /*
    if( [[tableColumn identifier] isEqualToString: @"actionID"]) {
	if([item isKindOfClass:[Contamination class]])
	    return [item retain];
    }
     */
	return nil;
}

/*
- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    
    if( [[tableColumn identifier] isEqualToString: @"actionID"]) {
	if([item isKindOfClass:[Contamination class]]) {
	    [[tableColumn dataCell] setIcon:[item icon]];
	}
    }
}
*/

/*
- (NSCell *)outlineView:(NSOutlineView *)outlineView dataCellForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    if(tableColumn == nil || [[tableColumn identifier] isEqualToString: @"titleID"]) {
	if([item isKindOfClass:[ActionCell class]])
	    return [[NSCell alloc] initTextCell: [item name]];
	if([item isKindOfClass:[Contamination class]])
	    return [[[NSCell alloc] initImageCell:[item icon]] autorelease];
	return [[NSCell alloc] initTextCell:item];
    }
    if( [[tableColumn identifier] isEqualToString: @"valueID"]) {
	
    }
    return nil;
}*/

@end