
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
    // Clear file
    csvFile.bytes = []

    def strings = new XmlSlurper().parse(path)
    println strings.getProperty("name")
    strings.string.each {

        csvFile << it.@name
        csvFile << ","+it.text()+"\n"
    }
}
