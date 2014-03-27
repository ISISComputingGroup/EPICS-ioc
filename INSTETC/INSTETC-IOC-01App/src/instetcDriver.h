#ifndef INSTETCDRIVER_H
#define INSTETCDRIVER_H
 
#include "asynPortDriver.h"

template <typename T>
struct asynItems
{
    enum ParamType { value = -1 };
};

template <>
struct asynItems<double>
{
    enum ParamType { value = asynParamFloat64 };
};

template <>
struct asynItems<int>
{
    enum ParamType { value = asynParamInt32 };
};


class instetcDriver : public asynPortDriver 
{
	public:
		instetcDriver(const char* portName, const char* filePath, const int lineCount, double pollingPeriod);
		static void pollerThreadC(void* arg);
		virtual asynStatus readFloat64(asynUser *pasynUser, epicsFloat64 *value);
                 
	private:
		std::string filePath;
		int lineCount;
		double pollingPeriod;

		int P_Text; //string
	
		void updateText(std::string text);

		#define FIRST_INSTETC_PARAM P_Text
		#define LAST_INSTETC_PARAM P_Text
	
		void pollerThread(std::string filePath, int lineCount, double pollingPeriod);
		epicsTimeStamp m_timestamp;
};

#define NUM_INSTETC_PARAMS (&LAST_INSTETC_PARAM - &FIRST_INSTETC_PARAM + 1)
#define P_TextString "TEXT"

#endif /* INSTETCDRIVER_H */
