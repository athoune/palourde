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
#import "ThermoActionCell.h"

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
    infos = [[NSMutableDictionary alloc] initWithCapacity:3];
}

-(void) reset {
}

-(void)add:(ActionCell *)action {
    [infos setObject:action forKey:[action name]];
}
-(void)remove:(ActionCell *)action {
    [infos removeObjectForKey:[action name]];
}


-(void) contaminationAdded: (NSNotification *)notification {
}
   

- (void) freshclamDownload: (NSNotification *)notification {
    //NSLog(@"Thermo FreshClam Download %@", [notification userInfo] );
    NSString *filename = [[notification userInfo] objectForKey:@"file"];
    NSLog(@"the value: %@", [infos objectForKey:filename]);
    if([infos objectForKey:filename] == nil) {
	NSLog(@"New download file : %@ with size : %@", filename, [[notification userInfo] objectForKey:@"total" ]);
	[self add:
	    [[ThermoActionCell alloc] initWithName:filename andMax: [[[notification userInfo] objectForKey:@"total" ] doubleValue]]
	];
    }
	[[[infos objectForKey:filename] thermometre] setDoubleValue:[[[notification userInfo] objectForKey:@"downloaded"] doubleValue]];
}


-(NSInteger) outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
	    return [infos count];
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