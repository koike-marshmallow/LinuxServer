#include <stdio.h>
#include <stdlib.h>

#define DIV_VAL 1024

#define UNIT_CNT 5
char *UNIT[UNIT_CNT] = {"byte", "KB", "MB", "GB", "TB"};


int main(int argc, char *argv[]){
	double value;
	int count;
	
	if( argc < 2 ){
		fprintf(stderr, "./%s [バイト数]\n", argv[0]);
		exit(1);
	}
	value = atof(argv[1]);
	
	count = 0;
	while( value >= DIV_VAL && count < (UNIT_CNT - 1) ){
		value = value / DIV_VAL;
		count++;
	}
	
	printf("%.1f %s\n", value, UNIT[count]);

	return 0;
}
