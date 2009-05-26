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

-(id) initWithName: (NSString *)theName type:(NSString *)theType {
	if(![super init])
		return nil;
	if(theName == nil)
		return nil;
	if(theType == nil)
		return nil;
	name = [theName copy];
	type = [theType copy];
	return self;
}

-(NSString*) name {
	return name;
}

-(NSString*) type {
	return type;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<ActionCell: [%@] %@>", type, name];
}

- (BOOL)isEqual:(id)item {
	if(! [item isKindOfClass:[ActionCell class]])
		return FALSE;
	return [[self name] isEqualToString:[item name]] && [[self type] isEqualToString:[item type]];
}

@end
