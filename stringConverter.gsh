
if (this.args.length == 0) {
    println "error: neither -h or strings.xml path"
    printUseage()
} else if (this.args[0] == "-h" || this.args[0] == "-help") {
    printUseage()
} else if (this.args[0] == "-c" || this.args[0] == "-cdata") {
    if (this.args.length == 1) {
        println "error: File path is missing."
        printUseage()
    } else if (this.args[1] == null || this.args[1].isEmpty()) {
        println "error: File path is missing."
        printUseage()
    } else {
        // Default path
        def outPath = "strings.csv"

        if (this.args.length == 3) {
            outPath = this.args[2]
        }

        generate(this.args[1], true)
    }
} else {
    // Default path
    def outPath = "strings.csv"

    if (this.args.length == 2) {
        outPath = this.args[1]
    }

    generate(this.args[0], outPath, false)
}

def printUseage() {
    println "useage: test.gsh [options] [file_path] [out_file_path]\n"
    println "[file_path] Path of source string.xml"
    println "[out_file_path] Output csv file path. Default path is ./strings.csv"
    println "options:"
    println "  -h, -help\tuseage information"
    println "  -c, -cdata\tWrap strings with <![CDATA[]]>. Default is false."
}

def generate (path, outPath, wrapCdata) {
    // Create or open file
    if (outPath == null || outPath.isEmpty()) {
        outPath = "strings.csv"
    }

    def csvFile = new File(outPath).asWritable('UTF-8')
    csvFile.bytes = []

    def tempFile = new File('temp.xml').asWritable('UTF-8')
    tempFile.bytes = []
    
    new FileInputStream(path).withReader('UTF-8') { reader ->
        
        reader.eachLine { String line ->

            // wrap text value with "<![CDATA[]]>" for contains HTML tag inside of values.
            if (wrapCdata && line.contains("<string") && !line.contains("<![CDATA[")) {
                def temp = line =~ /(<string name=\"[a-zA-Z0-9_]+\">)(.*)(<\/string>)/ 
                line = temp[0][1]+"<![CDATA["+temp[0][2]+"]]>"+temp[0][3]
            }

            if (line.contains("string") && line.contains("&#")) {
                def temp = line =~ /(<string name=\"[a-zA-Z0-9_]+\">)(.*)(<\/string>)/ 
                line = temp[0][1]+"<p>"+temp[0][2]+"</p>"+temp[0][3]
            }
            
            tempFile << line + "\n"
        }
    }

    def strings = new XmlSlurper().parse(tempFile)
    println strings.getProperty("name")
    strings.string.each {

        csvFile << it.@name
        csvFile << ","
        csvFile << '"'+it.text() + '"'+"\n"
    }

    // remove temporary file
    tempFile.delete()
}
