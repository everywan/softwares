# ocr
ocr属于计算机图形学的一部分.

ocr识别有两部分要点
1. 将图片分为不同大小进行扫描(卷积层?还没有细看)
2. 使用机器学习算法训练模型.

## tesseract-ocr
tesseract 是目前比较火的, 开箱即用的识别工具. 2006年后由谷歌运营维护.

tesseract 的识别率与图片清晰度有关. 常规模式下(如文章截图)识别率挺高的.
特定场景识别还是需要训练.

tesseract支持多种模式的调用, 包括cli, js等.

- cli, 库 [tesseract](https://github.com/tesseract-ocr/tesseract)
- js [tesseract.js](https://github.com/naptha/tesseract.js)

相关知识
- OSD: Orientation and script detection(OSD) 指页面的方向检测和文字的方向检测.

## 基于训练模型的识别
Region Proposal R-CNN系列算法: two-stage, 先使用启发式方法或CNN网络产生 Region Proposal, 然后
在 RP 上做分类和回归.

yolo: you only look once, one-stage算法, 仅用一个CNN网络直接预测不同目标的类别和位置

### 基于yolo的识别框架
darknet 深度学习框架, 训练模型用于ocr, yolo, 基于c实现.

试了下, 识别率不如 tesseract

## 商业方法
使用 阿里/腾讯 的ocr识别. 在特定领域识别更准确, 如发票/报表等.
