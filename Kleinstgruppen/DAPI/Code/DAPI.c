/*
 * DAPI.c
 *
 *  Created on: Jun 5, 2020
 *  @Authors: Jonas Schmucker, Sebastian Heinrich, Tom Haas
 */

#include "DAPI.h"
#include "stm32f7xx_hal.h"
//#include "stm32f7xx_hal_uart.c"

//global buffer variable for saving received messages
uint8_t message;


/*
 * DAPI_Thread
 * Thread for DAPI that is mostly in an Idle state waiting for commands from the workstation
 * @param arg: Not used
 */
void DAPI_Thread(void * arg){
	 //HAL_UART_RegisterCallback(&huart5, HAL_UART_RX_COMPLETE_CB_ID, DAPI_UART_TransmissionReceivedCallback);

	message = 0;
	osThreadId_t DAPI_Thread_ID = osThreadGetId();
	for(;;){
		HAL_UART_Receive_IT(&huart5, &message, 1);
			idle_WaitingForCommands(&message);
	}
}
/*
 * idle_WaitingForCommands
 * Waits for a command and interprets this command in order to (for example) output data
 * @param message: pointer to the received message(1 Byte)
 *
 */
void idle_WaitingForCommands(uint8_t * message){
	uint32_t flags = osThreadFlagsWait(DAPI_TRANSMISSION_RECEIVED_FLAG | DAPI_TRANSMISSION_FAILED_FLAG , osFlagsWaitAny, osWaitForever);
	if(flags & 0x80000000){
		//Error state
	}
	else if(flags & DAPI_TRANSMISSION_RECEIVED_FLAG){
		switch (*message){
			case READ_ALL:
				initializeReadingAllData();
				break;
			default:
				unknownMessageReceived(message);
				break;
		}
	}
	else if(flags & DAPI_TRANSMISSION_FAILED_FLAG){
		sendErrorData();
	}
}

/*
 * unknownMessageReceived
 * Error handling for when an unexpected or even unknown command is Received
 * @param message: pointer to the received message(1 Byte)
 *
 */
void unknownMessageReceived(uint8_t * message){
	sendByte(DATA_ERR);
}

void initializeReadingAllData(void){
	uint32_t firstPage [64] = {0};
	if(readPage((uint8_t *) firstPage, 0x00000000)){
		//Error Handling, storage could not be accessed
	}
	uint32_t firstAdress = firstPage[0];
	uint32_t lastAdress = firstPage[1];
	int TotalCountBytes = lastAdress - firstAdress;

	send4Bytes(TotalCountBytes); //sends the Total number of bytes in storage to workstation

	HAL_UART_Receive_IT(&huart5, &message, 1);
	uint32_t flags = osThreadFlagsWait(DAPI_TRANSMISSION_RECEIVED_FLAG | DAPI_TRANSMISSION_FAILED_FLAG , osFlagsWaitAny, osWaitForever);
	if(flags & 0x80000000){
		//Error state
	}
	else if(flags & DAPI_TRANSMISSION_RECEIVED_FLAG){
		switch (message){
			case ACKNOWLEDGED:
				break;
			case DATA_ERR:
				//TODO Transmission failed state, crc or Parity wrong, restart sending data
				break;
			default:
				unknownMessageReceived(&message);
				break;
		}
	}
	else if(flags & DAPI_TRANSMISSION_FAILED_FLAG){
		sendErrorData();
	}


	int TotalCountPages = TotalCountBytes / 256 + 1;//plus one for additional incompletely filled page


	for(int i = 0; i < TotalCountPages; i++){
		sendPacket(firstAdress + i * 256);
		HAL_UART_Receive_IT(&huart5, &message, 1);
		uint32_t flags = osThreadFlagsWait(DAPI_TRANSMISSION_RECEIVED_FLAG | DAPI_TRANSMISSION_FAILED_FLAG , osFlagsWaitAny, osWaitForever);
		if(flags & 0x80000000){
			return; //Transmission is interrupted
		}
		else if(flags & DAPI_TRANSMISSION_RECEIVED_FLAG){
			switch (message){
				case ACKNOWLEDGED:
					break;
				case DATA_ERR:
					//Transmission failed state, crc or Parity wrong, restart sending data
					i--;
					break;
				default:
					return;//Transmission is interrupted
			}
		}
		else if(flags & DAPI_TRANSMISSION_FAILED_FLAG){
			return;//Transmission is interrupted
		}
	}


}

/*
 * sendPacket
 * sends a Packet with a set ammount of Bytes to the workstation. This is defined in DAPI.h, MESSAGES_PER_PACKET.
 * The 32Bit-checksum that is calculated using the data contained in the packet is sent afterwards, to insure data validity
 *
 */
void sendPacket(uint32_t address){
	uint8_t dataBuffer [256] = {0};
	uint32_t crcResult = HAL_CRC_Calculate(&hcrc, (uint32_t *)dataBuffer, MESSAGES_PER_PACKET / 4);
	//TODO Speicher
	if(readPage(dataBuffer, address)){
		//Error Handling, storage could not be accessed
	}
	for(int i = 0;i < MESSAGES_PER_PACKET; i++){
		sendByte(dataBuffer[i]);
	}
	send4Bytes(crcResult);
}


/*
 * sendAcknowledge
 * sends the ACKNOWLEDGE (defined in DAPI.h) command to the workstation
 */
void sendAcknowledge(void){
	sendByte(ACKNOWLEDGED);
}

/*
 * sendErrorData
 * sends the DATA_ERR (defined in DAPI.h) command to the workstation
 */
void sendErrorData(void){
	sendByte(DATA_ERR);
}

/*
 * sendEOF
 * sends the DAPI_EOF (defined in DAPI.h) command to the workstation
 */
void sendEOF(void){
	sendByte(DAPI_EOF);
}

/*
 * send4Bytes
 * sends 4 Bytes to the workstation, starting with the MSB
 * @param data: The 32Bit value to be  sent
 */
void send4Bytes(uint32_t data){
	uint8_t data1 = (data & 0xFF000000) << 0;
	uint8_t data2 = (data & 0x00FF0000) << 8;
	uint8_t data3 = (data & 0x0000FF00) << 16;
	uint8_t data4 = (data & 0x000000FF) << 24;
	sendByte(data1);
	sendByte(data2);
	sendByte(data3);
	sendByte(data4);
}

/*
 * sendByte
 * sends 1 Byte to the workstation
 * @param data: The 8Bit value to be  sent
 */
void sendByte(uint8_t data){
	HAL_UART_Transmit(&huart5, &data, 1, 10);
}
