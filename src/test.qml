import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2

import QGroundControl.FactControls 1.0
import QGroundControl.Palette 1.0

import com.myself 1.0
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
            console.log(remake)
            console.log("XX")
            var reremake = remake.split("\n")
            console.log(reremake)
            console.log("XXX")
            console.log(reremake[0])
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
        x: 378
        y: 7
        width: 333
        height: 512
        color: "#2c2c2c"
    }

    Rectangle {
        id: udpBackground
        x: 843
        y: 7
        width: 360
        height: 855
        color: "#2c2c2c"
    }

    Grid {
        id: grid
        x: 402
        y: 43
        width: 400
        height: 400
        flow: Grid.LeftToRight
        scale: 1
        columns: 2
        spacing: 10

        Text {
            id: tagFreqLabel
            color: "#ffffff"
            text: qsTr("Tag Frequency (MHz)")
            font.pixelSize: 12
        }

        TextField {
            id: tagFreq
            placeholderText: qsTr("Text Field")
        }

        Text {
            id: rfGainLabel
            color: "#ffffff"
            text: qsTr("RF Gain (dB)")
            font.pixelSize: 12
        }

        TextField {
            id: rfGain
            placeholderText: qsTr("Text Field")
        }

        Text {
            id: ifGainLabel
            color: "#ffffff"
            text: qsTr("IF Gain (dB)")
            font.pixelSize: 12
        }

        TextField {
            id: ifGain
            placeholderText: qsTr("Text Field")
        }

        Text {
            id: bbGainLabel
            color: "#ffffff"
            text: qsTr("BB Gain (dB)")
            font.pixelSize: 12
        }

        TextField {
            id: bbGain
            placeholderText: qsTr("Text Field")
        }

        Text {
            id: radioSamplingRateLabel
            color: "#ffffff"
            text: qsTr("Radio Sampling Rate (HZ)")
            font.pixelSize: 12
        }

        TextField {
            id: radioSamplingRate
            placeholderText: qsTr("Text Field")
        }

        Text {
            id: pulseDurationLabel
            color: "#ffffff"
            text: qsTr("Pulse Duration (s)")
            font.pixelSize: 12
        }

        TextField {
            id: pulseDuration
            placeholderText: qsTr("Text Field")
        }

        Text {
            id: pulseRepetitionLabel
            color: "#ffffff"
            text: qsTr("Pulse Repetition Rate (s)")
            font.pixelSize: 12
        }

        TextField {
            id: pulseRepetition
            placeholderText: qsTr("Text Field")
        }

        Text {
            id: uavTelemetrySampleRateLabel
            color: "#ffffff"
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
        x: 410
        y: 449
        text: "Config name"
        placeholderText: qsTr("Text Field")
    }

    Text {
        id: flightNotesLael
        x: 410
        y: 316
        color: "#ffffff"
        text: qsTr("Flight Notes")
        font.pixelSize: 12
    }

    Button {
        id: saveConfigButton
        onClicked: saveFileDialog.open()
        x: 414
        y: 478
        text: qsTr("Save")
    }

    TextArea {
        id: flightNotes
        x: 410
        y: 337
        width: 285
        height: 106
    }

    Text {
        id: flightSettingsLabel
        x: 402
        y: 8
        color: "#ffffff"
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
        x: 864
        y: 43
        text: qsTr("Connect")
        onClicked: {
            ftpObject.connectClicked(ipInput.text)
        }

    }

    Button {
        id: importSettingsButton
        onClicked: openFileDialog.open()
        x: 592
        y: 449
        text: qsTr("Import Settings")
    }

    Button {
        id: disconnectFTPButton
        x: 864
        y: 77
        text: qsTr("Disconnect")
        anchors.rightMargin: 976
        onClicked:{
            ftpObject.closeFTP()
        }
    }

    Text {
        id: systemControlLabel
        x: 864
        y: 8
        color: "#ffffff"
        text: qsTr("System Control")
        anchors.rightMargin: 976
        font.pixelSize: 20
    }

    Button {
        id: sendSettingsButton
        x: 592
        y: 478
        text: qsTr("Send Settings")
    }

    Button {
        id: startRadioButton
        x: 864
        y: 124
        text: qsTr("Start Radio")
        anchors.rightMargin: 976
        onClicked:
            ftpObject.downloadContent()
    }

    Button {
        id: stopRadioButton
        x: 950
        y: 124
        text: qsTr("Stop Radio")
        anchors.rightMargin: 976
    }


    Button {
        id: dowloadFtpButton
        x: 864
        y: 106
        text: qsTr("Download")
        onClicked:
            ftpObject.downloadContent()
    }

    Button {
        id: uploadFtpButton
        x: 950
        y: 106
        text: qsTr("Upload")
        onClicked:
            ftpObject.uploadContent()
    }


    Text {
        id: connectionStatusLabel
        x: 956
        y: 47
        color: "#ffffff"
        text: qsTr("Connection Status")
        anchors.rightMargin: 976
        font.pixelSize: 12
    }

    TextField {
        id: ipInput
        objectName: "ipInput"
        x: 1083
        y: 47
        text: qsTr("ftp.dlptest.com")
        anchors.rightMargin: 976
        font.pixelSize: 12
    }


    Text {
        id: element
        x: 1114
        y: 53
        color: "#ffffff"
        text: qsTr("Status")
        anchors.rightMargin: 976
        font.pixelSize: 12
    }

    TextField {
        id: textField
        x: 1083
        y: 72
        text: "Unknown"
        anchors.rightMargin: 976
        placeholderText: qsTr("Text Field")
    }

    Text {
        id: lastHeartBeatLabel
        x: 1095
        y: 92
        color: "#ffffff"
        text: qsTr("Last Heartbeat")
        anchors.rightMargin: 976
        font.pixelSize: 12
    }

    TextField {
        id: lastHeartbeat
        x: 1083
        y: 107
        text: "0"
        anchors.rightMargin: 976
        placeholderText: qsTr("Text Field")
    }

    Text {
        id: ftpLabel
        x: 965
        y: 85
        color: "#ffffff"
        text: qsTr("FTP")
        anchors.rightMargin: 976
        font.pixelSize: 12
    }

    Text {
        id: udpLabel
        x: 1025
        y: 85
        color: "#ffffff"
        text: qsTr("UDP")
        anchors.rightMargin: 976
        font.pixelSize: 12
    }

    TextArea {
        id: terminalArea
        objectName: "testOutput"
        x: 864
        y: 154
        width: 320
        height: 300
        anchors.rightMargin: 976
        text: udpObject.logFile
    }

    TextArea {
        id: ftpTerminalArea
        objectName: "testOutput"
        x: 864
        y: 460
        width: 320
        height: 300
        anchors.rightMargin: 976
        text: ftpObject.logFile
    }

    Text {
        id: element1
        x: 1054
        y: 135
        color: "#ffffff"
        text: qsTr("Vehicle Terminal Area")
        anchors.rightMargin: 976
        font.pixelSize: 12
    }

    ToolButton {
        id: clearTerminalButton
        x: 890
        y: 770
        text: "Clear Terminal"
        anchors.rightMargin: 976
    }

    ToolButton {
        id: cleanConnectionButton
        x: 870
        y: 798
        text: "Clean up Connection"
        anchors.rightMargin: 976
    }

    ToolButton {
        id: connectionSettingsButton
        x: 872
        y: 826
        text: "Connection Settings"
        anchors.rightMargin: 976
    }

    ToolButton {
        id: refreshIPButton
        //objectName: refreshIPButtonName
        x: 1028
        y: 798
        text: "Refresh IP"
        anchors.rightMargin: 976
    }

    ToolButton {
        id: snapWindowButton
        x: 1016
        y: 826
        text: "Snap Window"
        anchors.rightMargin: 976
        onClicked: udpObject.HelloUDP();
    }



    width: 1920
    height: 1080
    color: "#161616"
    // palette.text
}
