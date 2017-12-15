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

@property(strong,nonatomic)UIPageControl *page;

@property(strong,nonatomic)NSTimer *timer;

@end

@implementation ViewController
#pragma mark - 懒加载
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
        
        _collection.pagingEnabled = YES; //设置整页滚动
        
        _collection.contentOffset = CGPointMake(self.view.frame.size.width, 0); //设置初始位置为第一张图
        
        _collection.showsHorizontalScrollIndicator = NO;//隐藏水平滚动条
        
      self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scrollImage) userInfo:nil repeats:YES]; //添加定时器 实现自动滚动
    }
    
    return _collection;
}

-(UIPageControl *)page{
    if (!_page) {
        _page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        
        _page.numberOfPages = 4; //设置圆点个数
        
        _page.currentPage = 0;//设置初始选中点
        
        _page.center = CGPointMake(self.view.frame.size.width / 2.0, 250);//设置中心位置
    }
    
    return _page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collection];
    
    [self.view addSubview:self.page];
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
    
    //将第一张加到最后一个cell，将最后一张加载到最后一个cell
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
//自动滚动结束时调用
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if ([scrollView isEqual:_collection])
    {
        int page = (int)_collection.contentOffset.x / self.view.frame.size.width;
        
        if (page == 5)
        {
            //当到达最后一个cell时，自动回到第二个cell
            [_collection setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:NO];
            
            self.page.currentPage = 0;
        }
        else if (page == 0)
        {
            //当到达第一个cell时，自动跳转到倒数第二个cell
            [_collection setContentOffset:CGPointMake(5 * self.view.frame.size.width, 0) animated:NO];
            
            self.page.currentPage = 3;
        }
        else
        {
            self.page.currentPage = page - 1;
        }
    }
}

//手动拖动，滚动结束时调用
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:_collection])
    {
        int page = (int)_collection.contentOffset.x / self.view.frame.size.width;
        
        if (page == 5)
        {
            [_collection setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:NO];
            
            self.page.currentPage = 0;
        }
        else if (page == 0)
        {
            [_collection setContentOffset:CGPointMake(5 * self.view.frame.size.width, 0) animated:NO];
            
            self.page.currentPage = 3;
        }
        else
        {
            self.page.currentPage = page - 1;
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
