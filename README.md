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

string.xml (source)

```xml
<resources>
    <!-- Comment -->
    <!-- <string name="comment"></string> -->
    <!--
        multi
        line
        test
        -->
    <!-- multi
        line
        test2 -->
    <!--
        <string name="multi_line_comment_test_3">test line</string>
    -->
    <string name="blank"/>
    <string name="blank2"></string>
    <string name="html_test"><img src=\"source\">image</string>
    <string name="cdata_test"><![CDATA[<img src=\'source\'>image]]></string>
</resources>
```


string.csv (result)

```csv
blank,""
blank2,""
html_test,"<img src=\"source\">image"
cdata_test,"<img src=\'source\'>image"
```

