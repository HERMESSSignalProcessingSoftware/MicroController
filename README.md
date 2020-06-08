# MicroController
## Content
- What do we do?
- Nice to know
- Used Hardware
- Structure
- Cube
- Used Software  
## What do we do?
This project is about developing software for our own measurement system. The goal is to measure the structural strain of a sounding rocket. Therefore we have been developing your own PCB with 16 Bit ADC and two memory units. During flight, the MCU needs to store the values of the 9 ADCs to the memmory. 
## Nice to know
Avoid spaces in filenames!  
## Used Hardware
We are using a STM32F779 a 216 MHz Coretex M7 controller. [STM32 F779BIT6](https://www.st.com/en/microcontrollers-microprocessors/stm32f7x9.html)  
## Structure
The repository contains the main software project `Cube`. There you will find some the generated source code and the STM32CubeMx project.   
The `Docu` folder contains the generated software documentation from the doxygen comments.  
`Images` obsolet.  
`Kleinstgruppen` contains the parts of the other members. There will be the main `.tex` file for  the documentation.  
`STM32F302Nucelo`  is a testing due to some fun. 
## Cube
Stm32 CubeMX generates the neccessary code to use the controller.  
Do not remove or edit any comment unless you are the author of this comment!  
Comments you shall not remove: (example from the UART4_Init fuction) It is created by the code generator.
```C
/* USER CODE BEGIN UART4_Init 0 */

/* USER CODE END UART4_Init 0 */
```
If this comment is your comment or its looks like a comment from a team member, feel free to edit it. 
```
/* No comment */ 
```
## Used Software 
- [Atollic TrueStudio](https://atollic.com/resources/download/)
- [Stm32 Cube](https://www.st.com/en/development-tools/stm32cubemx.html)
- [Pulse View](https://sigrok.org/wiki/PulseView)
- [GitHub Desktop](https://desktop.github.com/)
- [Inkscape](https://inkscape.org/de/)
- [PAPDesigner](https://www.heise.de/download/product/papdesigner-51889)

```

```
