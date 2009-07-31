//
//  PAAction.h
//  Palourde
//
//  Created by Mathieu Lecarme on 29/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAAction : NSObject {
    NSString *name;
    NSImage *icon;
    double max;
    double doubleValue;
}
-(id) initWithName: (NSString *) theName andMax:(double) theMax andIcon:(NSImage*) theIcon;
-(void) setDoubleValue: (double) value;
-(void) setIcon:(NSImage *) theIcon;
-(NSString *) description;
-(NSString*) name;
-(id) detail;
-(NSImage*)icon;

-(BOOL) isEqual:(id)anObject;
//-(id)copyWithZone:(NSZone *)zone;
@end
