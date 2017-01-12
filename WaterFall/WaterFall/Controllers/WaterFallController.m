//
//  WaterFallController.m
//  Demo
//
//  Created by Rain on 2016/12/27.
//  Copyright © 2016年 Youxiake. All rights reserved.
//

#import "WaterFallController.h"
#import "ImageCell.h"
#import "ImageModel.h"
#define HexColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kMaxH kScreenH / 2.0
#define kminH kScreenH / 4.0
#define kLineSpace 5 //列间距
#define kImageCell @"ImageCell"
#define kScreenW [[UIScreen mainScreen] bounds].size.width
#define kScreenH [[UIScreen mainScreen] bounds].size.height
#define kRelativeW 1080 //布局相对宽度,此处取安卓最大分辨率(可根据实际情况调整)
@interface WaterFallController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray <ImageModel *>*imageArr;
@property (nonatomic, strong) NSMutableArray <ImageModel *>*calculateImageArr;
@property (nonatomic, strong) UICollectionView *imageCollectionView;
@end

@implementation WaterFallController
- (NSMutableArray<ImageModel *> *)calculateImageArr {
    if (!_calculateImageArr) {
        _calculateImageArr = [NSMutableArray new];
    }
    return _calculateImageArr;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.imageArr = [NSMutableArray new];
    for (int i = 1; i < 50; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i]];
        ImageModel *model = [ImageModel new];
        model.sourceImage = image;
        model.imageW = image.size.width / 2.0;
        model.imageH = image.size.height / 2.0;
        [self.imageArr addObject:model];
    }
    [self creatUI];
    [self calculateSizeWithArr:self.imageArr];
    [self.imageCollectionView reloadData];
    
    // Do any additional setup after loading the view.
}
- (void)creatUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 4;
    layout.minimumInteritemSpacing= 4;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.imageCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.imageCollectionView.backgroundColor = HexColor(0Xf7f7f7);
    self.imageCollectionView.delegate = self;
    self.imageCollectionView.dataSource = self;
    [self.view addSubview:self.imageCollectionView];
    [self.imageCollectionView registerNib:[UINib nibWithNibName:kImageCell bundle:nil] forCellWithReuseIdentifier:kImageCell];
}


#pragma -- mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArr.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kImageCell forIndexPath:indexPath];
    cell.backImageView.image = [self.imageArr[indexPath.row] sourceImage];
    return cell;
}
#pragma mark - UICollectionViewFlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ImageModel *model = [self.imageArr objectAtIndex:indexPath.row];
    return CGSizeMake(model.calculateImageW, model.calculateImageH);
}

- (void)calculateSizeWithArr:(NSMutableArray <ImageModel *>*)arr {
    CGFloat totalImageW = 0;//每一行item的总宽度;
    int index = 0; //记录上一行结束时的View;
    float lineH = 0; //每一行的实际高度
    for (int i = 0; i < arr.count; i++) {
        if (i >=  arr.count - 1) {
            totalImageW = kRelativeW;
        }
        if (totalImageW + arr[i].imageW - kLineSpace >= kRelativeW) {
            float scaleWH = 0;
            for (int j = index; j <= i; j++) {
                scaleWH += arr[j].imageW / arr[j].imageH;
            }
            //计算每一行的实际高度
            lineH = (kScreenW - (i- index) * kLineSpace) / scaleWH;
            for (int N = index; N <= i; N++) {
                arr[N].calculateImageH = lineH;
                arr[N].calculateImageW = lineH * (arr[N].imageW / arr[N].imageH);
            }
            //重置totalImageW
            totalImageW = 0;
            index = i + 1;//
        } else {
            totalImageW += arr[i].imageW + kLineSpace;
        }
    }
    
}
//
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
