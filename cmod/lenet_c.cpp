#include <opencv2/opencv.hpp>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
using namespace cv;
using namespace std;


//Change 3d to 1d
void change(int channel, int output_size, double *output, double ***input){
	for(int n=0; n<channel; n++){
		for(int i=0; i<output_size; i++){
			for(int j=0; j<output_size; j++){
				*(output+n*output_size*output_size+i*output_size+j) = *(*(*(input+n)+i)+j);
			}
		}
	}
}
//Fully Connected
void fc(int input_size, int output_size, double *output, double *input, double **weight, double *bias){
    for(int i=0; i<output_size; i++){
		for(int j=0; j<input_size; j++){
			output[i] += input[j] * weight[i][j] + bias[i];
		}
	}
}

//ReLu Activation
void relu_act(int input_size, double *output, double *input){
	for(int i=0; i<input_size; i++){
		if(input[i]<0){ 
            output[i] = 0;
        }
        else{
            output[i] = input[i];
        }
    }
}

//SoftMax Activation
void softmax_act(int input_size, double *output, double *input){
	double max = 0;
	double sum = 0;

	for(int i=0; i<input_size; i++){
		if(max<input[i]){		
			max = input[i];
		}
	}
	for(int i=0; i<input_size; i++){
		input[i] = exp(input[i] - max);
		sum = sum + input[i];
	}
	for(int i=0; i<input_size; i++){
		output[i] = input[i] / sum;
	} 
}

//Convolution
void conv(int nfilter, int output_size, int channel, int f_size, int stride, double ***output, double ***input, double ****weight, double *bias){
    for(int m=0; m<nfilter; m++){
		for(int x=0; x<output_size; x++){
			for(int y=0; y<output_size; y++){
				for(int n=0; n<channel; n++){
					for(int i=0; i<f_size; i++){
						for(int j=0; j<f_size; j++){
							*(*(*(output+m)+x)+y) += *(*(*(input+n)+(i+x*stride))+(j+y*stride)) * *(*(*(*(weight+m)+n)+i)+j);
						}			
					}
				}
                *(*(*(output+m)+x)+y) += *(bias+m);
			}
		}
	}
}

//Pooling
void pooling(int nfilter, int output_size, int channel, int f_size, int stride, double ***output, double ***input){
    double max=INT_MIN;
    
    for(int m=0; m<nfilter; m++){
		for(int x=0; x<output_size; x++){
			for(int y=0; y<output_size; y++){
				for(int n=0; n<channel; n++){
                    max=INT_MIN;
					for(int i=0; i<f_size; i++){
						for(int j=0; j<f_size; j++){
							if(max<*(*(*(input+m)+(i+x*stride))+(j+y*stride))){
								max = *(*(*(input+m)+(i+x*stride))+(j+y*stride));
                            }
						}
					}
				    *(*(*(output+m)+x)+y) = max;
				}
			}
		}
	}
}


int main(){
    //////변수 선언//////

    //크기
    int nfilter, channel, f_size;
    int row, col;
    int input_size, output_size;
    int stride;
    //기타
    char ki;
    int a,b,c,d;
    Mat image;
    //input & output 
    double ***input;
    double ***output_conv1;
    double ***output_pooling1;
    double ***output_conv2;
    double ***output_pooling2;
    double *output_change;
    double *output_fc1;
    double *output_relu;
    double *output_fc2;
    double *output_softmax;
    //weight & bias
    double ****w_conv1;
    double ****w_conv2;
    double **w_fc1;
    double **w_fc2;
    double *b_conv1;
    double *b_conv2;
    double *b_fc1;
    double *b_fc2;


    //////메모리 동적 할당//////

    //input 
    channel = 1;
    row = 28;
    col = 28;

    input = (double***)malloc(channel*sizeof(double**));
    for(int i=0; i<channel; i++){
        *(input+i) = (double**)malloc(row*sizeof(double*));
        for(int j=0; j<row; j++){
            *(*(input+i)+j) = (double*)malloc(col*sizeof(double));
        }
    }
    //output_conv1
    channel = 20;
    row = 24;
    col = 24;
    output_conv1 = (double***)malloc(channel*sizeof(double**));
    for(int i=0; i<channel; i++){
        *(output_conv1+i) = (double**)malloc(row*sizeof(double*));
        for(int j=0; j<row; j++){
            *(*(output_conv1+i)+j) = (double*)malloc(col*sizeof(double));
        }
    }
    //output_pooling1
    channel = 20;
    row = 12;
    col = 12;

    output_pooling1 = (double***)malloc(channel*sizeof(double**));
    for(int i=0; i<channel; i++){
        *(output_pooling1+i) = (double**)malloc(row*sizeof(double*));
        for(int j=0; j<row; j++){
            *(*(output_pooling1+i)+j) = (double*)malloc(col*sizeof(double));
        }
    }
    //output_conv2
    channel = 50;
    row = 8;
    col = 8;
    output_conv2 = (double***)malloc(channel*sizeof(double**));
    for(int i=0; i<channel; i++){
        *(output_conv2+i) = (double**)malloc(row*sizeof(double*));
        for(int j=0; j<row; j++){
            *(*(output_conv2+i)+j) = (double*)malloc(col*sizeof(double));
        }
    }
    //output_pooling2
    channel = 50;
    row = 4;
    col = 4;

    output_pooling2 = (double***)malloc(channel*sizeof(double**));
    for(int i=0; i<channel; i++){
        *(output_pooling2+i) = (double**)malloc(row*sizeof(double*));
        for(int j=0; j<row; j++){
            *(*(output_pooling2+i)+j) = (double*)malloc(col*sizeof(double));
        }
    }
    //output_change
    output_size = 800;
    output_change = (double*)malloc(output_size*sizeof(double));
    //output_fc1
    output_size = 500;
    output_fc1 = (double*)malloc(output_size*sizeof(double));
    //output_relu
    output_size = 500;
    output_relu = (double*)malloc(output_size*sizeof(double));
    //output_fc2
    output_size = 10;
    output_fc2 = (double*)malloc(output_size*sizeof(double));
    //output_softmax
    output_size = 10;
    output_softmax = (double*)malloc(output_size*sizeof(double));

    //w_conv1
    nfilter = 20;
    channel = 1;
    f_size = 5;

    w_conv1 = (double****)malloc(nfilter*sizeof(double***));
    for(int i=0; i<nfilter; i++){
		*(w_conv1+i) = (double***)malloc(channel*sizeof(double**));
		for(int j=0; j<channel; j++){
			*(*(w_conv1+i)+j) = (double**)malloc(f_size*sizeof(double*));
			for(int k=0; k<f_size; k++){
				*(*(*(w_conv1+i)+j)+k) = (double*)malloc(f_size*sizeof(double));
			}
		}
	}
    //w_conv2
    nfilter = 50;
    channel = 20;
    f_size = 5;

    w_conv2 = (double****)malloc(nfilter*sizeof(double***));
    for(int i=0; i<nfilter; i++){
		*(w_conv2+i) = (double***)malloc(channel*sizeof(double**));
		for(int j=0; j<channel; j++){
			*(*(w_conv2+i)+j) = (double**)malloc(f_size*sizeof(double*));
			for(int k=0; k<f_size; k++){
				*(*(*(w_conv2+i)+j)+k) = (double*)malloc(f_size*sizeof(double));
			}
		}
	}
    //w_fc1
    input_size = 800;
    output_size = 500;

    w_fc1 = (double**)malloc(output_size*sizeof(double*));
	for(int i=0; i<output_size; i++){
		*(w_fc1+i) = (double*)malloc(input_size*sizeof(double));
	}
    //w_fc2
    input_size = 500;
    output_size = 10;

    w_fc2 = (double**)malloc(output_size*sizeof(double*));
	for(int i=0; i<output_size; i++){
		*(w_fc2+i) = (double*)malloc(input_size*sizeof(double));
	}
    //b_conv1
    output_size = 20;    
    b_conv1 = (double*)malloc(output_size*sizeof(double));
    //b_conv2
    output_size = 50;
    b_conv2 = (double*)malloc(output_size*sizeof(double));
    //b_fc1
    output_size = 500;
    b_fc1 = (double*)malloc(output_size*sizeof(double));
    //b_fc2
    output_size = 10;
    b_fc2 = (double*)malloc(output_size*sizeof(double));


    //////weight & bias 값//////

    //file read
    FILE *fp1;
	FILE *fp2;
	FILE *fp3;
	FILE *fp4;
	FILE *fp5;
	FILE *fp6;
	FILE *fp7;
	FILE *fp8;

    fp1 = fopen("./txt/w_conv1.txt","r");
	fp2 = fopen("./txt/w_conv2.txt","r");
	fp3 = fopen("./txt/w_fc1.txt","r");
	fp4 = fopen("./txt/w_fc2.txt","r");
	fp5 = fopen("./txt/b_conv1.txt","r");
	fp6 = fopen("./txt/b_conv2.txt","r");
	fp7 = fopen("./txt/b_fc1.txt","r");
	fp8 = fopen("./txt/b_fc2.txt","r");

    //w_conv1
    nfilter = 20;
    channel = 1;
    f_size = 5;

    for(a=0; a<nfilter; a++){
		for(b=0; b<channel; b++){
			for(c=0; c<f_size; c++){
				for(d=0; d<f_size; d++){
					fscanf(fp1, "%lf", (*(*(*(w_conv1+a)+b)+c)+d));					
				}
			}
		}
	}
    //w_conv2
    nfilter = 50;
    channel = 20;
    f_size = 5;

	for(a=0; a<nfilter; a++){
		for(b=0; b<channel; b++){
			for(c=0; c<f_size; c++){
				for(d=0; d<f_size; d++){
				fscanf(fp2, "%lf", (*(*(*(w_conv2+a)+b)+c)+d));					
				}
			}
		}
	}
    //w_fc1
    input_size = 800;
    output_size = 500;

	for(a=0; a<output_size; a++){
		for(b=0; b<input_size; b++){
			fscanf(fp3, "%lf", (*(w_fc1+a)+b));					
		}
	}
    //w_fc2
    input_size = 500;
    output_size = 10;

	for(a=0; a<output_size; a++){
		for(b=0; b<input_size; b++){
			fscanf(fp4, "%lf", (*(w_fc2+a)+b));					
		}
	}
    //b_conv1
    output_size = 20;

	for(a=0; a<output_size; a++){
		fscanf(fp5, "%lf", b_conv1+a);
	}
    //b_conv2
    output_size = 50;

	for(a=0; a<output_size; a++){
		fscanf(fp6, "%lf", b_conv2+a);
	}
    //b_fc1
    output_size = 500;

	for(a=0; a<output_size; a++){
		fscanf(fp7, "%lf", b_fc1+a);
	}
    //b_fc2
    output_size = 10;

	for(a=0; a<output_size; a++){
		fscanf(fp8, "%lf", b_fc2+a);
	}

    
    //////input 값//////

    //image 읽기
    image = imread("./jpg/88x.png",IMREAD_GRAYSCALE);
	if(image.empty()){
		cout<<"Could not open or find the image" <<endl;
		return -1;
	}
    
    //input
    channel = 1;
	for(int i=0; i<channel; i++){
		for(int j=0; j<image.rows; j++){
			for(int k=0; k<image.cols; k++){
				*(*(*(input+i)+j)+k) = image.at<uchar>(j,k);
			}
		}
	}


    //////연산//////

    //conv1
    nfilter = 20;
    output_size = 24;
    channel = 1;
    f_size = 5;
    stride = 1;
    conv(nfilter, output_size, channel, f_size, stride, output_conv1, input, w_conv1, b_conv1);
    //pooling1
    nfilter = 20;
    output_size = 12;
    channel = 1;
    f_size = 2;
    stride = 2;
    pooling(nfilter, output_size, channel, f_size, stride, output_pooling1, output_conv1);
    //conv2
    nfilter = 50;
    output_size = 8;
    channel = 20;
    f_size = 5;
    stride = 1;
    conv(nfilter, output_size, channel, f_size, stride, output_conv2, output_pooling1, w_conv2, b_conv2);
    //pooling2
    nfilter = 50;
    output_size = 4;
    channel = 1;
    f_size = 2;
    stride = 2;
    pooling(nfilter, output_size, channel, f_size, stride, output_pooling2, output_conv2);
    //change
    channel = 50;
    output_size = 4;
    change(channel, output_size, output_change, output_pooling2);
    //fc1
    input_size = 800;
	output_size = 500;
    fc(input_size, output_size, output_fc1, output_change, w_fc1, b_fc1);
    //relu
    input_size = 500;
	relu_act(input_size, output_relu, output_fc1);
    //fc2
    input_size = 500;
	output_size = 10;
    fc(input_size, output_size, output_fc2, output_relu, w_fc2, b_fc2);


	//softmax
    input_size = 10;
    softmax_act(input_size, output_softmax, output_fc2);	


    //////결과//////

    //result print
	for(int i=0; i<input_size; i++){
		printf("[%d] %.5lf \n", i , *(output_softmax+i));
	}


    //////free//////

    //input 
    channel = 1;
    row = 28;
    
    for(int i=0; i<channel; i++){
		 for(int j=0; j<row; j++){
			free(*(*(input+i)+j));
		}
		free(*(input+i));
	}
	free(input);
    //output_conv1
    channel = 20;
    row = 24;

    for(int i=0; i<channel; i++){
		 for(int j=0; j<row; j++){
			free(*(*(output_conv1+i)+j));
		}
		free(*(output_conv1+i));
	}
	free(output_conv1);
    //output_pooling1
    channel = 20;
    row = 12;

    for(int i=0; i<channel; i++){
		 for(int j=0; j<row; j++){
			free(*(*(output_pooling1+i)+j));
		}
		free(*(output_pooling1+i));
	}
	free(output_pooling1);
    //output_conv2
    channel = 50;
    row = 8;

    for(int i=0; i<channel; i++){
		 for(int j=0; j<row; j++){
			free(*(*(output_conv2+i)+j));
		}
		free(*(output_conv2+i));
	}
	free(output_conv2);
    //output_pooling2
    channel = 50;
    row = 4;

    for(int i=0; i<channel; i++){
		 for(int j=0; j<row; j++){
			free(*(*(output_pooling2+i)+j));
		}
		free(*(output_pooling2+i));
	}
	free(output_pooling2);
    //output_change
    free(output_change);
    //output_fc1
    free(output_fc1);
    //output_relu
    free(output_relu);    
    //output_fc2
    free(output_fc2);
    //output_softmax
    free(output_softmax);
    
    //w_conv1
    nfilter = 20;
    channel = 1;
    f_size = 5;

    for(int i=0; i<nfilter; i++){
		 for(int j=0; j<channel; j++){
			for(int k=0; k<f_size; k++){
				free(*(*(*(w_conv1+i)+j)+k));		
			}
			free(*(*(w_conv1+i)+j));
		}
		free(*(w_conv1+i));
	}
	free(w_conv1);
    //w_conv2
    nfilter = 50;
    channel = 20;
    f_size = 5;

    for(int i=0; i<nfilter; i++){
		 for(int j=0; j<channel; j++){
			for(int k=0; k<f_size; k++){
				free(*(*(*(w_conv2+i)+j)+k));		
			}
			free(*(*(w_conv2+i)+j));
		}
		free(*(w_conv2+i));
	}
	free(w_conv2);
    //w_fc1
    output_size = 500;

    for(int i=0; i<output_size; i++){
        free(*(w_fc1+i));
    }
    free(w_fc1);
    //w_fc2
    output_size = 10;

    for(int i=0; i<output_size; i++){
        free(*(w_fc2+i));
    }
    free(w_fc2);
    //b_conv1
    free(b_conv1);        
    //b_conv2
    free(b_conv2);   
    //b_fc1
    free(b_fc1);
    //b_fc2
    free(b_fc2);


    return 0;
}