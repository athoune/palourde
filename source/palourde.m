//
//  palourde.m
//  Palourde
//
//  Created by Mathieu Lecarme on 13/01/09.
//  Copyright 2009 Noven. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "ClamavClient.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    ClamavClient *client = [[ClamavClient alloc] initWithPath:@"/tmp/clamd.socket"];
	//NSLog(@"Ping: %@", [client ping]);
	//NSLog(@"Version: %@", [client version]);
	[client contscan:@"/tmp/"];
    //NSLog(@"Pool : %@", pool);
    
    [pool drain];
    return 0;
}
