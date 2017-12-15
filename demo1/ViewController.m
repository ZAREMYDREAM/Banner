//
//  ViewController.m
//  demo1
//
//  Created by ZAREMYDREAM on 2017/12/15.
//  Copyright © 2017年 Devil. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(strong,nonatomic)UICollectionView *collection;

@property(strong,nonatomic)NSTimer *timer;

@end

@implementation ViewController

-(UICollectionView *)collection{
    if (!_collection) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(self.view.frame.size.width, 300);

        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;

        flowLayout.minimumInteritemSpacing = 0;
        
        _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300) collectionViewLayout:flowLayout];
        
        [_collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
        _collection.delegate = self;
        _collection.dataSource = self;
        
        _collection.pagingEnabled = YES;
        
        _collection.contentOffset = CGPointMake(self.view.frame.size.width, 0);
        
      self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
    }
    
    return _collection;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collection];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource实现
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UICollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
    }
    else
    {
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    NSInteger imageNum;
    switch (indexPath.row) {
        case 0:
            imageNum = 3;
            break;
            
        case 5:
            imageNum = 0;
            break;
            
        default:
            imageNum = indexPath.row - 1;
            break;
    }
    
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"img_0%ld",(long)imageNum]]];
    
    imgV.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
    
    [cell addSubview:imgV];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate实现
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if ([scrollView isEqual:_collection])
    {
        int page = (int)_collection.contentOffset.x / self.view.frame.size.width;
        
        if (page == 5)
        {
            [_collection setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:NO];
        }
        else if (page == 0)
        {
            [_collection setContentOffset:CGPointMake(5 * self.view.frame.size.width, 0) animated:NO];
        }
    }
}

#pragma mark - 定时器滚动collectionView
-(void)scrollImage{
    int page = (int)_collection.contentOffset.x / self.view.frame.size.width;
    
    page++;
    
    if (page < 6)
    {
        [_collection setContentOffset:CGPointMake(page * self.view.frame.size.width, 0) animated:YES];
    }

}

@end
