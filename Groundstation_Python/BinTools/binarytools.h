#ifndef __BINARYTOOLS_H__
#define __BINARYTOOLS_H__

typedef struct {
    uint32_t timestamp;
    uint32_t STAMP_1_1;
    uint32_t STAMP_1_2;
    uint32_t STAMP_2_1;
    uint32_t STAMP_2_2;
    uint32_t STAMP_3_1;
    uint32_t STAMP_3_2;
    uint32_t STAMP_4_1;
    uint32_t STAMP_4_2;
    uint32_t STAMP_5_1;
    uint32_t STAMP_5_2;
    uint32_t STAMP_6_1;
    uint32_t STAMP_6_2;
    uint32_t StatusReg1;
    uint32_t StatusReg2;
} Dataset_t;

typedef struct { 
    Dataset_t *next; 
    Dataset_t dataset; 
} DatasetList_t;

#endif 