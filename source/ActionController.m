//
//  ActionPanel.m
//  Palourde
//
//  Created by Mathieu on 16/01/09.
//  Copyright 2009 garambrogne.net. All rights reserved.
//

#import "ActionController.h"

@implementation ActionController
-(id)init {
    if (![super initWithWindowNibName:@"ActionPanel"])
	return nil;
    return self;
}
- (void)windowDidLoad {
    NSLog(@"Nib chargé");
}

@end
