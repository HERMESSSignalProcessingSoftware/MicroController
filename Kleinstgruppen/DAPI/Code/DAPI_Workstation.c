//#include "stdafx.h"
#include "DAPI_Workstation.h"
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

void readData(HANDLE * hComm) {
    sendByte(READ_ALL, *hComm);
    initializeReceiveUART(hComm);
    char Bytescount1 = receiveData(hComm);
    char Bytescount2 = receiveData(hComm);
    char Bytescount3 = receiveData(hComm);
    char Bytescount4 = receiveData(hComm);
    unsigned int Bytescount = 0;
    Bytescount += Bytescount1;
    Bytescount = Bytescount << 8;
    Bytescount += Bytescount2;
    Bytescount = Bytescount << 8;
    Bytescount += Bytescount3;
    Bytescount = Bytescount << 8;
    Bytescount += Bytescount4;
    sendByte(ACKNOWLEDGED, *hComm);
    FILE* outFile = fopen(OUTFILENAME, "rw");
    char buffer [256] = {0};
    for (int i = 0; i < Bytescount / 256 + 1; i++) {
        for (int o = 0; o < 256; o++) {
            buffer[o] = receiveData(hComm);
        }
        char Checksum1 = receiveData(hComm);
        char Checksum2 = receiveData(hComm);
        char Checksum3 = receiveData(hComm);
        char Checksum4 = receiveData(hComm);
        unsigned int Checksum = 0;
        Checksum += Checksum1;
        Checksum = Checksum << 8;
        Checksum += Checksum2;
        Checksum = Checksum << 8;
        Checksum += Checksum3;
        Checksum = Checksum << 8;
        Checksum += Checksum4;
        
        //crcInit();
        if (Checksum != 1/*TODO checksum calculation*/) {
            printf("Checksum not valid, aborting transmission (Page: %d)", i);
            fclose(outFile);
            break;
        }
        if (i == Bytescount / 256) { // Last Page
            for (int p = 0; p < Bytescount % 256; p++) {
                fprintf(outFile, "%c", buffer[p]);
                fclose(outFile);
                printf("Data downloaded successfully");
            }

        }
        else {                      //Not last Page
            for (int p = 0; p < 256; p++) {
                fprintf(outFile, "%c", buffer[p]);
            }
        }
        sendByte(ACKNOWLEDGED, *hComm);
    }
}

char receiveData(HANDLE* hComm) {
    char temp = 0;
    int NumberOfBytesRead = 0;
    BOOL Status = ReadFile(*hComm, &temp, sizeof(temp), &NumberOfBytesRead, NULL);
    return temp;
}

void initializeReceiveUART(HANDLE * hComm) {
    DWORD dwEventMask;     // Event mask to trigger
    BOOL Status = SetCommMask(*hComm, EV_RXCHAR);
    if (Status == FALSE)
    {
        printf_s("\nError to in Setting CommMask\n\n");
        CloseHandle(*hComm);//Closing the Serial Port
        system("pause");
        return 0;
    }
    //Setting WaitComm() Event
    Status = WaitCommEvent(*hComm, &dwEventMask, NULL); //Wait for the character to be received
    if (Status == FALSE)
    {
        printf_s("\nError! in Setting WaitCommEvent()\n\n");
        CloseHandle(*hComm);//Closing the Serial Port
        system("pause");
        return 0;
    }
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

HANDLE initializeUART(DCB* SerialParams){
    BOOL   Status;
    HANDLE hComm;
    COMMTIMEOUTS timeouts = { 0 };  //Initializing timeouts structure
    wchar_t pszPortName[10] = { 0 }; //com port id
    wchar_t PortNo[20] = { 0 }; //contain friendly name

    printf_s("Enter the Com Port: ");
    wscanf_s(L"%ls", pszPortName, (unsigned)_countof(pszPortName));
    swprintf_s(PortNo, 20, L"\\\\.\\%ls", pszPortName);
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