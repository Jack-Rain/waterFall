//
//  ImageModel.h
//  Demo
//
//  Created by Rain on 2016/12/27.
//  Copyright © 2016年 Youxiake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageModel : NSObject
@property (nonatomic, strong) UIImage *sourceImage;
@property (nonatomic, assign) CGFloat imageH;
@property (nonatomic, assign) CGFloat imageW;
@property (nonatomic, assign) CGFloat calculateImageH;
@property (nonatomic, assign) CGFloat calculateImageW;

@end
