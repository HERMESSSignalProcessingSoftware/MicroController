/*
 * DAPI.h
 *
 *  Created on: Jun 5, 2020
 *      Author: jonas
 */
#include "cmsis_os.h"
#include "usart.h"
#include "stm32f7xx_hal.h"

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

#define DAPI_TRANSMISSION_RECEIVED_FLAG 0x00000001
#define DAPI_TRANSMISSION_FAILED_FLAG 0x00000002

#define MESSAGES_PER_PACKET 256

extern CRC_HandleTypeDef hcrc;

void DAPI_UART_TransmissionReceivedCallback(void);
void DAPI_UART_TransmissionFailedCallback(void);
void idle_WaitingForCommands(uint8_t * message);
void unknownMessageReceived(uint8_t * message);
void initializeReadingAllData(void);
void sendAcknowledge(void);
void sendErrorData(void);
void sendByte(uint8_t data);
void sendEOF(void);
void send4Bytes(uint32_t data);
void sendPacket(uint32_t address);
int readPage(uint8_t* data, uint32_t address);//Placeholder, will be removed later and be imported from storage

#ifndef INC_DAPI_H_
#define INC_DAPI_H_




#endif /* INC_DAPI_H_ */
