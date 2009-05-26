//
//  Contamination.h
//  Palourde
//
//  Created by Mathieu on 26/05/09.
//  Copyright 2009 garambrogne.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Contamination : NSObject {
    NSString *path;
    NSString *virus;
}

-(id) initWithPath:(NSString *)path andVirus:(NSString *)virus;
@end
