#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "binarytools.h"

/**
 * @brief Create a List object from the byte array read form the file
 * 
 * @param rawDataPtr Pointer to an array of bytes
 * @return DatasetList_t* First element of the dataset
 */
DatasetList_t * CreateList(uint8_t *rawDataPtr) {
    DatasetList_t *head;
    DatasetList_t *tail;
    uint32_t *rawData32bitPtr = (uint32_t *)rawDataPtr;
    if (rawDataPtr) {
        /* Check if the content of the memory dump is valid*/
        if (*rawData32bitPtr == 0xFFFFFFFF) {
            return NULL; // Not valid
        } else {
            head = (DatasetList_t*)malloc(sizeof(DatasetList_t));
            memset(head, 0, sizeof(DatasetList_t));
            tail = head;
            for (uint32_t i = 0; i < 8; i++) {
                memcpy(&head->dataset, rawData32bitPtr, 15 * 4);
                rawData32bitPtr += 15;
            }
            return head;
        }
    }
    return NULL;
}

/**
 * @brief Searches the last item
 * 
 * @param list DatasetList_t ptr
 * @return DatasetList_t* Pointer to the last list item
 */
DatasetList_t* LastItem(DatasetList_t *list) {
    DatasetList_t *ptr = list;
    if (ptr) {
        while (ptr->next != NULL) {
            ptr = ptr->next;
        }
        return ptr;
    }
    return NULL;
}

/**
 * @brief Appends a list to an existing list of datasets
 * 
 * @param mainListLastItem The Pointer to the last list item
 * @param append the start Pointer of the new list
 * @return DatasetList_t* Pointer to the last item of the concationated list. 
 */
DatasetList_t * AppendToList(DatasetList_t *mainListLastItem, DatasetList_t *append) {
    if (mainListLastItem && append) {
        mainListLastItem->next = append;
        return LastItem(append);
    }
    return NULL;
}

int main(int argc, char ** arcv) {
    FILE *inputFilePtr = NULL;
    FILE *outputFilePtr = NULL;
    FILE *logFile = NULL;
    uint8_t *readingBuffer = (uint8_t*)malloc(512);
    DatasetList_t *start = NULL;
    if (readingBuffer == NULL) {
        printf("ERROR: BUFFER not avialable!\n");
        exit(1);
    }
    if (argc == 0) { // no parameter given -> normal function

    } else {
        for (uint32_t i = 1; i < argc; i++) {
            if (strncmp(arcv[i],"-i", 2) || strncmp(arcv[i], "--input", 7)) {
                if ((i + 1) < argc) {
                    printf("Inputfile: %s\n", arcv[i + 1]);
                    inputFilePtr =  fopen(arcv[i + 1], "rb");
                    if (inputFilePtr == NULL) {
                        printf("Error opening file!\n");
                    }
                    i = i + 1; // increase counter to not parse it again
                } else {
                    printf("ERROR: Inputfile missing!\n");
                }  
            } else if (strncmp(arcv[i], "-o", 2) || strncmp(arcv[i], "--output", 8)) {
                if ((i + 1) < argc) {
                    printf("Outputfile: %s\n", arcv[i + 1]);
                    outputFilePtr = fopen(arcv[i + 1], "w");
                    if (outputFilePtr == NULL) {
                        printf("Error opening outputfile!\n");
                    }
                    i++;
                } else {
                    printf("ERROR: Outputfile missing!\n");
                }
            } else if (strncmp(arcv[i], "-l", 2) || strncmp(arcv[i], "--log", 5)) {
                if ((i + 1) < argc) {
                    printf("Logfile: %s\n", arcv[i + 1]);
                    logFile = fopen(arcv[i + 1], "w");
                    if (logFile == NULL) {
                        printf("Error opening logfile!\n");
                    }
                    i++;
                } else {
                    printf("ERROR: Logfile missing!\n");
                }
            }

        }
    }
    if (inputFilePtr) {
        fseek(inputFilePtr, 0, SEEK_END);
        size_t size = ftell(inputFilePtr);
        uint32_t pages = size / 512;
        printf("%li bytes = %.1f pages.\n", size, (double)size / 512.0);
        fseek(inputFilePtr, 0, SEEK_SET);
        //while(!feof(inputFilePtr)) {
            fread(readingBuffer, 512, 1, inputFilePtr);
            start = CreateList(readingBuffer);
        //}
        
    } 
    /* Clean up */
    if (inputFilePtr)
        fclose(inputFilePtr);
    if (outputFilePtr)
        fclose(outputFilePtr);
    if (logFile)
        fclose(logFile);
    if (readingBuffer) 
        free(readingBuffer);
    if (start)
        free(start);
    return 0;
}