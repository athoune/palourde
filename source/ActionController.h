//
//  ActionPanel.h
//  Palourde
//
//  Created by Mathieu on 16/01/09.
//  Copyright 2009 garambrogne.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define NOTHING 1
#define GROWING 2
#define FULL 3
@interface ActionController : NSWindowController {
    IBOutlet NSOutlineView *actionTable;
    IBOutlet NSProgressIndicator *thermometre;
    int state;
    int value;
    double max;
}

-(void) reset;
@end
