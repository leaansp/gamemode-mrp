#if defined _marp_benchmark_included
	#endinput
#endif
#define _marp_benchmark_included

#define START_BENCH(%0); {new __a=%0,__b=0,__c,__d=GetTickCount(),__e=1;do{}\
    while(__d==GetTickCount());__c=GetTickCount();__d=__c;while(__c-__d<__a||\
    __e){if(__e){if(__c-__d>=__a){__e=0;__c=GetTickCount();do{}while(__c==\
    GetTickCount());__c=GetTickCount();__d=__c;__b=0;}}{

#define FINISH_BENCH(%0); }__b++;__c=GetTickCount();}printf(" Bench for "\
    %0": executes, by average, %.2f times/ms.",floatdiv(__b,__a));}

/*============================ USAGE ==============================

	Will execute all testing code repeatedly until time is up

	START_BENCH(measure time in miliseconds);
	FINISH_BENCH(name of the benchmark);

	Example:

	START_BENCH(1000);
	{
	  	code_to_test();
		...
		...
	}
	FINISH_BENCH("mi_benchmark_name");

==================================================================*/

/*==================================================================

	Benchmark measure time: 3000 ms

	==============================================================

	for(new i = 1; i < sizeof(FactionInfo); i++) {
		format(id_str, sizeof(id_str), "{00FF00}[ID %i]{0094FF} ", i);
		strcat(string, id_str), strcat(string, FactionInfo[i][fName]), strcat(string, "\n");
	}

	[14:07:36]  Bench for test1: executes, by average, 42.63 times/ms.

	==============================================================

	for(new i = 1; i < sizeof(FactionInfo); i++) {
		format(string, sizeof(string), "%s{00FF00}[ID %i]{0094FF} %s\n", string, i, FactionInfo[i][fName]);
	}

	[14:07:46]  Bench for test2: executes, by average, 68.59 times/ms.

	==============================================================

	for(new i = 1; i < sizeof(FactionInfo); i++) 
	{
        format(faction, sizeof(faction), "{00FF00}[ID %i]{0094FF} %s\n", i, FactionInfo[i][fName]);
        strcat(string, faction);
	}

	[14:08:03]  Bench for test4: executes, by average, 80.97 times/ms.

	==============================================================

	string = "{00FF00}[ID 1]{0094FF}"; 
	strcat(string, FactionInfo[1][fName]);
	for(new i = 2; i < sizeof(FactionInfo); i++) 
	{
        format(faction, sizeof(faction), "\n{00FF00}[ID %i]{0094FF} ", i);
        strcat(string, faction), strcat(string, FactionInfo[i][fName]);
	}

	[14:08:11]  Bench for test5: executes, by average, 67.38 times/ms
	
==================================================================*/