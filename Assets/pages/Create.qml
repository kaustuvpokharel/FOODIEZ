import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import QtQuick.Dialogs

Item {
    id: root
    width: parent.width
    height: parent.height

    property string selectedFilePath: ""

    Rectangle {
        anchors.fill: parent
        color: "#121212"

        ScrollView {
            anchors.fill: parent
            contentWidth: parent.width
            clip: true

            ColumnLayout {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 20
                anchors.margins: 20

                Text {
                    text: "Create New Post"
                    color: "#ffffff"
                    font.pixelSize: 24
                    font.family: "pBold"
                    font.weight: 700
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 20
                }

                // Upload area
                Rectangle {
                    id: uploadArea
                    Layout.fillWidth: true
                    Layout.preferredHeight: 200
                    Layout.margins: 20
                    color: "#121212"
                    radius: 12
                    border.color: "#9C27B0"
                    border.width: 2

                    Item {
                        anchors.fill: parent
                        visible: selectedFilePath === ""

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 12

                            Image {
                                source: "qrc:/icons/Assets/icons/image.png"
                                width: 32
                                height: 32
                                Layout.alignment: Qt.AlignHCenter
                            }

                            Text {
                                text: "Tap to upload media"
                                color: "#9C27B0"
                                font.pixelSize: 16
                                font.family: "pSemibold"
                                font.weight: 600
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }

                    Image {
                        anchors.fill: parent
                        visible: selectedFilePath !== ""
                        source: selectedFilePath
                        fillMode: Image.PreserveAspectCrop
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: fileDialog.open()
                    }
                }

                // Caption input
                Rectangle {
                    id: captionBox
                    Layout.fillWidth: true
                    Layout.margins: 20
                    Layout.preferredHeight: 120
                    color: "#1A1A1A"
                    radius: 8

                    TextArea {
                        id: captionField
                        anchors.fill: parent
                        anchors.margins: 12
                        placeholderText: "Write a caption..."
                        placeholderTextColor: "#666666"
                        color: "#ffffff"
                        font.pixelSize: 16
                        font.family: "pMedium"
                        font.weight: 500
                        wrapMode: TextArea.Wrap
                        clip: true

                        background: Rectangle {
                            color: "transparent"
                        }

                        ScrollBar.vertical: ScrollBar {
                            policy: ScrollBar.AsNeeded
                        }
                    }
                }

                // Options list
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.margins: 20
                    spacing: 12

                    Rectangle {
                        Layout.fillWidth: true
                        height: 56
                        color: "#1A1A1A"
                        radius: 8
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 16
                            Image { source: "qrc:/icons/Assets/icons/tag.png"; width: 24; height: 24 }
                            Text {
                                text: "Add tags"
                                color: "#ffffff"
                                font.pixelSize: 16
                                font.family: "pMedium"
                                font.weight: 500
                            }
                            Item { Layout.fillWidth: true }
                            Image { source: "qrc:/icons/Assets/icons/chevron-right.png"; width: 16; height: 16 }
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: console.log("Add tags clicked")
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 56
                        color: "#1A1A1A"
                        radius: 8
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 16
                            Image { source: "qrc:/icons/Assets/icons/lock.png"; width: 24; height: 24 }
                            Text {
                                text: "Privacy settings"
                                color: "#ffffff"
                                font.pixelSize: 16
                                font.family: "pMedium"
                                font.weight: 500
                            }
                            Item { Layout.fillWidth: true }
                            Image { source: "qrc:/icons/Assets/icons/chevron-right.png"; width: 16; height: 16 }
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: console.log("Privacy settings clicked")
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 56
                        color: "#1A1A1A"
                        radius: 8
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 16
                            Image { source: "qrc:/icons/Assets/icons/globe.png"; width: 24; height: 24 }
                            Text {
                                text: "Share to"
                                color: "#ffffff"
                                font.pixelSize: 16
                                font.family: "pMedium"
                                font.weight: 500
                            }
                            Item { Layout.fillWidth: true }
                            Image { source: "qrc:/icons/Assets/icons/chevron-right.png"; width: 16; height: 16 }
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: console.log("Share to clicked")
                        }
                    }
                }

                // Post button
                Rectangle {
                    Layout.fillWidth: true
                    Layout.margins: 20
                    height: 56
                    color: "#9C27B0"
                    radius: 8
                    Layout.bottomMargin: 40

                    Text {
                        anchors.centerIn: parent
                        text: "Post"
                        color: "#ffffff"
                        font.pixelSize: 16
                        font.family: "pMedium"
                        font.weight: 500
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (selectedFilePath !== "") {
                                uploadModel.uploadPost(selectedFilePath, captionField.text)
                            } else {
                                resultLabel.text = "Please select a file to upload."
                                resultDialog.open()
                            }
                        }
                    }
                }
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "Select image or video"
        nameFilters: ["Images (*.png *.jpg *.jpeg)", "Videos (*.mp4 *.mov)", "All files (*)"]
        onAccepted: {
            selectedFilePath = fileDialog.fileUrl.toString().replace("file://", "")
        }
    }

    Dialog {
            id: resultDialog
            title: "Upload:"
            standardButtons: Dialog.Ok
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2

            Label
            {
                id: resultLabel
                text: ""
                color: "#9C27B0"
                wrapMode: Text.WordWrap
                width: parent.width - 40
            }
        }


    Connections {
        target: uploadModel
        onUploadFinished: (success, message) => {
            resultLabel.text = message
            resultDialog.open()
        }
    }
}
