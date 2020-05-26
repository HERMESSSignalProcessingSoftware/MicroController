

#include <cyu3os.h>

#include "../inc/criticalErrorHandler.h"
#include "../inc/userDebug.h"

/* Application Error Handler */
void
CyFxAppErrorHandler (
        CyU3PReturnStatus_t apiRetStatus    /* API return status */
        )
{
    /* This function is hit when we have hit a critical application error. This is not
       expected to happen, and the current implementation of this function does nothing
       except stay in a loop printing error messages through the UART port.

       This function can be modified to take additional error handling actions such
       as cycling the USB connection or performing a warm reset.
     */
    for (;;)
    {
      failurePrint("handler...");
        CyU3PThreadSleep (1000);
    }
}
