//
//  Wrapper.h
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/14/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Processor : NSObject
+ (int)ProcessImageWithInFile:(NSString *)in_file outFile: (NSString *)out_file;
@end
