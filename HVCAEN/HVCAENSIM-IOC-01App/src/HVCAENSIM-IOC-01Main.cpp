/* $Header: HVCAENx527/HVCAENx527App/src/HVCAENx527Main.cpp 1.6 2007/06/01 13:32:58CST Ru Igarashi (igarasr) Exp Ru Igarashi (igarasr)(2007/06/01 13:32:58CST) $
 * 
 * Copyright Canadian Light Source, Inc.  All rights reserved.
 *    - see licence.txt and licence_CAEN.txt for limitations on use.
 *
 * Author:  Ru Igarasr Date:    2006-04-07 
 *
 */

#include <stddef.h>
#include <stdlib.h>
#include <stddef.h>
#include <string.h>
#include <stdio.h>

#include "epicsThread.h"
#include "epicsExit.h"
#include "iocsh.h"
#include "shareLib.h"

#ifdef _WIN32
#define snprintf _snprintf
#endif

extern "C" {
//    epicsShareFunc int ConnectCrate( char *name);
    epicsShareFunc void Shutdown();
    epicsShareFunc void SetSigShutdownHandler();

    epicsShareExtern short DEBUG;
}

int main(int argc,char *argv[])
{
	int i, j;
	short daemon;
	char stcmd[256];

	/* Need to catch hang up signal to make sure semaphores are
	   cleaned up properly */
	SetSigShutdownHandler();

	daemon = 0;
	if(argc>=2) {    
		snprintf( stcmd, 255, "%s", argv[1]);
		j = 0;
		for( i = 2; i < argc; i++) {
		  if( strcmp( argv[i], "-D") == 0) {
		    i++;
		    DEBUG = atoi( argv[i]);
		  } else if( strcmp( argv[i], "-d") == 0) {
		    daemon = 1;
		  }
		}
	}
	else
	{
		printf( "Syntax: hvcontrol <st.cmd> [-d] [-D <debuglevel>]\n");
		printf( "              -d = run in daemon mode\n");
		printf( "              <debuglevel> = 0 no messages\n");
		printf( "              <debuglevel> = 10 all available messages\n");
	}

	if (strlen(stcmd)>0)	iocsh(stcmd);

	if (daemon)	{
		for(;;)
			epicsThreadSleep(1.0);
	} else {
		iocsh(NULL);
	}
	Shutdown();
    epicsExit(0);
	return(0);
}

/* 
 *  $Log: HVCAENx527/HVCAENx527App/src/HVCAENx527Main.cpp  $
 *  Revision 1.6 2007/06/01 13:32:58CST Ru Igarashi (igarasr) 
 *  Member moved from EPICS/HVCAENx527App/src/HVCAENx527Main.cpp in project e:/MKS_Home/archive/cs/epics_local/drivers/CAENx527HV/project.pj to HVCAENx527/HVCAENx527App/src/HVCAENx527Main.cpp in project e:/MKS_Home/archive/cs/epics_local/drivers/CAENx527HV/project.pj.
 */

