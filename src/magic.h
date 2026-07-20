/*
 * Thin wrapper: maps legacy PS4_x_xx defines to the centralized
 * ps4-offsets submodule (__x_xx__ convention), then pulls in the
 * version-dispatched header.
 */

#if defined(PS4_6_72)
  #define __6_72__
#elif defined(PS4_7_00)
  #define __7_00__
#elif defined(PS4_7_55)
  #define __7_55__
#elif defined(PS4_9_00)
  #define __9_00__
#else
  #error "Unsupported firmware"
#endif

#include "../ps4-offsets/includes.h"
