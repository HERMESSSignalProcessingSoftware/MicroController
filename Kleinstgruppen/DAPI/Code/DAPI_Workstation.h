
#include <Windows.h>
#include <stdio.h>
#include <string.h>

#define READ_ALL 		0x01 //request for sending all available data
#define ACKNOWLEDGED	0x03 //positive answer
#define STILL_AWAKE		0x05 //check, if workstation is still listening
#define DAPI_EOF		0x07 //end of file
#define DATA_ERR		0x09 //error in parity bit, or CRC, can be an answer to STILL_AWAKE or EOF results in all the data transmissions since the last check, being sent again
//#define PLACEHOLDER 	0x0B //placeholder for configuration command
//#define PLACEHOLDER 	0x0D //placeholder for configuration command
//#define PLACEHOLDER 	0x0F //placeholder for configuration command
//#define PLACEHOLDER 	0x11 //placeholder for configuration command
//#define PLACEHOLDER 	0x13 //placeholder for configuration command
#define RESET 			0x15 //used for resetting the MCU
#define OUTFILENAME "C:\\Users\\jonas\\source\\repos\\DAPI_Workstation\\out.bin"

void readData(HANDLE * hComm);
int sendByte(char data, HANDLE hComm);
HANDLE initializeUART(DCB* SerialParams);
void initializeReceiveUART(HANDLE* hComm);
char receiveData(HANDLE* hComm);