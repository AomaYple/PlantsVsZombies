import QtQuick

Item {
    id: root

    function emerge() {
        emerge.start();
    }

    height: width / 446 * 87
    width: parent.width * 0.6
    x: parent.width * 0.01
    y: -height

    Image {
        anchors.fill: parent
        asynchronous: true
        mipmap: true
        source: '../../resources/scenes/seedBank.png'
        sourceSize: Qt.size(width, height)

        Text {
            color: '#000000'
            text: '50'
            x: parent.width * 0.078
            y: parent.height * 0.72

            font {
                bold: true
                pointSize: height > 0 ? height * 5 : 1
            }
        }
    }
    YAnimator {
        id: emerge

        duration: 500
        target: root
        to: 0
    }
}
