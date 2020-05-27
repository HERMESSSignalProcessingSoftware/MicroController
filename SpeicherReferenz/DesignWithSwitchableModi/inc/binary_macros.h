#ifndef _INCLUDED_BINARY_MACROS_H_
#define _INCLUDED_BINARY_MACROS_H_

#include <cyu3types.h>

#define HEX__(n) 0x##n##LU
#define B8__(x) ((x&0x0000000FLU)?1:0) \
+((x&0x000000F0LU)?2:0) \
+((x&0x00000F00LU)?4:0) \
+((x&0x0000F000LU)?8:0) \
+((x&0x000F0000LU)?16:0) \
+((x&0x00F00000LU)?32:0) \
+((x&0x0F000000LU)?64:0) \
+((x&0xF0000000LU)?128:0)


#define B8(d) ((uint8_t)(d))
#define B16(dmsb,dlsb) (((uint16_t)B8(dmsb)<<8) | B8(dlsb))
#define B32(dmsb,db2,db3,dlsb) \
(((uint32_t)B8(dmsb)<<24) \
| ((uint32_t)B8(db2)<<16) \
| ((uint32_t)B8(db3)<<8) \
| B8(dlsb))


#define CUT0B(d) ((uint8_t)(d))
#define CUT1B(d) ((uint8_t)((d)>>8))
#define CUT2B(d) ((uint8_t)((d)>>16))
#define CUT3B(d) ((uint8_t)((d)>>24))

#define CUT0uint16(d) ((uint16_t)(d))
#define CUT1uint16(d) ((uint16_t)((d)>>16))
/*
 * So if you had a memory-mapped 8-bit control register of the format XXXYYZZZ 
 * (where XXX, YY, and ZZZ are subfields), you could initialize it like so:
 *
 * p_reg = ( (B8(010) << 5) | (B8(11) << 3) | (B8(101) << 0) )
 * 
 * which sets the XXX bits to 010, YY to 11, and ZZZ to 101. 
 * If I ever needed to change XXX to 011, just change a single 0 to a 1 in the source code, and everything magically changes. 
 * Best of all, it’s all done at compile-time. No error-prone conversion to hexadecimal necessary, 
 * no figuring out which bits belong to which nibbles, etc.
*/

#endif
