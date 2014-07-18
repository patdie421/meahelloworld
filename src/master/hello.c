#include <stdio.h>
#include <stdlib.h>

#include "comio2.h"

static char *serial = "/dev/ttyATH0";

int main(int argc, char *argv[])
{
   comio2_ad_t *ad=NULL;  

   printf("Hello, world (from ");

#ifdef TECHNO_linux
   printf("linux");
#elif TECHNO_macosx
   printf("Mac OS X");
#elif TECHNO_openwrt
   printf("openwrt");
#endif

   printf(")\n");

   ad=comio2_new_ad();
   int ret=comio2_init(ad, serial, B115200);
   if(ret<0)
   {
      fprintf(stderr, "ERROR - %s ", serial);
      perror("");
      fprintf(stderr, "\n");
      exit(1);
   }
   comio2_atCmdSend(ad, 1, "", 0);
   
   comio2_close(ad);
}
