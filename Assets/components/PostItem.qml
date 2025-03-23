import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: root
    width: parent.width
    height: 800
    color: "#121212"

    property var postData: postData || {}
    property bool isLiked: false
    property bool showCommentBox: false
    property string newComment: ""

    ListModel {
        id: commentModel
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Post Header
        Rectangle {
            Layout.fillWidth: true
            height: 50
            color: "transparent"

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 10

                Rectangle {
                    width: 36
                    height: 36
                    radius: 18
                    color: "transparent"

                    Image {
                        id: profileImage
                        width: 36
                        height: 36
                        source: postData?.user?.avatar || "qrc:/avatar/Assets/images/default_avatar.png"
                        fillMode: Image.PreserveAspectCrop
                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: Rectangle {
                                width: 36
                                height: 36
                                radius: 18
                            }
                        }
                    }
                }

                Text {
                    text: postData?.user?.name || "Unknown"
                    color: "#ffffff"
                    font.pixelSize: 14
                    font.family: "Inter"
                    font.weight: Font.Bold
                }

                Item { Layout.fillWidth: true }

                Image {
                    source: "qrc:/icons/Assets/icons/more-horizontal.png"
                    width: 24
                    height: 24
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: console.log("More options clicked")
                    }
                }
            }
        }

        // Post Image
        Rectangle {
            Layout.fillWidth: true
            Layout.topMargin: -20
            height: 400
            color: "#1A1A1A"
            clip: true

            Image {
                anchors.fill: parent
                source: postData?.image || "qrc:/placeholders/Assets/images/placeholder.png"
                fillMode: Image.PreserveAspectCrop
            }
        }

        // Action Buttons
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            Layout.leftMargin: 12
            Layout.rightMargin: 12
            Layout.topMargin: -20
            spacing: 16

            Image {
                source: root.isLiked ? "qrc:/icons/Assets/icons/heart-filled.png" : "qrc:/icons/Assets/icons/heart.png"
                width: 28
                height: 28
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.isLiked = !root.isLiked
                        console.log("Like toggled:", root.isLiked)
                    }
                }
            }

            Image {
                source: "qrc:/icons/Assets/icons/message-circle.png"
                width: 28
                height: 28
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.showCommentBox = !root.showCommentBox
                    }
                }
            }

            Image {
                source: "qrc:/icons/Assets/icons/share.png"
                width: 28
                height: 28
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: console.log("Share clicked")
                }
            }

            Item { Layout.fillWidth: true }

            Image {
                source: "qrc:/icons/Assets/icons/bookmark.png"
                width: 28
                height: 28
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: console.log("Bookmark clicked")
                }
            }
        }

        // Like Count
        Text {
            Layout.leftMargin: 12
            Layout.topMargin: -10
            text: (postData?.likes || 0) + (root.isLiked ? 1 : 0) + " likes"
            color: "#ffffff"
            font.pixelSize: 14
            font.weight: Font.Bold
        }

        // Caption
        Column {
            Layout.fillWidth: true
            Layout.leftMargin: 12
            Layout.rightMargin: 12
            Layout.topMargin: 10
            spacing: 2

            Text {
                text: postData?.user?.name || "Unknown"
                color: "#ffffff"
                font.weight: Font.Bold
                font.pixelSize: 14
            }

            Text {
                text: postData?.caption || ""
                color: "#ffffff"
                wrapMode: Text.Wrap
                width: parent.width - 24
            }
        }

        // Comment List
        ListView {
            Layout.fillWidth: true
            Layout.leftMargin: 12
            Layout.rightMargin: 12
            Layout.topMargin: 10
            height: Math.min(commentModel.count * 30, 120)
            model: commentModel
            delegate: Text {
                text: model.display
                color: "#cccccc"
                font.pixelSize: 14
                wrapMode: Text.Wrap
            }
        }

        // Comment Input
        Rectangle {
            Layout.fillWidth: true
            Layout.leftMargin: 12
            Layout.rightMargin: 12
            Layout.topMargin: 10
            height: 40
            visible: root.showCommentBox
            color: "#1E1E1E"
            radius: 6
            border.color: "#3A3A3A"

            RowLayout {
                anchors.fill: parent
                anchors.margins: 6
                spacing: 6

                TextField {
                    id: commentField
                    Layout.fillWidth: true
                    placeholderText: "Add a comment..."
                    text: root.newComment
                    onTextChanged: root.newComment = text
                    color: "#ffffff"
                    font.pixelSize: 14
                    background: null
                }

                Button {
                    text: "Post"
                    enabled: root.newComment.length > 0
                    onClicked: {
                        commentModel.append({ display: root.newComment })
                        console.log("Comment posted:", root.newComment)
                        root.newComment = ""
                        commentField.text = ""
                    }
                }
            }
        }

        // Try Me Button
        Rectangle {
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: 12
            Layout.topMargin: 10
            width: 80
            height: 32
            radius: 16
            color: "#8A2BE2"

            Text {
                anchors.centerIn: parent
                text: "Try Me"
                color: "#ffffff"
                font.pixelSize: 14
                font.weight: Font.Bold
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: console.log("Try Me clicked")
            }
        }
    }
}
