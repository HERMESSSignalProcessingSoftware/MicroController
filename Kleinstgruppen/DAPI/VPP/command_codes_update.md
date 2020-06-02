1.1.0

Command code		Command name		Description

0x01				READ_ALL			request for sending all available data
0x03				ACKNOWLEDGED		positive answer
0x05				STILL_AWAKE			check, if workstation is still listening
0x07				EOF					end of file
0x09				DATA_ERR			error in parity bit, or CRC, can be an answer to STILL_AWAKE or EOF results in all the data transmissions since the last 									check, being sent again

0x0B				Placeholder			placeholder for configuration command
0x0D				Placeholder			placeholder for configuration command
0x0F				Placeholder			placeholder for configuration command
0x11				Placeholder			placeholder for configuration command
0x13				Placeholder			placeholder for configuration command
0x15				RESET				used for resetting the MCU


Overview of all command codes
   
READ_ALL is used to request sending all available data. The ACKNOWLEDGED command is returned when the process was sucessful. In order to check if the Workstation is still listining, the STILL_AWAKE command is used. EOF provides infomation wether the end of file has been reached. In chase of an error in parity bits or CRC the DATA_ERR command can be an answer to STILL_AWAKE or EOF results. RESET is used to reset the MCU.