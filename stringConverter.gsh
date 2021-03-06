
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

        generate(this.args[1], outPath, true)
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

    // Create target file and initialize if it was created.
    def csvFile = new File(outPath).asWritable('UTF-8')
    csvFile.bytes = []

    // Create temp xml file and initialize if it was created.
    def tempFile = new File('temp.xml').asWritable('UTF-8')
    tempFile.bytes = []
    
    new FileInputStream(path).withReader('UTF-8') { reader ->

        def isComment = false

        reader.eachLine { String line ->

            line = line.trim()

            // Check comment line
            if (isComment) {
                def statement = line =~ /.*?-->/
                if (statement.size() > 0) {
                    isComment = false
                }
            } else {
                def statement = line =~ /(<!--)(.*?)(-->)/
                if (statement.size() > 0) {
                    // This line is a comment. Pass this line.
                } else {
                    statement = line =~ /<!--(.*?)/
                    if (statement.size() > 0) {
                        isComment = true
                    } else {
                        def temp = line =~ /(<string name=\"[a-zA-Z0-9_]+\">)(.*)(<\/string>)/
                        if (temp.size() > 0) {
                            if (wrapCdata && !line.contains("<![CDATA[")) {
                                line = temp[0][1]+"<![CDATA["+temp[0][2]+"]]>"+temp[0][3]
                            } else {
                                line = temp[0][1]+"<p>"+temp[0][2]+"</p>"+temp[0][3]
                            }
                        } else if (line.contains("<string")) {
                            // Empty value line. For example: <string name="blank" />
                            temp = line =~ /<string name=\"[a-zA-Z0-9_]+\"\/>/
                        }
                    
                        tempFile << line + "\n"
                    }
                }
            }
        }
    }

    def strings = new XmlSlurper().parse(tempFile)
    strings.string.each {

        csvFile << it.@name
        csvFile << ","
        csvFile << '"'+it.text() + '"'+"\n"
    }

    // remove temporary file
    tempFile.delete()
}
