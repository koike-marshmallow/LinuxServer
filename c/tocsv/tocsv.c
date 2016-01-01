#include <stdio.h>
#include <stdlib.h>

#define TRUE 1
#define FALSE 0

#define DELIMITER ','


int isSpace(char c){
	return c == ' ';
}

int isReturn(char c){
	return c == '\n';
}

int convert(FILE *in, FILE *out){
	int tmp;
	int new_line = TRUE;
	
	while( (tmp = fgetc(in)) != EOF ){ 
		if( isSpace(tmp) ){
			if( ! new_line ){
				fputc(DELIMITER, out);
			}
		
		}else if( isReturn(tmp) ){
			fputc('\n', out);
			new_line = TRUE;
		
		}else{
			fputc(tmp, out);
			new_line = FALSE;
			
		}
	}
}
			

int main(int argc, char *argv[]){
	FILE *input, *output;
	
	if( argc < 3 ){
		fprintf(stderr, "引数が少ないです\n");
		fprintf(stderr, "%s [読み込むファイル] [出力ファイル]\n", argv[0]);
		return 1;
	}
	
	input = fopen(argv[1], "r");
	output = fopen(argv[2], "w");
	if( input == NULL || output == NULL ){
		fprintf(stderr, "ファイルを正常に開けませんでした");
		return 1;
	}
	
	convert(input, output);
	
	fclose(input);
	fclose(output);
	
	return 0;
}
