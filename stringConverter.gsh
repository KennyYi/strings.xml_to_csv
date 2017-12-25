


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
    def csvFile = new File("strings.csv")
    // Clear file
    csvFile.bytes = []

    // Read strings file --> Path should be changed
    //new File('/Users/kenny/Desktop/strings.xml').eachLine { line ->
    new File(path).eachLine { line ->

        if (line.contains("<string name=")) {
            
            int idx = line.indexOf("=")
            key = line.substring(idx+1, line.indexOf(">")).replace("\"", "")
            value = line.substring(line.indexOf(">")+1, line.indexOf("</string>"))

            csvFile << (key+","+value+"\n")
        }
    }
}