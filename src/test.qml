// Generic Imports
import QtQuick 2.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2

import QGroundControl.FactControls 1.0
import QGroundControl.Palette 1.0

// Import testing library
// import QtTest 1.12

// Import FTP code
import com.myself 1.0

// Import UDP Code
import com.udp 1.0


Rectangle {
    id: rectangle

    /*
      Name: openFile(file)
      Input: Configuration
      Output: N/A
      Function: Takes in a configuration file and imports the fields
                into the correct location on the configuration file
                form.
    */
    function openFile(fileUrl) {
        var request = new XMLHttpRequest();
        request.open("GET", fileUrl, false);
        request.send(null);
        return request.responseText;
    }

    /*
    function openFile(fileUrl) {
        var request = new XMLHttpRequest();
        request.open("GET", fileUrl, false);
        request.send(null);
        return request.responseText;
    }*/

    /*
      Name: saveFile(file)
      Input: Configuration file text fields
      Output: Configuration file
      Function: Takes in the currently inputted text from the text
                fields and creates a configuration file with them.
    */
    function saveFile(fileUrl, text_rsr, text_fveh, text_fv, text_rf, text_if, text_bb, text_pd, text_pr, text_notes) {
        var request = new XMLHttpRequest();
        request.open("PUT", fileUrl, false);

        //Get current date information
        var date = new Date();
        var year = date.getFullYear();
        var month = date.getMonth()+1;
        var day = date.getDate();

        //Formatting output to file
        var file = "//TS\n";
        //file = file + "Time" + year + "/" + month + "/" + day +"\n";
        file = file + date.toLocaleString() + "\n\n";
        file = file + "//SDRSYS\n";
        file = file + "FVEH  " + text_fveh + "\n";
        file = file + "RFG  " + text_rf + "\n";
        file = file + "IFG  " + text_if + "\n";
        file = file + "BBG  " + text_bb + "\n";
        file = file + "\n";
        file += "//TAG\n";
        file += "Num  1\n";
        file += "FT  " + text_fv + "\n";
        file += "FRS  " + text_rsr + "\n";
        file += "PD  " + text_pd + "\n";
        file += "PR  " + text_pr + "\n";

        file += "\n//NOTES\n";
        file += text_notes + "\n";

        request.send(file);
        return request.status;
    }

    /*
      Name: openFile(fileLocation)
      Input: configuration file
      Output: Modified textfield values coresponding to file input
      Function: Takes in a configuration file and replaces the textfields
                within the GUI with the corresponding text from the file.
    */
    FileDialog {
        id: openFileDialog
        nameFilters: ["Text Files (*.txt)", "FTP Files (*.ftp)", "All files (*)"]
        onAccepted: /*flightNotes.text = openFile(openFileDialog.fileUrl)*/ {
            //Create Request
            var request = new XMLHttpRequest();
            request.open("GET", fileUrl, false);
            request.send(null);

            //Start parsing the file
            var file = request.responseText;
            var lines = file.split("\n");
            console.log(lines);
            var remake = "";
            var iterator;
            for (iterator = 0; iterator < lines.length; iterator++) {
                if(lines[iterator].substring(0,1) === "" && (iterator !== lines.length-1)) {
                    //console.log("Removing solo newlines.");
                    iterator++;
                }
                if(lines[iterator].substring(0,2) === "//") {
                    //console.log("Removing comment.");
                    iterator++;
                }
                remake += lines[iterator];
                remake += "\n";
                //console.log("IN loop");
            }
            //console.log(remake)
            //console.log("XX")
            var reremake = remake.split("\n")
            //console.log(reremake)
            //console.log("XXX")
            //console.log(reremake[0])
            flightNotes.text = reremake[10]
            rfGain.text = (reremake[2].split(" "))[2]
            ifGain.text = (reremake[3].split(" "))[2]
            bbGain.text = (reremake[4].split(" "))[2]
            pulseDuration.text = (reremake[8].split(" "))[2]
            pulseRepetition.text = (reremake[9].split(" "))[2]
            tagFreq.text = (reremake[6].split(" "))[2]
            uavTelemetrySampleRate.text = (reremake[7].split(" "))[2]
            radioSamplingRate.text = (reremake[1].split(" "))[2]
        }
    }

    /* TESTING */
    FileDialog {
        id: modifyDialog
        nameFilters: ["Text Files (*.txt)", "All files (*)"]
        onAccepted: {
            flightNotes.text = "MODIFICATION WORKING"
            tagFreq.text = "MODIFICATION WORKING"
        }

    }

    FileDialog {
        id: saveFileDialog
        selectExisting: false
        nameFilters: ["Text Files (*.txt)", "FTP Files (*.ftp)", "All files (*)"]
        onAccepted: saveFile(saveFileDialog.fileUrl, radioSamplingRate.text, uavTelemetrySampleRate.text, tagFreq.text, rfGain.text, ifGain.text, bbGain.text, pulseDuration.text, pulseRepetition.text, flightNotes.text)
    }


    Rectangle {
        id: configBackground
        x: 8
        y: 7
        width: 333
        height: 512
        color: "#b5b5b5"
    }

    Rectangle {
        id: udpBackground
        x: 453
        y: 7
        width: 362
        height: 874
        color: "#b5b5b5"
    }

    Grid {
        id: grid
        x: 28
        y: 43
        width: 400
        height: 400
        flow: Grid.LeftToRight
        scale: 1
        columns: 2
        spacing: 10

        Text {
            id: tagFreqLabel
            color: "#000000"
            text: qsTr("Tag Frequency (MHz)")
            font.pixelSize: 12
        }

        TextField {
            id: tagFreq
            placeholderText: qsTr("Text Field")
        }

        Text {
            id: rfGainLabel
            color: "#000000"
            text: qsTr("RF Gain (dB)")
            font.pixelSize: 12
        }

        TextField {
            id: rfGain
            placeholderText: qsTr("Text Field")
        }

        Text {
            id: ifGainLabel
            color: "#000000"
            text: qsTr("IF Gain (dB)")
            font.pixelSize: 12
        }

        TextField {
            id: ifGain
            placeholderText: qsTr("Text Field")
        }

        Text {
            id: bbGainLabel
            color: "#000000"
            text: qsTr("BB Gain (dB)")
            font.pixelSize: 12
        }

        TextField {
            id: bbGain
            placeholderText: qsTr("Text Field")
        }

        Text {
            id: radioSamplingRateLabel
            color: "#000000"
            text: qsTr("Radio Sampling Rate (HZ)")
            font.pixelSize: 12
        }

        TextField {
            id: radioSamplingRate
            placeholderText: qsTr("Text Field")
        }

        Text {
            id: pulseDurationLabel
            color: "#000000"
            text: qsTr("Pulse Duration (s)")
            font.pixelSize: 12
        }

        TextField {
            id: pulseDuration
            placeholderText: qsTr("Text Field")
        }

        Text {
            id: pulseRepetitionLabel
            color: "#000000"
            text: qsTr("Pulse Repetition Rate (s)")
            font.pixelSize: 12
        }

        TextField {
            id: pulseRepetition
            placeholderText: qsTr("Text Field")
        }

        Text {
            id: uavTelemetrySampleRateLabel
            color: "#000000"
            text: qsTr("Uav Telem. Sample Rate (Hz)")
            font.pixelSize: 12
        }


        TextField {
            id: uavTelemetrySampleRate
            placeholderText: qsTr("Text Field")
        }
    }

    QGCPalette { id: palette; colorGroupEnabled: enabled }


    TextField {
        id: configName
        x: 36
        y: 449
        width: 92
        height: 22
        text: "Config name"
        placeholderText: qsTr("Text Field")
    }

    Text {
        id: flightNotesLael
        x: 28
        y: 317
        color: "#000000"
        text: qsTr("Flight Notes")
        font.pixelSize: 12
    }

    Button {
        id: saveConfigButton
        onClicked: saveFileDialog.open()
        x: 134
        y: 448
        width: 72
        height: 24
        text: qsTr("Save")
    }

    TextArea {
        id: flightNotes
        x: 28
        y: 337
        width: 293
        height: 106
    }

    Text {
        id: flightSettingsLabel
        x: 28
        y: 8
        color: "#000000"
        text: qsTr("Flight Settings")
        font.pixelSize: 20
    }

    //FtpWindow{
    //    id: mywindow
    //}


    FtpDialog{
        id: ftpObject
    }

    MyUdp{
        id: udpObject
    }

    Button {
        id: connectFTPButton
        x: 474
        y: 85
        text: qsTr("Connect")
        onClicked: {
            ftpObject.connectClicked("10.42.0.1")
        }

    }

    Button {
        id: importSettingsButton
        onClicked: openFileDialog.open()
        x: 36
        y: 478
        text: qsTr("Import Settings")
    }

    Button {
        id: disconnectFTPButton
        x: 548
        y: 85
        text: qsTr("Disconnect")
        anchors.rightMargin: 976
        onClicked:{
            ftpObject.closeFTP()
        }
    }

    Text {
        id: systemControlLabel
        x: 474
        y: 8
        color: "#000000"
        text: qsTr("System Control")
        anchors.rightMargin: 976
        font.pixelSize: 20
    }

    Button {
        id: sendSettingsButton
        x: 124
        y: 478
        width: 82
        height: 23
        text: qsTr("Send Settings")
    }

    Button {
        id: startRadioButton
        x: 474
        y: 478
        text: qsTr("Start Radio")
        anchors.rightMargin: 976
        onClicked:
            udpObject.startUDP()
    }

    Button {
        id: stopRadioButton
        x: 555
        y: 478
        text: qsTr("Stop Radio")
        anchors.rightMargin: 976
        onClicked:
            udpObject.stopUDP()
    }


    Button {
        id: dowloadFtpButton
        x: 474
        y: 111
        text: qsTr("Download")
        onClicked:
            ftpObject.downloadContent()
    }

    Button {
        id: uploadFtpButton
        x: 548
        y: 111
        text: qsTr("Upload")
        onClicked:
            ftpObject.uploadContent()
    }


    Text {
        id: connectionStatusLabel
        x: 638
        y: 62
        color: "#000000"
        text: qsTr("Connection Status")
        anchors.rightMargin: 976
        font.pixelSize: 12
    }

    TextField {
        objectName: "ipInput"
        x: 474
        y: 59
        width: 149
        height: 20
        text: qsTr("10.42.0.1")
        anchors.rightMargin: 976
        font.pixelSize: 12
    }


    TextField {
        id: textField
        x: 638
        y: 82
        width: 98
        height: 20
        text: "Unknown"
        anchors.rightMargin: 976
        placeholderText: qsTr("Text Field")
    }

    Text {
        id: lastHeartBeatLabel
        x: 675
        y: 482
        color: "#000000"
        text: qsTr("Last Heartbeat")
        anchors.rightMargin: 976
        font.pixelSize: 12
    }

    TextField {
        id: lastHeartbeat
        x: 757
        y: 480
        width: 37
        height: 20
        text: "0"
        anchors.rightMargin: 976
        placeholderText: qsTr("Text Field")
    }

    Text {
        id: ftpLabel
        x: 474
        y: 38
        width: 20
        height: 15
        color: "#000000"
        text: qsTr("FTP")
        anchors.rightMargin: 976
        font.pixelSize: 12
    }

    Text {
        id: udpLabel
        x: 474
        y: 458
        color: "#000000"
        text: qsTr("UDP")
        anchors.rightMargin: 976
        font.pixelSize: 12
    }

    TextArea {
        id: terminalArea
        objectName: "testOutput"
        x: 474
        y: 561
        width: 320
        height: 300
        anchors.rightMargin: 976
        text: udpObject.logFile
    }

    TextArea {
        id: ftpTerminalArea
        objectName: "testOutput"
        x: 474
        y: 140
        width: 320
        height: 300
        anchors.rightMargin: 976
        text: ftpObject.logFile
    }

    Button {
        id: clearUDPTerminalButton
        x: 718
        y: 532
        text: "Clear Terminal"
        clip: false
        anchors.rightMargin: 976
    }

    Button {
        id: cleanConnectionButton
        x: 474
        y: 507
        text: "Clean up Connection"
        anchors.rightMargin: 976
    }

    Button {
        id: connectionSettingsButton
        x: 474
        y: 532
        width: 107
        height: 23
        text: "Connection Settings"
        anchors.rightMargin: 976
    }

    Button {
        id: refreshIPButton
        //objectName: refreshIPButtonName
        x: 587
        y: 507
        text: "Refresh IP"
        onClicked: udpObject.helloUDP();
        anchors.rightMargin: 976
    }

    Button {
        id: clearFTPTerminalButton
        x: 719
        y: 111
        text: "Clear Terminal"
        anchors.rightMargin: 976
    }
    width: 1920
    height: 1080
    color: "#161616"
    // Testing configuration file input
    /*
    TestCase {
        name: "ConfigImportTest"

        function test_Import() {
            // Formating constant file for testing.
            var file = "//TS\n";
            file = file + date.toLocaleString() + "\n\n";
            file = file + "//SDRSYS\n";
            file = file + "FVEH 1\n";
            file = file + "RFG  2\n";
            file = file + "IFG  3\n";
            file = file + "BBG  4\n";
            file = file + "\n";
            file += "//TAG\n";
            file += "Num  1\n";
            file += "FT  5\n";
            file += "FRS  6\n";
            file += "PD  7\n";
            file += "PR  8\n";
            file += "\n//NOTES\n";
            file += "Test notes\n";

            // Disasemble configuration file
            var lines = file.split("\n");
            console.log(lines);
            var remake = "";
            var iterator;
            for (iterator = 0; iterator < lines.length; iterator++) {
                if(lines[iterator].substring(0,1) === "" && (iterator !== lines.length-1)) {
                    //console.log("Removing solo newlines.");
                    iterator++;
                }
                if(lines[iterator].substring(0,2) === "//") {
                    //console.log("Removing comment.");
                    iterator++;
                }
                remake += lines[iterator];
                remake += "\n";
                //console.log("IN loop");
            }
            var reremake = remake.split("\n")

            verify(reremake[2].split(" ")[2] === "3", "IFGain check failed.");
            verify(reremake[3].split(" ")[2] === "2", "RFGain check failed.");
            verify(reremake[4].split(" ")[2] === "4", "BBGain check failed.");
            verify(reremake[8].split(" ")[2] === "7", "Pulse Duration check failed.");
            verify(reremake[9].split(" ")[2] === "8", "Pulse Repetition check failed.");
            verify(reremake[10].split(" ")[2] === "Test notes", "Notes check failed.");
            verify(reremake[6].split(" ")[2] === "5", "Tag Frequency check failed.");
            verify(reremake[1].split(" ")[2] === "1", "Radio Sampling rate check failed.");
            verify(reremake[7].split(" ")[2] === "6", "Telemetry Sample Ratecheck failed.");
        }
    }

    TestCase {
        name: "ConfigCreateTest"
        function test_create() {
            // Generate constant variables for output
            var text_rsr = 6;
            var text_fveh = 1;
            var text_fv = 5;
            var text_rf = 2;
            var text_if = 3;
            var text_bb = 4;
            var text_pd = 7;
            var text_pr = 8;
            var text_notes = "Text notes";

            // Formating constant file for testing.
            var file = "//TS\n";
            file = file + date.toLocaleString() + "\n\n";
            file = file + "//SDRSYS\n";
            file = file + "FVEH  " + text_fveh + "\n";
            file = file + "RFG  " + text_rf + "\n";
            file = file + "IFG  " + text_if + "\n";
            file = file + "BBG  " + text_bb + "\n";
            file = file + "\n";
            file += "//TAG\n";
            file += "Num  1\n";
            file += "FT  " + text_fv + "\n";
            file += "FRS  " + text_rsr + "\n";
            file += "PD  " + text_pd + "\n";
            file += "PR  " + text_pr + "\n";

            file += "\n//NOTES\n";
            file += text_notes + "\n";

            verify(text_rsr === "6", "FRS create failed.");
            verify(text_fveh === "1", "Frequency create failed.");
            verify(text_fv === "5", "FV create failed.");
            verify(text_rf === "2", "RF create failed.");
            verify(text_if === "3", "IF create failed.");
            verify(text_bb === "4", "BB create failed.");
            verify(text_pd === "7", "PR create failed.")
            verify(text_pr === "8", "RD create failed.")
            verify(text_notes === "Text notes", "Notes create failed.")
        }
    }
    */
}


