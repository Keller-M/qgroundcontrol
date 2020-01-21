import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.4

import QGroundControl.FactControls 1.0
import QGroundControl.Palette 1.0

//import qgroundcontrol.Sources.src.myconfig_manager 1.0

Rectangle {
    id: rectangle

    Grid {
        id: grid
        x: 0
        y: 35
        width: 400
        height: 400
        scale: 1
        columns: 2
        spacing: 10

        Text {
            id: tagFreqLabel
            text: qsTr("Tag Frequency (MHz)")
            font.pixelSize: 12
        }

        TextField {
            id: tagFreq
            placeholderText: qsTr("Text Field")
        }

        Text {
            id: rfGainLabel
            text: qsTr("RF Gain (dB)")
            font.pixelSize: 12
        }

        TextField {
            id: rfGain
            placeholderText: qsTr("Text Field")
        }

        Text {
            id: ifGainLabel
            text: qsTr("IF Gain (dB)")
            font.pixelSize: 12
        }

        TextField {
            id: ifGain
            placeholderText: qsTr("Text Field")
        }

        Text {
            id: bbGainLabel
            text: qsTr("BB Gain (dB)")
            font.pixelSize: 12
        }

        TextField {
            id: bbGain
            placeholderText: qsTr("Text Field")
        }

        Text {
            id: radioSamplingRateLabel
            text: qsTr("Radio Sampling Rate (HZ)")
            font.pixelSize: 12
        }

        TextField {
            id: radioSamplingRate
            placeholderText: qsTr("Text Field")
        }

        Text {
            id: pulseDurationLabel
            text: qsTr("Pulse Duration (s)")
            font.pixelSize: 12
        }

        TextField {
            id: pulseDuration
            placeholderText: qsTr("Text Field")
        }

        Text {
            id: pulseRepetitionLabel
            text: qsTr("Pulse Reptition Rate (s)")
            font.pixelSize: 12
        }

        TextField {
            id: pulseReptition
            placeholderText: qsTr("Text Field")
        }

        Text {
            id: uavTelemetrySampleRateLabel
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
        x: 8
        y: 441
        text: "Config name"
        placeholderText: qsTr("Text Field")
    }

    Text {
        id: flightNotesLael
        x: 8
        y: 308
        text: qsTr("Flight Notes")
        font.pixelSize: 12
    }

    Button {
        id: saveConfigButton
        x: 12
        y: 470
        text: qsTr("Save")
    }

    TextArea {
        id: flightNotes
        x: 8
        y: 329
        width: 285
        height: 106
    }

    Text {
        id: flightSettingsLabel
        x: 0
        y: 0
        text: qsTr("Flight Settings")
        font.pixelSize: 20
    }

    Button {
        id: connectFTPButton
        x: 352
        y: 49
        text: qsTr("Connect")

    }

    Button {
        id: importSettingsButton
        x: 190
        y: 441
        text: qsTr("Import Settings")
    }

    Button {
        id: disconnectFTPButton
        x: 352
        y: 77
        text: qsTr("Disconnect")
    }

    Text {
        id: systemControlLabel
        x: 352
        y: 8
        text: qsTr("System Control")
        font.pixelSize: 20
    }

    Button {
        id: sendSettingsButton
        x: 190
        y: 470
        text: qsTr("Send Settings")
    }

    Button {
        id: startRadioButton
        x: 352
        y: 106
        text: qsTr("Start Radio")
    }

    Button {
        id: stopRadioButton
        x: 438
        y: 106
        text: qsTr("Stop Radio")
    }

    Text {
        id: connectionStatusLabel
        x: 444
        y: 47
        text: qsTr("Connection Status")
        font.pixelSize: 12
    }

    Text {
        id: element
        x: 602
        y: 53
        text: qsTr("Status")
        font.pixelSize: 12
    }

    TextField {
        id: textField
        x: 571
        y: 72
        text: "Unknown"
        placeholderText: qsTr("Text Field")
    }

    Text {
        id: lastHeartBeatLabel
        x: 583
        y: 92
        text: qsTr("Last Heartbeat")
        font.pixelSize: 12
    }

    TextField {
        id: lastHeartbeat
        x: 571
        y: 107
        text: "0"
        placeholderText: qsTr("Text Field")
    }

    Text {
        id: ftpLabel
        x: 453
        y: 85
        text: qsTr("FTP")
        font.pixelSize: 12
    }

    Text {
        id: udpLabel
        x: 513
        y: 85
        text: qsTr("UDP")
        font.pixelSize: 12
    }

    TextArea {
        id: terminalArea
        x: 352
        y: 154
        width: 320
        height: 602
    }

    Text {
        id: element1
        x: 542
        y: 135
        text: qsTr("Vehicle Terminal Area")
        font.pixelSize: 12
    }

    ToolButton {
        id: clearTerminalButton
        x: 378
        y: 770
        text: "Clear Terminal"
    }

    ToolButton {
        id: cleanConnectionButton
        x: 358
        y: 798
        text: "Clean up Connection"
    }

    ToolButton {
        id: connectionSettingsButton
        x: 360
        y: 826
        text: "Connection Settings"
    }

    ToolButton {
        id: refreshIPButton
        //objectName: refreshIPButtonName
        x: 516
        y: 798
        text: "Refresh IP"
    }

    ToolButton {
        id: snapWindowButton
        x: 504
        y: 826
        text: "Snap Window"
    }

    width: 100
    height: 100
    color: "#e43f3f"
    // palette.text
}
