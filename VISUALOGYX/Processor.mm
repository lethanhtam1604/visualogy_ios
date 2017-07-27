//
//  Wrapper.m
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/14/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

#import "Processor.h"
#import "PipeDetection.h"

@implementation Processor

+ (int)ProcessImageWithInFile:(NSString *)in_file outFile: (NSString *)out_file {
    return ProcessImage(in_file.UTF8String, out_file.UTF8String);
}

@end