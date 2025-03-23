import QtQuick
import QtQuick.Controls
import "./Assets/pages"

Window {
    id: window
    width: 390 //width our mobile for prototyping
    height: 844 //Height our mobile for prototyping
    visible: true
    title: qsTr("FOODIEZ")
    color: "#121212"

    FontLoader
    {
        id: pBold
        source: "qrc:/fonts/Assets/fonts/Poppins-Bold.ttf"
    }
    FontLoader
    {
        id: pMedium
        source: "qrc:/fonts/Assets/fonts/Poppins-Medium.ttf"
    }
    FontLoader
    {
        id: pRegular
        source: "qrc:/fonts/Assets/fonts/Poppins-Regular.ttf"
    }
    FontLoader
    {
        id: pSemibold
        source: "qrc:/fonts/Assets/fonts/Poppins-SemiBold.ttf"
    }

    StackView
    {
        id: mainStack
        anchors.fill: parent
        initialItem: loginScreen

        replaceEnter: Transition
        {
            PropertyAnimation
            {
                property: "opacity"
                from:0
                to: 1
                duration: 300 //this is in ms which is millisecond
            }
        }
        replaceExit: Transition
        {
            PropertyAnimation
            {
                property: "opacity"
                from:1
                to: 0
                duration: 300 //this is in ms which is millisecond
            }
        }
    }

    Component
    {
        id: loginScreen
        Login
        {
            onLoginSuccessful:
            {
                console.log("Login Successful: Need to give access to the application");
                mainStack.replace(mainContentScreen);
            }
        }
    }

    Component
    {
        id: mainContentScreen
        MainContent
        {
            //For inplementation placeholder for my pages later on
        }
    }
}
