import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import QtQuick.Dialogs
import QtMultimedia

Item {
    id: root
    width: parent.width
    height: parent.height

    property string selectedFilePath: ""
    property bool previewingPost: false
    property bool uploading: false
    property real uploadProgressValue: 0

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

                    Loader {
                        anchors.fill: parent
                        visible: selectedFilePath !== ""
                        sourceComponent: selectedFilePath.endsWith(".mp4") || selectedFilePath.endsWith(".mov")
                            ? videoPreview : imagePreview
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            fileDialog.open()
                            console.log("File dialog opened")
                        }
                    }
                }

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
                    }
                }

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
                        enabled: !uploading
                        onClicked: {
                            uploading = true
                            let filePath = Qt.platform.os === "android" ? selectedFilePath : selectedFilePath.replace("file://", "")
                            uploadModel.uploadPost(filePath, captionField.text)
                        }
                    }
                }
            }
        }
    }

    FileDialog
    {
        id: fileDialog
        title: "Select image or video"
        nameFilters: ["Images (*.png *.jpg *.jpeg)", "Videos (*.mp4 *.mov)"]

        onAccepted: {
            let file = fileDialog.selectedFile || (fileDialog.selectedFiles && fileDialog.selectedFiles.length > 0 ? fileDialog.selectedFiles[0] : "")
            if (file) {
                selectedFilePath = file.toString()
                console.log("Selected file:", selectedFilePath)
            } else {
                console.log("No file selected")
            }
        }
    }

    Dialog {
        id: resultDialog
        title: "Upload:"
        standardButtons: Dialog.Ok
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        Label {
            id: resultLabel
            text: ""
            color: "#9C27B0"
            wrapMode: Text.WordWrap
            width: parent.width - 40
        }
    }

    Connections {
        target: uploadModel

        function onUploadFinished(success, message) {
            resultLabel.text = message
            resultDialog.open()

            if (success) {
                selectedFilePath = ""
                captionField.text = ""
                previewingPost = false

                // Optional: Refresh posts or profile after upload
                postModel.fetchPosts()
                profileModel.fetchUserProfile()
            }

            uploading = false
            uploadProgressValue = 0
        }

        function onUploadProgress(sent, total) {
            uploadProgressValue = total > 0 ? sent / total : 0
        }
    }

    Rectangle {
        visible: previewingPost
        anchors.fill: parent
        color: "#121212EE"
        z: 9999

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 20
            width: parent.width * 0.9

            Rectangle {
                width: parent.width
                height: 400
                radius: 12
                color: "#1A1A1A"

                Loader {
                    anchors.fill: parent
                    sourceComponent: selectedFilePath.endsWith(".mp4") || selectedFilePath.endsWith(".mov")
                        ? videoPreview : imagePreview
                }
            }

            Text {
                text: captionField.text
                color: "#ffffff"
                font.pixelSize: 16
                wrapMode: Text.Wrap
            }

            RowLayout {
                width: parent.width
                spacing: 12

                Rectangle {
                    Layout.fillWidth: true
                    height: 48
                    radius: 8
                    color: "#444444"

                    Text {
                        anchors.centerIn: parent
                        text: "Cancel"
                        color: "#ffffff"
                        font.pixelSize: 16
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            previewingPost = false
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 48
                    radius: 8
                    color: "#9C27B0"

                    Text {
                        anchors.centerIn: parent
                        text: uploading ? "Uploading..." : "Confirm & Post"
                        color: "#ffffff"
                        font.pixelSize: 16
                    }

                    MouseArea {
                        anchors.fill: parent
                        enabled: !uploading
                        onClicked: {
                            if (selectedFilePath === "" || captionField.text.trim() === "") {
                                resultLabel.text = "Please select a file and write a caption."
                                resultDialog.open()
                                return
                            }

                            let validExt = /\.(jpg|jpeg|png|mp4|mov)$/i.test(selectedFilePath)
                            if (!validExt) {
                                resultLabel.text = "Invalid file format. Please select an image or video."
                                resultDialog.open()
                                return
                            }

                            uploading = true
                            let filePath = Qt.platform.os === "android" ? selectedFilePath : selectedFilePath.replace("file://", "")
                            uploadModel.uploadPost(filePath, captionField.text)
                        }
                    }
                }
            }

            ProgressBar {
                visible: uploading
                from: 0
                to: 1
                value: uploadProgressValue
                Layout.fillWidth: true
            }
        }
    }

    Component {
        id: imagePreview
        Image {
            anchors.fill: parent
            source: selectedFilePath  // already includes "file://"
            fillMode: Image.PreserveAspectCrop
            cache: false
            asynchronous: true
        }
    }

    Component {
        id: videoPreview
        Video {
            anchors.fill: parent
            source: selectedFilePath  // already includes "file://"
            loops: MediaPlayer.Infinite
            //autoPlay: true
        }
    }
}
