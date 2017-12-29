# strings.xml_to_csv
A groovy script to convert Android strings.xml resource file to csv file.

How to use
----------
```
$ groovy stringConverter.gsh [option] [source file path] [output file path]
```

> Options
> * -h, -help: Show usage informations
>   - `$groovy stringConverter.gsh -h`
> * -c, -cdata: Wrap strings with `<![CDATA[]]>`. Default value is `false`.
>   - `$groovy stringConverter.gsh -c strings.xml`
>   - `$groovy stringConverter.gsh -c strings.xml output.csv`
>
> Source file path
> * strings.xml file path what you want to convert to a csv file.
>
> Output file path
> * Target path what you want to export translated csv file.

How to install Groovy
---------------------

http://groovy-lang.org/install.html

Example
-------

string.xml

![string.xml](./example_before.png)


string.csv

![string.csv](./example_after.png)


