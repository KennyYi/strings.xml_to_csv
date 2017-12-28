
if (this.args.length == 0) {
    println "error: neither -h or strings.xml path"
    printUseage()
} else if (this.args[0] == "-h" || this.args[0] == "-help") {
    printUseage()
} else {
    generate(this.args[0])
}

def printUseage() {
    println "useage: test.gsh [options] [file_path]"
    println "options:"
    println "  -h, -help\tuseage information"
}

def generate (path) {
    // Create or open file
    def csvFile = new File("strings.csv").asWritable('UTF-8')
    csvFile.bytes = []

    def tempFile = new File('temp.xml').asWritable('UTF-8')
    tempFile.bytes = []
    
    new FileInputStream(path).withReader('UTF-8') { reader ->
        
        reader.eachLine { String line ->

            // wrap text value with "<![CDATA[]]>" for contains HTML tag inside of values.
            if (line.contains("<string") && !line.contains("<![CDATA[")) {
                // I don't know why "/(\<string name="[a-zA-Z0-9_]+">)(.+)(\<\/string\>)/" this pattern throw exception.
                // Regex is work after remove '>' from pattern. So, temp[0][2] starts with '>'. That's why I add substring(1).
                def temp = line =~ /(<string name="[a-zA-Z0-9_]+")(.+)(<\/string>)/ 
                tempFile << temp[0][1]+"><![CDATA["+temp[0][2].substring(1)+"]]>"+temp[0][3]
            } else {
                tempFile << line
            }
            
            tempFile << "\n"
        }
    }

    def strings = new XmlSlurper().parse(tempFile)
    println strings.getProperty("name")
    strings.string.each {

        csvFile << it.@name
        csvFile << ","
        csvFile << it.text() + "\n"
    }

    // remove temporary file
    tempFile.delete()
}
