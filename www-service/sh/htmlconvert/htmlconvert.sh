#!/bin/sh

htmlout()
{
	echo $@ >> $output_file
}


if [ "$1" ]
then
	input_file=$1
else
	echo "入力ファイルを指定してください"
fi

if [ "$2" ]
then
	output_file=$2
else
	output_file="output.html"
fi

if [ "$3" ]
then
	html_title=$3
else
	html_title=$1
fi

#init html file
: > $output_file

#write html header
htmlout "<html>"
htmlout 	"<head>"
htmlout 		"<title>${html_title}</title>"
htmlout 		"<meta charset=\"utf-8\"/>"
htmlout 	"</head>"

#write body
htmlout "<body>"
htmlout "<pre><code>"
cat $input_file >> $output_file
htmlout "</pre></code>"
htmlout "</body>"

#write html footer
htmlout "</html>"
