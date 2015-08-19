#ifndef INSTETCDRIVER_H
#define INSTETCDRIVER_H
 
#include "asynPortDriver.h"

class instetcDriver : public asynPortDriver 
{
	public:
		instetcDriver(const char* portName, const char* filePath, const int lineCount, double pollingPeriod);
		static void pollerThreadC(void* arg);
                 
	private:
		std::string filePath;
		int lineCount;
		double pollingPeriod;
        time_t file_mod;

		int P_Text; //string
	
        int getLastLines(std::string& the_lines);
		void updateText(const std::string& text);

		#define FIRST_INSTETC_PARAM P_Text
		#define LAST_INSTETC_PARAM P_Text
	
		void pollerThread(const std::string& filePath, int lineCount, double pollingPeriod);
};

#define NUM_INSTETC_PARAMS (&LAST_INSTETC_PARAM - &FIRST_INSTETC_PARAM + 1)
#define P_TextString "TEXT"

#endif /* INSTETCDRIVER_H */
