import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    width: parent.width
    height: parent.height

    property int currentTabIndex: 0

    property var tabScreens:
    [
        {icon: "home", activeIcon: "home_filled", label:"Home", component: homeComponent},
        {icon: "search", activeIcon: "search_filled", label:"Explore", component: exploreComponent},
        {icon: "add", activeIcon: "add_filled", label:"Create", component: createComponent},
        {icon: "video", activeIcon: "video_filled", label:"Reels", component: reelsComponent},
        {icon: "user", activeIcon: "user_filled", label:"Profile", component: profileComponent},
    ]

    Component
    {
        id: homeComponent; Home{}
    }

    Component
    {
        id: exploreComponent; Explore{}
    }

    Component
    {
        id: createComponent; Create{}
    }

    Component
    {
        id: reelsComponent; Reels{}
    }

    Component
    {
        id: profileComponent; Profile{}
    }

    Rectangle
    {
        anchors.fill: parent
        color: "#121212"

        Column
        {
            width: parent.width
            height: parent.height
            spacing: 0

            Item {
                width: parent.width
                height: parent.height - 60
                clip: true

                Loader
                {
                    id: contentLoader
                    anchors.fill: parent
                    sourceComponent: tabScreens[root.currentTabIndex].component
                }
            }

            Rectangle
            {
                id: navBar
                width: parent.width
                height: 60
                color: "#1A1A1A"

                Row
                {
                    width: parent.width
                    height: parent.height
                    spacing: 0
                    anchors.horizontalCenter: parent.horizontalCenter

                    Repeater
                    {
                        model: tabScreens

                        Rectangle
                        {
                            width: parent.width / tabScreens.length
                            height: parent.height
                            color: "transparent"

                            Column
                            {
                                width: parent.width
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 2

                                Image {

                                    source: "qrc:/icons/Assets/icons/" +
                                            (index === root.currentTabIndex ? modelData.activeIcon : modelData.icon) + ".png"
                                    width: 24
                                    height: 24
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }

                            MouseArea
                            {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked:
                                {
                                    root.currentTabIndex = index;
                                    contentLoader.sourceComponent = modelData.component;
                                    console.log("Switeched to tab: ", modelData.label);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
