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
    NSImage *icon;
}

-(id) initWithName: (NSString *) theName ;
-(BOOL) isEqual:(id)anObject;
-(void) icon:(NSImage *) theIcon;
-(NSString *) description;
-(NSString*) name;
-(id) detail;
-(NSImage*)icon;
-(id)copyWithZone:(NSZone *)zone;
@end
