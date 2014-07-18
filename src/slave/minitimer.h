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

 