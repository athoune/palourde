//
//  ActionCell.h
//  Palourde
//
//  Created by Mathieu Lecarme on 29/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ActionCell : NSObject {
	NSString *name;
	NSNumber *value;
	NSString *type;
}

-(id) initWithName: (NSString *)theName type:(NSString *)theType;
- (BOOL)isEqual:(id)anObject;
- (NSString *)description;
-(NSString*) name;
-(NSString*) type;
@end
