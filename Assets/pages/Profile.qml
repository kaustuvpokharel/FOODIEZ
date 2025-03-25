import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Item {
    id: root
    width: parent.width
    height: parent.height

    Rectangle {
        anchors.fill: parent
        color: "#121212"

        ScrollView {
            id: scrollView
            anchors.fill: parent
            contentWidth: availableWidth
            clip: true

            ColumnLayout {
                width: scrollView.width
                spacing: 16

                // Header
                RowLayout {
                    Layout.fillWidth: true
                    Layout.margins: 16

                    Text {
                        text: profileModel.userName
                        color: "white"
                        font.pixelSize: 20
                        font.bold: true
                    }

                    Item { Layout.fillWidth: true }

                    RowLayout {
                        spacing: 16

                        Image {
                            source: "qrc:/icons/Assets/icons/plus.png"
                            sourceSize: Qt.size(24, 24)
                        }

                        Image {
                            source: "qrc:/icons/Assets/icons/settings.png"
                            sourceSize: Qt.size(24, 24)
                        }
                    }
                }

                // Avatar + Stats
                RowLayout {
                    Layout.fillWidth: true
                    Layout.leftMargin: 16
                    Layout.rightMargin: 16
                    spacing: 32

                    // Avatar
                    Item {
                        Layout.preferredWidth: 80
                        Layout.preferredHeight: 80

                        Image {
                            anchors.fill: parent
                            source: profileModel.dpImage
                            fillMode: Image.PreserveAspectCrop
                            layer.enabled: true
                            layer.effect: OpacityMask {
                                maskSource: Rectangle {
                                    width: 80
                                    height: 80
                                    radius: 40
                                }
                            }
                        }

                        Rectangle {
                            width: 28; height: 28
                            radius: 14
                            color: "#9C27B0"
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right

                            Image {
                                anchors.centerIn: parent
                                source: "qrc:/icons/Assets/icons/edit.png"
                                sourceSize: Qt.size(16, 16)
                            }
                        }
                    }

                    // Stats
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 24

                        Repeater {
                            model: [
                                { label: "Posts", value: profileModel.posts.length },
                                { label: "Followers", value: profileModel.followers },
                                { label: "Following", value: profileModel.following }
                            ]

                            ColumnLayout {
                                spacing: 4
                                Text {
                                    text: modelData.value
                                    color: "white"
                                    font.pixelSize: 18
                                    font.bold: true
                                }

                                Text {
                                    text: modelData.label
                                    color: "#888"
                                    font.pixelSize: 12
                                }
                            }
                        }
                    }
                }

                // Bio
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.leftMargin: 16
                    Layout.rightMargin: 16
                    spacing: 4

                    Text {
                        text: profileModel.userName
                        color: "white"
                        font.bold: true
                        font.pixelSize: 16
                    }

                    Text {
                        text: profileModel.bio
                        color: "white"
                        font.pixelSize: 14
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }

                    Text {
                        text: profileModel.website
                        color: "#9C27B0"
                        font.pixelSize: 14
                    }
                }

                // Edit Profile Button
                Rectangle {
                    Layout.fillWidth: true
                    Layout.leftMargin: 16
                    Layout.rightMargin: 16
                    height: 36
                    radius: 8
                    color: "#1A1A1A"
                    border.color: "#333"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "Edit Profile"
                        color: "white"
                        font.pixelSize: 14
                    }
                }

                // Tabs
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    Repeater {
                        model: ["grid", "video", "bookmark"]

                        Rectangle {
                            Layout.fillWidth: true
                            height: 48
                            color: "transparent"
                            border.color: index === 0 ? "#9C27B0" : "transparent"
                            border.width: 2

                            Image {
                                anchors.centerIn: parent
                                source: "qrc:/icons/Assets/icons/" + modelData + ".png"
                                sourceSize: Qt.size(24, 24)
                                opacity: index === 0 ? 1.0 : 0.5
                            }
                        }
                    }
                }

                // Post Grid
                GridLayout {
                    Layout.fillWidth: true
                    columns: 3
                    rowSpacing: 1
                    columnSpacing: 1

                    Repeater {
                        model: profileModel.posts

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.preferredHeight: width
                            color: "black"

                            Image {
                                anchors.fill: parent
                                source: modelData.image
                                fillMode: Image.PreserveAspectCrop
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: console.log("Post clicked:", modelData.id)
                            }
                        }
                    }
                }

                // Bottom spacing
                Item {
                    height: 16
                }
            }
        }
    }
}
