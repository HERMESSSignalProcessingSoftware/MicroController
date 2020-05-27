# Datahandling

There are 12 16 bit analog digital converters (ADC) at the signal processing unit. 
Each ADC is working with 2ksps which leads to a conversion time of 5 10^-4s. As we have 2000 samples per second the datarate of one ADC is 16 times the sample rate, which is 32kbit/s per ADC. In addition there is a total datarate of 384000 bits / s. 

The telemetry is able to handle a datarate of 30kbit/s so we need reduce the datasize. 

To transmit the data back to earth it is neccessarry to format the data. Each frame will be with a light header and with the data. The header will be filled with a frame number and a system status field. The header will be 8 byte long. The data field will contain the data of the strain gauges first after that there will be the temperature. The data field is 24 byte long. 

One frame will be 32 byte (256 bit) long. 

So we are able to transmit 117,18 frames per second. (30kbits divided by 256). Due to technical restrictions there we have to select a slightly lower number. We need to select every 116th measurment result and transmit it back to earth. There will be no data compression. 



### Dataformat
| Framenumber  |
| ------------ |
| Systemstatus |
| data[24]     |
|              |

