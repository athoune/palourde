//
//  ActionPanel.h
//  Palourde
//
//  Created by Mathieu on 16/01/09.
//  Copyright 2009 garambrogne.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BWToolkitFramework/BWToolkitFramework.h>
#import "PAController.h"
#import "ActionCell.h"

#define NOTHING 1
#define GROWING 2
#define FULL 3
@interface ActionController : NSWindowController {
    IBOutlet BWTransparentTableView *actionTable;
    NSMutableDictionary *infos;
    PAController *mainController;
}

-(id)initWithMainController:(PAController *)mainController;
-(void) reset;
-(id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item;
-(BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item;
-(NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item;
-(id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item;
-(void)add:(ActionCell *)action;
-(void)remove:(ActionCell *)action;
@end
