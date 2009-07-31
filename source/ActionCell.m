//
//  ActionCell.m
//  Palourde
//
//  Created by Mathieu Lecarme on 29/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ActionCell.h"

@implementation ActionCell

- (id) init {
	[self dealloc];
	@throw [NSException exceptionWithName:@"BadInitCode" reason:@"Il faut l'initialiser avec un chemin" userInfo:nil];
	return nil;
}

-(id) initWithName: (NSString *)theName {
	if(![super init])
		return nil;
	if(theName == nil)
		return nil;
	name = [theName copy];
	return self;
}

-(NSString*) name {
	return name;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<ActionCell: %@>", name];
}

- (BOOL)isEqual:(id)item {
	if(! [item isKindOfClass:[ActionCell class]])
		return FALSE;
	return [[self name] isEqualToString:[item name]];
}

-(void) icon:(NSImage *) theIcon {
    if(theIcon != icon){
	[icon release];
	icon = [theIcon retain];
    }
}

-(id)detail {
    return [NSString stringWithFormat:@"%@", value];
}

-(NSImage*)icon {
    return [icon retain];
}

/*- (id)copyWithZone:(NSZone *)zone {
    return NSCopyObject(self, 0, zone);
}*/
@end
