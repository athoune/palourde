//
//  PAAction.m
//  Palourde
//
//  Created by Mathieu Lecarme on 29/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PAAction.h"

@implementation PAAction

-(id) initWithName: (NSString *) theName andMax:(double) theMax andIcon:(NSImage *) theIcon {
    if(theName == nil)
	return nil;
    max = theMax;
    name = [theName copy];
    icon = [theIcon copy];
    doubleValue = 0;
    old = 0;
    step = theMax / 50;
    return self;
}

-(void) setDoubleValue:(double) theValue {
    doubleValue = theValue;
}

-(void) setIcon:(NSImage *) theIcon {
    if(theIcon != icon){
	[icon release];
	icon = [theIcon retain];
    }
}

-(id) detail {
    return [NSNumber numberWithDouble: 100 * doubleValue / max];
}

-(NSString*) name {
	return name;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<ActionCell: %@>", name];
}

- (BOOL)isEqual:(id)item {
	if(! [item isKindOfClass:[PAAction class]])
		return FALSE;
	return [[self name] isEqualToString:[item name]];
}

-(BOOL)isNew {
    if(old == 0)
	return TRUE;
    if(old -doubleValue > step) {
	old = doubleValue;
	return TRUE;
    }
    return FALSE;
}

-(NSImage*)icon {
    return [icon retain];
}

/*- (id)copyWithZone:(NSZone *)zone {
    return NSCopyObject(self, 0, zone);
}*/
@end
