//#include "stdafx.h"
#include <Windows.h>
#include <stdio.h>
#include <string.h>
HANDLE initialiseUART(DCB* SerialParams);

int main(void)
{
    HANDLE hComm;  // Handle to the Serial port
    BOOL   Status; // Status
    DCB dcbSerialParams = { 0 };  // Initializing DCB structure
    char SerialBuffer[1] = { 0 }; //Buffer to send and receive data
    DWORD BytesWritten = 0;          // No of bytes written to the port
    DWORD dwEventMask;     // Event mask to trigger
    char  ReadData = 'r';        //temperory Character
    DWORD NoBytesRead;     // Bytes read by ReadFile()
    unsigned char loop = 0;
    
    
    //Enter the com port id
    hComm = initialiseUART(&dcbSerialParams);


    printf_s("\n\nEnter your message: ");
    scanf_s("%s", SerialBuffer, (unsigned)_countof(SerialBuffer));
    //Writing data to Serial Port
    Status = WriteFile(hComm,// Handle to the Serialport
        SerialBuffer,            // Data to be written to the port
        sizeof(SerialBuffer),   // No of bytes to write into the port
        &BytesWritten,  // No of bytes written to the port
        NULL);
    if (Status == FALSE)
    {
        printf_s("\nFail to Written");
        goto Exit1;
    }
    //print numbers of byte written to the serial port
    printf_s("\nNumber of bytes written to the serail port = %d\n\n", BytesWritten);
    //Setting Receive Mask
    Status = SetCommMask(hComm, EV_RXCHAR);
    if (Status == FALSE)
    {
        printf_s("\nError to in Setting CommMask\n\n");
        goto Exit1;
    }
    //Setting WaitComm() Event
    Status = WaitCommEvent(hComm, &dwEventMask, NULL); //Wait for the character to be received
    if (Status == FALSE)
    {
        printf_s("\nError! in Setting WaitCommEvent()\n\n");
        goto Exit1;
    }
    //Read data and store in a buffer
    do
    {
        Status = ReadFile(hComm, &ReadData, sizeof(ReadData), &NoBytesRead, NULL);
        printf_s("\nRead Data: %c\n\n", ReadData);
        SerialBuffer[loop] = ReadData;
        ++loop;
    } while (NoBytesRead > 0);
    --loop; //Get Actual length of received data
    printf_s("\nNumber of bytes received = %d\n\n", loop);
    //print receive data on console
    printf_s("\n\n");
    int index = 0;
    for (index = 0; index < loop; ++index)
    {
        printf_s("%c", SerialBuffer[index]);
    }
    printf_s("\n\n");
Exit1:
    CloseHandle(hComm);//Closing the Serial Port
Exit2:
    system("pause");
    return 0;
}

void readData(void) {
    
}

int sendByte(char data, HANDLE hComm) {
    DWORD BytesWritten = 0;
    BOOL Status = WriteFile(hComm,// Handle to the Serialport
        data,            // Data to be written to the port
        sizeof(data),   // No of bytes to write into the port
        &BytesWritten,  // No of bytes written to the port
        NULL);
    if (Status == FALSE || BytesWritten == 0)
    {
        printf_s("\nFail to Written");
        return -1;
    }
}

HANDLE initialiseUART(DCB* SerialParams){
    BOOL   Status;
    HANDLE hComm;
    COMMTIMEOUTS timeouts = { 0 };  //Initializing timeouts structure
    wchar_t pszPortName[10] = { 0 }; //com port id
    wchar_t PortNo[20] = { 0 }; //contain friendly name

    printf_s("Enter the Com Port: ");
    wscanf_s(L"%s", pszPortName, (unsigned)_countof(pszPortName));
    swprintf_s(PortNo, 20, L"\\\\.\\%s", pszPortName);
    //Open the serial com port
    hComm = CreateFile(PortNo, //friendly name
        GENERIC_READ | GENERIC_WRITE,      // Read/Write Access
        0,                                 // No Sharing, ports cant be shared
        NULL,                              // No Security
        OPEN_EXISTING,                     // Open existing port only
        0,                                 // Non Overlapped I/O
        NULL);                             // Null for Comm Devices
    if (hComm == INVALID_HANDLE_VALUE)
    {
        printf_s("\n Port can't be opened\n\n");
        system("pause");
        exit(0);
    }
    //Setting the Parameters for the SerialPort
    SerialParams->DCBlength = sizeof(*SerialParams);
    Status = GetCommState(hComm, SerialParams); //retreives  the current settings
    if (Status == FALSE)
    {
        printf_s("\nError to Get the Com state\n\n");
        CloseHandle(hComm);//Closing the Serial Port
        system("pause");
        exit(0);
    }
    SerialParams->BaudRate = CBR_9600;      //BaudRate = 9600
    SerialParams->ByteSize = 8;             //ByteSize = 8
    SerialParams->StopBits = ONESTOPBIT;    //StopBits = 1
    SerialParams->Parity = ODDPARITY;      //Parity = None
    Status = SetCommState(hComm, SerialParams);
    if (Status == FALSE)
    {
        printf_s("\nError to Setting DCB Structure\n\n"); 
        CloseHandle(hComm);//Closing the Serial Port
        system("pause");
        exit(0);
    }
    //Setting Timeouts
    timeouts.ReadIntervalTimeout = 50;
    timeouts.ReadTotalTimeoutConstant = 50;
    timeouts.ReadTotalTimeoutMultiplier = 10;
    timeouts.WriteTotalTimeoutConstant = 50;
    timeouts.WriteTotalTimeoutMultiplier = 10;
    if (SetCommTimeouts(hComm, &timeouts) == FALSE)
    {
        printf_s("\nError to Setting Time outs");
        CloseHandle(hComm);//Closing the Serial Port
        system("pause");
        exit(0);
    }
    return hComm;
}