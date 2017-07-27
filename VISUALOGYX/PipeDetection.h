#pragma once

#include <vector>

#include "opencv2/imgcodecs.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"

using namespace std;
using namespace cv;
#ifdef __cplusplus
extern "C" {
#endif

    void ColorHistogramEqualization(Mat &in_image, Mat&out_image);
    void PreprocessImage(Mat &in_image, Mat&out_image);
    void HoughCircleDetection(const Mat& src_gray, const Mat& src_display, Mat &out_image);
    int  ProcessImage(const string &in_file, const string &out_file);
    
#ifdef __cplusplus
}
#endif
