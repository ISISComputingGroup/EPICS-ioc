#include <string.h>
#include <stdlib.h>
#include <registryFunction.h>
#include <aSubRecord.h>
#include <menuFtype.h>
#include <errlog.h>
#include <epicsString.h>
#include <epicsExport.h>
#include <errlog.h>

#include <string>
#include <vector>
#include <sstream>
#include <iostream>

#include "fermichopper.h"

std::string packet5data = "";
std::string packet6data = "";
std::string packet7data = "";
std::string packet8data = "";

/**
  *  	Strips out the leading byte from the given input.
  *
  *		The input data is modified so that it no longer contains the first character.
  */
static char parseInput(char* input)
{
	char firstChar = input[1];
	int i;
	for(i=0; i<4; i++)
	{
		input[i] = input[i+2];
	}
	// Null terminator
	input[4] = '\0';
	return firstChar;
}

static long hexCodeToChopperSpeedHz(const std::string& data)
{
	if (data.c_str()[3] == 'B') return 50;
	else if (data.c_str()[3] == 'A') return 100;
	else if (data.c_str()[3] == '9') return 150;
	else if (data.c_str()[3] == '8') return 200;
	else if (data.c_str()[3] == '7') return 250;
	else if (data.c_str()[3] == '6') return 300;
	else if (data.c_str()[3] == '5') return 350;
	else if (data.c_str()[3] == '4') return 400;
	else if (data.c_str()[3] == '3') return 450;
	else if (data.c_str()[3] == '2') return 500;
	else if (data.c_str()[3] == '1') return 550;
	else if (data.c_str()[3] == '0') return 600;	
	else {
		// printf("Got an unexpected character, %c\n", data.c_str()[3]);
		return 0;
	}
}

static long rpmToHz(const long rpm)
{
	return rpm / 60;
}

static unsigned long longFromHex(const std::string& data)
{
	unsigned long value;
    std::istringstream iss(data);
    iss >> std::hex >> value;
	return value;
}

static unsigned long dehexAndCombineWords(const std::string& lowWord, const std::string& highWord)
{
	return longFromHex(lowWord) + (65536 * longFromHex(highWord));
}

double delayFrom2HexWords(const std::string& lowWord, const std::string& highWord, double mhz)
{
	return ((double) dehexAndCombineWords(lowWord, highWord))/mhz;
}

double delayFromHex(const std::string& hex, double mhz)
{
	return ((double) longFromHex(hex))/mhz;
}

double driveCurrentFromHex_merlin(const std::string& hex)
{	
	return ((double) longFromHex(hex))*0.002016;
}

double driveCurrentFromHex_maps(const std::string& hex)
{	
	return ((double) longFromHex(hex))*0.00684;
}

double azVoltageFromHex_merlin(const std::string& hex)
{	
	return (((double) longFromHex(hex))*0.04486) - 22.86647;
}

double azVoltageFromHex_maps(const std::string& hex)
{	
	return (((double) longFromHex(hex))*0.0137) - 7.0;
}

double supplyVoltageFromHex_merlin(const std::string& hex)
{
	return ((double) longFromHex(hex))*0.4274;
}

double electronicsTemperatureFromHex_merlin(const std::string& hex)
{
	return (((double) longFromHex(hex))*0.14663) - 25.0;
}

double motorTemperatureFromHex_merlin(const std::string& hex)
{
	return (((double) longFromHex(hex))*0.1263) - 12.124;
}

/**
  *		Maps the first character in a data packet to an output link of the asub record.
  */
static void outputToPv_merlin(aSubRecord *prec, int firstChar, const std::string& data, double mhz)
{
    
	switch(firstChar) 
	{
		case '1':
		    // -> output A
			// Straight copy of value, no processing needed.
		    strcpy(*(epicsOldString*)prec->vala, data.c_str());
			break;
		case '2':
		    // -> output B
			long status;
			status = longFromHex(data.c_str());
		    *(long*)prec->valb = status;
			break;
		case '3':
		    // output C: $(P)SPEED:SP:RBV
			long setpointSpeed;
			setpointSpeed = hexCodeToChopperSpeedHz(data.c_str());
		    *(long*)prec->valc = setpointSpeed;
			break;
		case '4':
			// output D: $(P)SPEED
			unsigned long actualSpeed;
			actualSpeed = rpmToHz(longFromHex(data.c_str()));
		    *(unsigned long*)prec->vald = actualSpeed;
			break;
		case '5':
			// output E: $(P)DELAY:SP:RBV (low word)
			if (packet6data == "")
			{
				packet5data = data;
			}
			else
			{
				double delay;
				delay = delayFrom2HexWords(data.c_str(), packet6data.c_str(), mhz);
				*(double*)prec->vale = delay;
			}
			break;
		case '6':
			// output E: $(P)DELAY:SP:RBV (high word)
			if (packet5data == "")
			{
				packet6data = data;
			}
			else
			{
				double delay;
				delay = delayFrom2HexWords(packet5data.c_str(), data.c_str(), mhz);
				*(double*)prec->vale = delay;
			}
			break;
		case '7':
			// output F: $(P)DELAY (low word)
			if (packet8data == "")
			{
				packet7data = data;
			}
			else
			{
				double delay;
				delay = delayFrom2HexWords(data.c_str(), packet8data.c_str(), mhz);
				*(double*)prec->valf = delay;
			}
			break;
		case '8':
			// output F: $(P)DELAY (high word)
			if (packet7data == "")
			{
				packet8data = data;
			}
			else
			{
				double delay;
				delay = delayFrom2HexWords(packet7data.c_str(), data.c_str(), mhz);
				*(double*)prec->valf = delay;
			}
			break;
		case '9':
			// output G: $(P)GATEWIDTH
			double delay;
			delay = delayFromHex(data.c_str(), mhz);
			*(double*)prec->valg = delay;
			break;
		case 'A':
			// output H: $(P)DRIVECURRENT
			double current;
			current = driveCurrentFromHex_merlin(data.c_str());
			*(double*)prec->valh = current;
			break;
		case 'B':
			// output I: $(P)AUTOZERO:1:UPPER
			double azVolt1Upper;
			azVolt1Upper = azVoltageFromHex_merlin(data.c_str());
			*(double*)prec->vali = azVolt1Upper;
			break;
		case 'C':
			// output J: $(P)AUTOZERO:2:UPPER
			double azVolt2Upper;
			azVolt2Upper = azVoltageFromHex_merlin(data.c_str());
			*(double*)prec->valj = azVolt2Upper;
			break;
		case 'D':
			// output K: $(P)AUTOZERO:1:LOWER
			double azVolt1Lower;
			azVolt1Lower = azVoltageFromHex_merlin(data.c_str());
			*(double*)prec->valk = azVolt1Lower;
			break;
		case 'E':
			// output L: $(P)AUTOZERO:2:LOWER
			double azVolt2Lower;
			azVolt2Lower = azVoltageFromHex_merlin(data.c_str());
			*(double*)prec->vall = azVolt2Lower;
			break;
		case 'F':
			// output M: $(P)VOLTAGE
			double voltage;
			voltage = supplyVoltageFromHex_merlin(data.c_str());
			*(double*)prec->valm = voltage;
			break;		
		case 'G':
			// output N: $(P)TEMPERATURE:ELECTRONICS
			double electronicsTemp;
			electronicsTemp = electronicsTemperatureFromHex_merlin(data.c_str());
			*(double*)prec->valn = electronicsTemp;
			break;		
		case 'H':
			// output O: $(P)TEMPERATURE:MOTOR
			double motorTemp;
			motorTemp = motorTemperatureFromHex_merlin(data.c_str());
			*(double*)prec->valo = motorTemp;
			break;
	}
}

/**
  *		Maps the first character in a data packet to an output link of the asub record.
  */
static void outputToPv_maps(aSubRecord *prec, int firstChar, const std::string& data, double mhz)
{
    
	switch(firstChar) 
	{
		case '1':
		    // -> output A
			// Straight copy of value, no processing needed.
		    strcpy(*(epicsOldString*)prec->vala, data.c_str());
			break;
		case '2':
		    // -> output B
			long status;
			status = longFromHex(data.c_str());
		    *(long*)prec->valb = status;
			break;
		case '3':
		    // output C: $(P)SPEED:SP:RBV
			unsigned long setpointSpeed;
			setpointSpeed = rpmToHz(longFromHex(data.c_str()));
		    *(unsigned long*)prec->valc = setpointSpeed;
			break;
		case '4':
			// output D: $(P)SPEED
			unsigned long actualSpeed;
			actualSpeed = rpmToHz(longFromHex(data.c_str()));
		    *(unsigned long*)prec->vald = actualSpeed;
			break;
		case '5':
			// output E: $(P)DELAY:SP:RBV (low word)
			if (packet6data == "")
			{
				packet5data = data;
			}
			else
			{
				double delay;
				delay = delayFrom2HexWords(data.c_str(), packet6data.c_str(), mhz);
				*(double*)prec->vale = delay;
			}
			break;
		case '6':
			// output E: $(P)DELAY:SP:RBV (high word)
			if (packet5data == "")
			{
				packet6data = data;
			}
			else
			{
				double delay;
				delay = delayFrom2HexWords(packet5data.c_str(), data.c_str(), mhz);
				*(double*)prec->vale = delay;
			}
			break;
		case '7':
			// output F: $(P)DELAY (low word)
			if (packet8data == "")
			{
				packet7data = data;
			}
			else
			{
				double delay;
				delay = delayFrom2HexWords(data.c_str(), packet8data.c_str(), mhz);
				*(double*)prec->valf = delay;
			}
			break;
		case '8':
			// output F: $(P)DELAY (high word)
			if (packet7data == "")
			{
				packet8data = data;
			}
			else
			{
				double delay;
				delay = delayFrom2HexWords(packet7data.c_str(), data.c_str(), mhz);
				*(double*)prec->valf = delay;
			}
			break;
		case '9':
			// output G: $(P)GATEWIDTH
			double delay;
			delay = delayFromHex(data.c_str(), mhz);
			*(double*)prec->valg = delay;
			break;
		case 'A':
			// output H: $(P)DRIVECURRENT
			double current;
			current = driveCurrentFromHex_maps(data.c_str());
			*(double*)prec->valh = current;
			break;
		case 'B':
			// output I: $(P)AUTOZERO:1:UPPER
			double azVolt1Upper;
			azVolt1Upper = azVoltageFromHex_maps(data.c_str());
			*(double*)prec->vali = azVolt1Upper;
			break;
		case 'C':
			// output J: $(P)AUTOZERO:2:UPPER
			double azVolt2Upper;
			azVolt2Upper = azVoltageFromHex_maps(data.c_str());
			*(double*)prec->valj = azVolt2Upper;
			break;
		case 'D':
			// output K: $(P)AUTOZERO:1:LOWER
			double azVolt1Lower;
			azVolt1Lower = azVoltageFromHex_maps(data.c_str());
			*(double*)prec->valk = azVolt1Lower;
			break;
		case 'E':
			// output L: $(P)AUTOZERO:2:LOWER
			double azVolt2Lower;
			azVolt2Lower = azVoltageFromHex_maps(data.c_str());
			*(double*)prec->vall = azVolt2Lower;
			break;

	}
}

/**
 *  Merlin.
 */
long fermi_merlin(aSubRecord *prec) 
{
	
    std::vector<std::string> args;
    for(unsigned int i=0; i<prec->noa; ++i)
	{
		std::string s(((epicsOldString*)(prec->a))[i], sizeof(epicsOldString));
		args.push_back(s);
	}		
	
    for(int i=0; i<args.size(); ++i)
	{
		// String has format #TVVVVCC where T=Type, V=Value, C=Checksum.
		// We only care about the type and the value.
		outputToPv_merlin(prec, args[i][1], args[i].substr(2, 4), *(double*)prec->b);
	}
	
	// printf("Asub: fermichopper: Parsed output %s\n", *(epicsOldString*)(prec->vala));
	// printf("Asub: fermichopper: Parsed output %s\n", *(epicsOldString*)(prec->valb));
	
	// Reset data from packets now that the whole thing should be adequately processed.
	packet5data = "";
	packet6data = "";
	packet7data = "";
	packet8data = "";
	
    return 0; /* process output links */
}

/**
 *  MAPS.
 */
long fermi_maps(aSubRecord *prec) 
{
	
    std::vector<std::string> args;
    for(unsigned int i=0; i<prec->noa; ++i)
	{
		std::string s(((epicsOldString*)(prec->a))[i], sizeof(epicsOldString));
		args.push_back(s);
	}		
	
    for(int i=0; i<args.size(); ++i)
	{
		// String has format #TVVVVCC where T=Type, V=Value, C=Checksum.
		// We only care about the type and the value.
		outputToPv_maps(prec, args[i][1], args[i].substr(2, 4), *(double*)prec->b);
	}
	
	// Reset data from packets now that the whole thing should be adequately processed.
	packet5data = "";
	packet6data = "";
	packet7data = "";
	packet8data = "";
	
    return 0; /* process output links */
}

long speedSetpointSend_merlin(aSubRecord *prec)
{	
	if (*(int*)(prec->a) == 50) *(long*)prec->vala = 11;
	else if (*(int*)(prec->a) == 100) *(long*)prec->vala = 10;
	else if (*(int*)(prec->a) == 150) *(long*)prec->vala = 9;
	else if (*(int*)(prec->a) == 200) *(long*)prec->vala = 8;
	else if (*(int*)(prec->a) == 250) *(long*)prec->vala = 7;
	else if (*(int*)(prec->a) == 300) *(long*)prec->vala = 6;
	else if (*(int*)(prec->a) == 350) *(long*)prec->vala = 5;
	else if (*(int*)(prec->a) == 400) *(long*)prec->vala = 4;
	else if (*(int*)(prec->a) == 450) *(long*)prec->vala = 3;
	else if (*(int*)(prec->a) == 500) *(long*)prec->vala = 2;
	else if (*(int*)(prec->a) == 550) *(long*)prec->vala = 1;
	else if (*(int*)(prec->a) == 600) *(long*)prec->vala = 0;
	
	return 0;
}

long speedSetpointSend_maps(aSubRecord *prec)
{	
	*(long*)prec->vala = *(int*)(prec->a) * 60; // Convert Hz to rpm
	return 0;
}

long commandChecker(aSubRecord *prec)
{
	long command = *(long*)(prec->a);
	long magnetic_bearings = *(long*)(prec->b);
	double speed = *(double*)(prec->c);
	long speed_sp_rbv = *(long*)(prec->d);
	long drive_generator_on = *(long*)(prec->e);
	
	int output_command;
	
	if (command == 3) {
		if (magnetic_bearings != 1) {
			errlogSevPrintf(errlogMajor, "commandCheck: refusing to switch on run mode without magnetic bearings.\n");
			output_command = 0;
		} else if (speed_sp_rbv == 600 && speed > 595 && drive_generator_on) {
			errlogSevPrintf(errlogMajor, "commandCheck: not sending 'switch drive on and run' command as chopper is already set at 600Hz\n");
			output_command = 0;
		}else {
			output_command = 3;
		}
	} else if (command == 5) {
		if (speed > 10) {
			errlogSevPrintf(errlogMajor, "commandCheck: refusing to switch off magnetic bearings as chopper speed is over 10Hz.\n");
			output_command = 0;
		} else {
			output_command = 5;
		}
	} else {
		output_command = command;
	}
	
	*(long*)prec->vala = output_command;
	
	if (output_command != 0) {
		errlogSevPrintf(errlogInfo, "commandCheck: sending command (%d) to device.\n", output_command);
	}
	
	return 0;
}
