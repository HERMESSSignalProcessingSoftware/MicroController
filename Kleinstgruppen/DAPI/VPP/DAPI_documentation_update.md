1.1.0

The connection uses a baud rate of 9600 baud. One transmission consists of 8 data bits and one parity bit. Here, odd parity is used. After 30 transmissions the MCU checks whether the workstation is still receiving and has not encountered any errors.  During this check, a cyclic redundancy check is used to provide a more secure data validation, by summing up the transmited data and comparing the results to the expected transmitted value.
An overview of all command codes is found in the “command_codes” document.

The 8th bit in each transmission is used to escape all data transmissions from the command codes. This results in all command codes ending with a 1, and all data transmissions with a zero. This way, the 7th data bit represents the MSB and the first bit the LSB.

In the case that a STILL_AWAKE command is answered by a DATA_ERR command, the MCU will interpret this as an error in data transmission and will resend all data since the last confirmed correct transmission. This process will repeat until the packet of 32 transmissions is received correctly.

The same procedure will also be used if an EOF command is answered by DATA_ERR command. In this case the amount of repeated data transmissions may be less than 32.

All the configuration commands and the RESET command will be waiting for an ACKNOWLEDGED command from the MCU. If this ACKNOWLEDGED command is not received after a timeout, the command is sent again.

The UART Interface is simulated with a USB Typ-B.

While testing, the DAPI can be put into test mode. In this mode, telemetry data can also be output te UART interface.

