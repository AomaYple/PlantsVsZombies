function getRandomFloat(min, max) {
    return Math.random() * (max - min) + min;
}

function createBasicZombieStand() {
    const component = Qt.createComponent(rootPath + '/src/zombies/BasicZombieStand.qml');
    const zombieHeight = image.height * 0.23;
    const incubator0 = component.incubateObject(image, {
        height: Qt.binding(function () {
            return zombieHeight;
        }),
        x: Qt.binding(function () {
            return image.width * 0.8;
        }),
        y: Qt.binding(function () {
            return image.height * 0.15
        })
    });
    xAnimator.readied.connect(function () {
        incubator0.object.destroy();
    });
    const incubator1 = component.incubateObject(image, {
        height: Qt.binding(function () {
            return zombieHeight;
        }),
        x: Qt.binding(function () {
            return image.width * 0.83;
        }),
        y: Qt.binding(function () {
            return image.height * 0.4
        })
    });
    xAnimator.readied.connect(function () {
        incubator1.object.destroy();
    });
    const incubator2 = component.incubateObject(image, {
        height: Qt.binding(function () {
            return zombieHeight;
        }),
        x: Qt.binding(function () {
            return image.width * 0.9;
        }),
        y: Qt.binding(function () {
            return image.height * 0.6
        })
    });
    xAnimator.readied.connect(function () {
        incubator2.object.destroy();
    });
    const incubator3 = component.incubateObject(image, {
        height: Qt.binding(function () {
            return zombieHeight;
        }),
        x: Qt.binding(function () {
            return image.width * 0.85;
        }),
        y: Qt.binding(function () {
            return image.height * 0.7
        })
    });
    xAnimator.readied.connect(function () {
        incubator3.object.destroy();
    });
}

function generateSunlight(position, endPositionY, natural, upPositionY) {
    const incubator = sunlightProducer.sunlightComponent.incubateObject(image, {
        natural: Qt.binding(function () {
            return natural;
        }),
        height: Qt.binding(function () {
            return image.height * 0.14;
        }),
        paused: Qt.binding(function () {
            return image.paused;
        }),
        x: Qt.binding(function () {
            return position.x;
        }),
        y: Qt.binding(function () {
            return position.y;
        }),
        upPositionY: Qt.binding(function () {
            return upPositionY;
        }),
        endPositionY: Qt.binding(function () {
            return endPositionY;
        }),
        collectedPosition: Qt.binding(function () {
            return Qt.point(image.leftMargin + image.width * 0.008, -image.height * 0.01);
        })
    });
    incubator.onStatusChanged = function (status) {
        if (status === Component.Ready) {
            const sunlight = incubator.object;
            sunlight.collected.connect(
                function () {
                    seedBank.increaseSunlight();
                }
            );
        }
    };
}

function naturalGenerateSunlight() {
    const sunlightHeight = image.height * 0.14;
    generateSunlight(Qt.point(getRandomFloat(image.leftMargin, image.width - image.rightMargin - sunlightHeight),
        image.height * 0.2), getRandomFloat(image.height * 0.4, image.height - sunlightHeight), true, null);
}

function plant(properties, subPlantAreaId) {
    const incubator = previewPlant.plantComponent.incubateObject(image, {
        height: Qt.binding(function () {
            return properties.height;
        }),
        x: Qt.binding(function () {
            return properties.x;
        }),
        y: Qt.binding(function () {
            return properties.y;
        }),
        paused: Qt.binding(function () {
            return image.paused;
        }),
        shoveling: Qt.binding(function () {
            return shovelBank.shoveling && subPlantAreaId.containsMouse;
        })
    });
    incubator.onStatusChanged = function (status) {
        if (status === Component.Ready) {
            const plant = incubator.object;
            const index = subPlantAreaId.index;
            plantArea.plants[index[0]][index[1]] = plant;
            subPlantAreaId.eradicated.connect(function () {
                plant.destroy();
                plantArea.plants[index[0]][index[1]] = null;
            });
            switch (plant.type) {
                case Plants.PlantType.Type.Sunflower:
                    plant.sunlightProduced.connect(function () {
                        generateSunlight(Qt.point(plant.x, plant.y), plant.y + plant.height * 0.5, false,
                            plant.y - plant.height * 0.5);
                    });
                    break;
            }
        }
    };
}
