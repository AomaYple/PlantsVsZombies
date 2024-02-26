import QtQuick

Item {
    id: root

    signal backToMainMenu
    signal chose
    signal started

    clip: true

    Image {
        id: background

        asynchronous: true
        height: parent.height
        mipmap: true
        source: '../../resources/images/daytimeGrass.png'
        sourceSize: Qt.size(width, height)
        width: height / 2400 * 5600

        onStatusChanged: if (status === Image.Ready)
            pauseView.start()

        Zombie {
            id: basicZombie1

            height: parent.height * 0.2
            source: '../../resources/gif/basicZombieStand1.gif'
            width: height / 125 * 82
            x: parent.width * 0.8
            y: parent.height * 0.5
        }
        Zombie {
            id: basicZombie2

            height: parent.height * 0.2
            source: '../../resources/gif/basicZombieStand1.gif'
            width: height / 121 * 82
            x: parent.width * 0.85
            y: parent.height * 0.3
        }
        Zombie {
            id: basicZombie3

            height: parent.height * 0.2
            source: '../../resources/gif/basicZombieStand2.gif'
            width: height / 121 * 82
            x: parent.width * 0.83
            y: parent.height * 0.4
        }
        Zombie {
            id: basicZombie4

            height: parent.height * 0.2
            source: '../../resources/gif/basicZombieStand2.gif'
            width: height / 125 * 82
            x: parent.width * 0.75
            y: parent.height * 0.2
        }
        Timer {
            id: pauseView

            interval: 1500

            onTriggered: leftRightMove.start()
        }
        XAnimator {
            id: leftRightMove

            duration: 2000
            target: background
            to: root.width - background.width

            onFinished: {
                if (to === root.width - background.width) {
                    pauseView.start();
                    to = -background.width * 0.157;
                } else {
                    basicZombie1.source = basicZombie2.source = basicZombie3.source = basicZombie4.source = '';
                    readySetPlant.source = '../../resources/images/startReady.png';
                    seedBankEmerge.start();
                    root.chose();
                }
            }
        }
    }
    MouseArea {
        id: globalMouseArea

        anchors.fill: parent
        hoverEnabled: true

        onPositionChanged: if (shovelBank.shoveling) {
            shovel.x = mouseX - shovel.width / 2;
            shovel.y = mouseY - shovel.height / 2;
        }
    }
    Image {
        id: readySetPlant

        anchors.centerIn: parent
        asynchronous: true
        height: parent.height * 0.3
        mipmap: true
        sourceSize: Qt.size(width, height)
        width: height / 408 * 864

        onStatusChanged: if (status === Image.Ready) {
            if (source.toString() !== '../../resources/images/startPlant.png')
                imageEnlarge.start();
            switchInterval.start();
        }

        Timer {
            id: switchInterval

            interval: 700

            onTriggered: {
                if (parent.source.toString() === '../../resources/images/startReady.png') {
                    imageEnlarge.stop();
                    parent.source = '../../resources/images/startSet.png';
                    start();
                } else if (parent.source.toString() === '../../resources/images/startSet.png') {
                    imageEnlarge.stop();
                    parent.source = '../../resources/images/startPlant.png';
                    start();
                } else {
                    parent.source = '';
                    shovelBank.visible = menuButton.visible = true;
                    menuButton.forceActiveFocus();
                    root.started();
                }
            }
        }
        ScaleAnimator {
            id: imageEnlarge

            duration: 300
            target: readySetPlant
            to: 1.3

            onStopped: readySetPlant.scale = 1
        }
    }
    SeedBank {
        id: seedBank

        height: parent.height * 0.15
        width: height / 348 * 1784
        x: parent.width * 0.01
        y: -height

        YAnimator {
            id: seedBankEmerge

            duration: 500
            target: seedBank
            to: 0
        }
    }
    ShovelBank {
        id: shovelBank

        property bool shoveling: false

        anchors.left: seedBank.right
        height: parent.height * 0.12
        visible: false
        width: height / 288 * 280
        y: 0

        onClicked: {
            if (shoveling) {
                shoveling = false;
                shovel.x = x + (width - shovel.width) / 2;
                shovel.y = y + (height - shovel.height) / 2;
            } else
                shoveling = true;
        }
    }
    Image {
        id: shovel

        asynchronous: true
        height: shovelBank.height * 0.8
        mipmap: true
        source: '../../resources/images/shovel.png'
        sourceSize: Qt.size(width, height)
        visible: shovelBank.visible
        width: height / 256 * 244
        x: shovelBank.x + (shovelBank.width - width) / 2
        y: shovelBank.y + (shovelBank.height - height) / 2
    }
    MenuButton {
        id: menuButton

        anchors.right: parent.right
        height: parent.height * 0.07
        visible: false
        width: height / 184 * 468
        y: 0

        onTriggered: {
            menuDialog.open();
            menuDialog.forceActiveFocus();
        }
    }
    MenuDialog {
        id: menuDialog

        anchors.centerIn: parent
        height: parent.height * 0.8
        width: height / 1936 * 1660

        onBackToGame: {
            close();
            menuButton.forceActiveFocus();
        }
        onBackToMainMenu: root.backToMainMenu()
    }
}