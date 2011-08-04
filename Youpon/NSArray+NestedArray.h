//
//  NSArray+NestedArray.h
//  Youpon
//
//  Created by Garrison on 8/4/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray(NestedArray)

/**
 This method will return an object contained with an array contained within this array.  
 It is intended to allow single-step retrieval of objects in the nested array using an index path.
 */
- (id)nestedObjectAtIndexPath:(NSIndexPath *)indexPath;

/**
 This method will return the count from a subarray.
 */
- (NSInteger)countOfNestedArray:(NSUInteger)section;


@end
