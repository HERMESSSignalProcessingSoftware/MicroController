/*
 * DAPI.h
 *
 *  Created on: Jun 5, 2020
 *      Author: Jonas Schmucker, Tom Haas, Sebastian Heinrich
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
#define WRITE 			0x0F //request for writing specific data
#define START_TESTING	0x11 //command to notify that testing has started
#define RESET_STORAGE	0x13 //Clears the entire storage
#define RESET 			0x15 //used for resetting the MCU


#define DAPI_TRANSMISSION_RECEIVED_FLAG 0x00000001
#define DAPI_TRANSMISSION_FAILED_FLAG 0x00000002

#define MESSAGES_PER_PACKET 256

extern CRC_HandleTypeDef hcrc;


/*
 * DAPI_Thread
 * Thread for DAPI that is mostly in an Idle state waiting for commands from the workstation
 * @param arg: Not used
 */
void DAPI_Thread(void * arg);

/*
 * idle_WaitingForCommands
 * Waits for a command and interprets this command in order to (for example) output data
 * @param message: pointer to the received message(1 Byte)
 *
 */
void idle_WaitingForCommands(uint8_t * message);

/*
 * This function sets the global variable testModeState to 1, so other Threads can access the informaton
 * */
void initializeTesting(void);

/*
 * This function resets the whole storage
 * */
void initializeResetingStorage(void);

/*
 * Called after the RESET command, resets the MCU after ACKNOWLEDGED command is sent
 * */
void initializeReset(void);

/*
 * unknownMessageReceived
 * Error handling for when an unexpected or even unknown command is Received
 * @param message: pointer to the received message(1 Byte)
 *
 */
void unknownMessageReceived(uint8_t * message);

/*
 * Reads all data from storage and send it to the workstation
 * */
void initializeReadingAllData(void);
/*
 * sendPacket
 * sends a Packet with a set ammount of Bytes to the workstation. This is defined in DAPI.h, MESSAGES_PER_PACKET.
 * The 32Bit-checksum that is calculated using the data contained in the packet is sent afterwards, to insure data validity
 *
 */
void sendPacket(uint32_t address);


/*
 * sendAcknowledge
 * sends the ACKNOWLEDGE (defined in DAPI.h) command to the workstation
 */
void sendAcknowledge(void);

/*
 * sendErrorData
 * sends the DATA_ERR (defined in DAPI.h) command to the workstation
 */
void sendErrorData(void);

/*
 * sendEOF
 * sends the DAPI_EOF (defined in DAPI.h) command to the workstation
 */
void sendEOF(void);

/*
 * send4Bytes
 * sends 4 Bytes to the workstation, starting with the MSB
 * @param data: The 32Bit value to be  sent
 */
void send4Bytes(uint32_t data);

/*
 * sendByte
 * sends 1 Byte to the workstation
 * @param data: The 8Bit value to be  sent
 */
void sendByte(uint8_t data);


int readPage(uint8_t* data, uint32_t address);//Placeholder, will be removed later and be imported from storage


#ifndef INC_DAPI_H_
#define INC_DAPI_H_




#endif /* INC_DAPI_H_ */
