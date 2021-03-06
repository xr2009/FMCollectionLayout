//
//  FMLayoutSingleDynamicAddSection.m
//  FMCollectionLayout
//
//  Created by 郑桂华 on 2020/4/17.
//

#import "FMLayoutSingleDynamicAddSection.h"
#import "FMSupplementaryFooter.h"
#import "FMSupplementaryHeader.h"
#import "FMSupplementaryBackground.h"
#import "FMCollectionLayoutAttributes.h"

@interface FMLayoutSingleDynamicAddSection ()

@property(nonatomic, assign)BOOL isAppend;

@end

@implementation FMLayoutSingleDynamicAddSection

- (void)setHandleItemStart:(NSInteger)handleItemStart{
    [super setHandleItemStart:handleItemStart];
    if (self.handleItemStart == self.itemsAttribute.count) {
        self.isAppend = YES;
    } else {
        self.isAppend = NO;
    }
}

- (void)prepareItems{
    if (!self.isAppend) {
        [super prepareItems];
    } else {
        NSInteger items = [self.collectionView numberOfItemsInSection:self.indexPath.section];
        NSMutableArray *attrs = [self.itemsAttribute mutableCopy];
        for (int j = (int)self.handleItemStart; j < items; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:self.indexPath.section];
            FMCollectionLayoutAttributes *itemAttr = [FMCollectionLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            CGFloat itemWidth =  self.cellFixedWidth;
            CGFloat itemHeight = 0;
            if (self.autoHeightFixedWidth) {
                if (self.deqCellReturnReuseId) {
                    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:self.deqCellReturnReuseId(self, j) forIndexPath:indexPath];
                    if (self.configurationCell) {
                        self.configurationCell(self ,cell, j);
                    }
                    itemHeight = [cell systemLayoutSizeFittingSize:CGSizeMake(itemWidth, MAXFLOAT)].height;
                }
            } else {
                itemHeight = !self.heightBlock?0:self.heightBlock(self, j);
            }
            CGSize itemSize = CGSizeMake(itemWidth, itemHeight);
            NSInteger column = [self getMinHeightColumn];
            CGFloat x = self.sectionInset.left + column * (self.itemSpace + itemSize.width);
            CGFloat height = [self.columnHeights[@(column)] floatValue];
            CGFloat y = self.firstItemStartY + (height > 0 ? (height + self.lineSpace) : height);
            itemAttr.frame = CGRectMake(x, y, itemSize.width, itemSize.height);
            [attrs addObject:itemAttr];
            self.columnHeights[@(column)] = @(height + itemSize.height + (height > 0 ? self.lineSpace : 0));
        }
        self.itemsAttribute = [attrs copy];
    }
}

@end
