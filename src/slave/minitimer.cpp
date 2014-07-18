#include "minitimer.h"

class MiniTimer
{
 public:
   MiniTimer();
   void restart();
   int checkAndRestart(unsigned long s);
   int check(unsigned long s);
 private:
   unsigned long previous;
   inline unsigned long diff_millis(unsigned long chrono, unsigned long now} { return now >= chrono ? now - chrono : 0xFFFFFFFF - chrono + now; }
};

/*
 * Construction et initialisation d'un timer
 */
MiniTimer::MiniTimer()
{
   previous=millis();
}
 
/*
 * redemarrage d'un timer
 */
void MiniTimer::restart()
{
   previous=millis();
}

/*
 * test de l'état du timer et reinitiliation automatique
 * si depassé retour HIGH, LOW sinon
 * redemarrage du timer si retour dépasse
 */
int MiniTimer::checkAndRestart(unsigned long t)
{
   unsigned long now = millis();
   if(my_diff_millis(previous, now) > t)
   {
      previous = now;
      return HIGH;
   } 
   else
   {
      return LOW;
   }
}

/*
 * test de l'état du timer sans réinitialisation
 * si depassé retour HIGH, LOW sinon
 */
int MiniTimer::check(unsigned long t)
{
   if(my_diff_millis(previous, millis()) > t)
   {
      return HIGH;
   }
   else
   {
      return LOW;
   }
} 
