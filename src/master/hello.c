#include <stdio.h>

int main(int argc, char *argv[])
{
   printf("Hello, world (from ");

#ifdef TECHNO_linux
   printf("linux");
#elif TECHNO_macosx
   printf("Mac OS X");
#elif TECHNO_openwrt
   printf("openwrt");
#endif

   printf(")\n");
}
