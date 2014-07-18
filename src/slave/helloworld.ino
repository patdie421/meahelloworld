#include "comio2.h"
#include "minitimer.h"

Comio2 comio2;
int helloworld_flag=0;


int comio2_serial_read()
{
   return Serial1.read();
}


int comio2_serial_write(char car)
{
   Serial1.write(car);
   return 0;
}


int comio2_serial_available()
{
   return Serial1.available();
}


int comio2_serial_flush()
{
   Serial1.flush();
   return 0;
}


int helloworld(int id, char *data, int l_data, void *userdata)
{
  helloworld_flag=1;
 
  return 0;
} 


void setup()
{
   pinMode(13, OUTPUT);

   Serial1.begin(115200);
   // Wait for U-boot to finish startup. Consume all bytes until we are done.
   do
   {
      while (Serial1.available() > 0)
      Serial1.read();
      delay(1000);
   }
   while (Serial1.available()>0);

   comio2.setReadF(comio2_serial_read);
   comio2.setWriteF(comio2_serial_write);
   comio2.setAvailableF(comio2_serial_available);
   comio2.setFlushF(comio2_serial_flush);

   comio2.setFunction(1, helloworld);
}


void loop()
{
   comio2.run();

   if(helloworld_flag)
   {
      helloworld_flag=0;
      digitalWrite(13, HIGH);
      delay(1000);
      digitalWrite(13, LOW);
   }
}
